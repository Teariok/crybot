package Rive::RiveScript::Parser;

use strict;
use warnings;

our $VERSION = '0.04';

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto || 'Rive::RiveScript::Parser';

	my $self = {
		debug         => 1,
		reserved      => [],    # Array of reserved names
		replies       => {},    # Replies hash
		array         => {},    # Array hash for sorting
		thatarray     => [],    # Previous arrays
		syntax        => {},    # Log of file lines and names
		streamcache   => undef, # Cache from stream()
		botvars       => {},    # Bot Variables
		substitutions => {},    # Substitution Data
		person        => {},    # Person Tags
		botarrays     => {},    # Bot Arrays
		sort          => {},    # For reply sorting
		macros        => {},    # Objects
		library       => ['.'], # Include Libraries
		evals         => undef, # Code to evaluate
		@_,
	};

	# Include Libraries.
	foreach my $inc (@INC) {
		push (@{$self->{library}}, "$inc/RiveScript/RSLIB");
	}

	bless ($self,$class);
	return $self;
}

sub debug {
	my ($self,$msg) = @_;

	print "Rive::RiveScript::Parser // $msg\n" if $self->{debug} == 1;
}

sub loadFile {
	my $self = shift;
	my $file = shift || '(Streamed)';
	my $stream = shift || 0;

	$self->{evals} = '';

	# Prepare to load the file.
	my @data = ();

	# Streaming in replies?
	if ($stream) {
		@data = split(/\n/, $self->{streamcache});
		chomp @data;
	}
	else {
		open (FILE, $file);
		@data = <FILE>;
		close (FILE);
		chomp @data;
	}

	$self->debug ("Parsing in file $file");

	# Set up parser variables.
	my $started = 0;        # Haven't found a trigger yet
	my $inReply = 0;        # Not in a reply yet
	my $inCom   = 0;        # Not in commented code
	my $inObj   = 0;        # In an object.
	my $objName = '';       # Object's name
	my $objCode = '';       # Object's source.
	my $topic   = 'random'; # Default topic
	my $trigger = '';       # The trigger we're on
	my $replies = 0;        # -REPLY counter
	my $conds   = 0;        # *CONDITION counter
	my $num     = 0;        # Line numbers.
	my $conc    = 0;        # Concetanate the last command (0.06)
	my $lastCmd = '';       # The last command used (0.06)
	my @thats   = ();       # For sorting "that's"

	# Go through the file.
	foreach my $line (@data) {
		$num++;

		# If in an object...
		if ($inObj == 1) {
			if ($line !~ /< object/i) {
				$objCode .= "$line\n";
				next;
			}
		}

		# Format the line.
		$self->debug ("Line $num ($inCom): $line");
		next if length $line == 0; # Skip blank lines
		$line =~ s/^[\s\t]*//ig;     # Remove prepent whitepaces
		$line =~ s/[\s\t]*$//ig;     # Remove appent whitespaces

		# Separate the command from its data.
		my ($command,$data) = split(/\s+/, $line, 2);

		# Filter in hard spaces.
		$data =~ s/\\s/ /g if defined $data;

		# Filter in undefined characters.
		$data =~ s/\\u//g if defined $data;

		# Check for comment commands...
		if ($command =~ m~^(//|#)~) {
			# Single comment.
			next unless $inCom;
		}
		if ($command eq '/*') {
			# We're starting a comment section.
			if (defined $data && $data =~ /\*\//) {
				# The section was ended here too.
				next;
			}
			$inCom = 1;
		}
		if ($command eq '*/' || (defined $data && $data =~ /\*\//)) {
			$inCom = 0;
			next;
		}

		# Skip comments.
		next if $inCom;

		next unless length $command;

		# Remove in-line comments.
		my ($save,$void) = split(/\s+(\/\/|#)\s+/, $data, 2);
		$data = $save;

		# See if we're denying use of any commands.
		if ($self->{strict_type} ne 'allow_all') {
			if ($self->{strict_type} eq 'allow_some') {
				my $ok = 0;
				foreach my $item (@{$self->{cmd_allowed}}) {
					my $allow = $item;
					if (length $allow == 1) {
						# A simple command.
						if ($command eq $allow) {
							$ok = 1;
						}
					}
					else {
						# A more complex one.
						$allow =~ s/\s+//g;
						my $check = $line;
						$check =~ s/\s+//g;
						$allow =~ s/([^A-Za-z0-9 <>=_])/\\$1/ig;

						print "Checking $check =~ /^$allow/i\n";

						if ($check =~ /^$allow/i) {
							$ok = 1;
						}
					}
				}
				unless ($ok) {
					warn "The command $command at $file line $num is disallowed by your interpreter (allow_some)";
					next;
				}
			}
			elsif ($self->{strict_type} eq 'deny_some') {
				my $ok = 1;
				foreach my $item (@{$self->{cmd_denied}}) {
					my $allow = $item;
					if (length $allow == 1) {
						# A simple command.
						if ($command eq $allow) {
							$ok = 0;
						}
					}
					else {
						# A more complex one.
						$allow =~ s/\s+//g;
						my $check = $line;
						$check =~ s/\s+//g;
						$allow =~ s/([^A-Za-z0-9 <>=_])/\\$1/ig;

						if ($check =~ /^$allow/i) {
							$ok = 0;
						}
					}
				}
				unless ($ok) {
					warn "The command $command at $file line $num is disallowed by your interpreter (deny_some)";
					next;
				}
			}
		}

		# Concatenate previous commands.
		if ($command eq '^') {
			$self->debug ("^ Command - Command Continuation");

			if ($lastCmd =~ /^\! global (.*?)$/i) {
				my $var = $1;
				$self->{$var} .= $data;
			}
			elsif ($lastCmd =~ /^\! var (.*?)$/i) {
				my $var = $1;
				$self->{botvars}->{$var} .= $data;
			}
			elsif ($lastCmd =~ /^\! array (.*?)$/i) {
				my $var = $1;
				if ($data =~ /\|/) {
					my @words = split(/\|/, $data);
					push (@{$self->{botarrays}->{$var}}, @words);
				}
				else {
					my @words = split(/\s+/, $data);
					push (@{$self->{botarrays}->{$var}}, @words);
				}
			}
			elsif ($lastCmd =~ /^\+ (.*?)$/i) {
				my $tr = $1;
				$trigger = $tr . $data;
			}
			elsif ($lastCmd =~ /^\% (.*?)$/i) {
				my $that = $1;
				$topic .= $data;
			}
			elsif ($lastCmd =~ /^\@ (.*?)$/i) {
				my $at = $1;
				$self->{replies}->{$topic}->{$trigger}->{redirect} .= $data;
			}
			else {
				# Normal behavior
				$self->{replies}->{$topic}->{$trigger}->{$replies} .= $data;
			}

			next;
		}

		# Go through actual commands.
		if ($command eq '>') {
			$self->debug ("> Command - Label Begin!");
			my ($type,$text) = split(/\s+/, $data, 2);
			if ($type eq 'topic') {
				$self->debug ("\tTopic set to $text");
				$topic = $text;
			}
			elsif ($type eq 'begin') {
				$self->debug ("\tA begin handler");
				$topic = '__begin__';
			}
			elsif ($type eq 'object') {
				$self->debug ("\tAn object");
				$objName = $text || 'unknown';
				$inObj = 1;
			}
			else {
				warn "Unknown label type at $file line $num";
			}
		}
		elsif ($command eq '<') {
			$self->debug ("< Command - Label End!");
			if ($data eq 'topic' || $data eq '/topic' || $data eq 'begin' || $data eq '/begin') {
				$self->debug ("\tTopic reset!");
				$topic = 'random';
			}
			elsif ($data eq 'object') {
				# Save the object.
				my $code = "\$self->setSubroutine ($objName => \\&rscode_$objName);\n\n"
					. "sub rscode_$objName {\n"
					. "$objCode\n"
					. "}\n";

				$self->{evals} .= $code;
				my $eval = eval $code;
				$inObj = 0;
				$objName = '';
				$objCode = '';
			}
			else {
				warn "Unknown label ender at $file line $num";
			}
		}
		elsif ($command eq '!') {
			$self->debug ("! Command - Definition");

			my ($type,$details) = split(/\s+/, $data, 2);
			my ($what,$is) = split(/=/, $details, 2);
			$what =~ s/\s//g if defined $what;
			$is =~ s/^\s//g if defined $is;
			$type =~ s/\s//g;
			$type = lc($type);

			# Globals?
			if ($type eq 'global') {
				my $err = 0;
				foreach my $reserved (@{$self->{reserved}}) {
					if ($what eq $reserved) {
						$err = 1;
						last;
					}
				}

				# Skip if there was a problem.
				if ($err) {
					warn "Can't modify reserved global $what";
					next;
				}

				$lastCmd = "! global $what";

				# Set this top-level global.
				if ($is ne 'undef') {
					$self->debug ("\tSet global $what = $is");
					$self->{$what} = $is;
				}
				else {
					$self->debug ("\tDeleting global $what");
					delete $self->{$what};
				}
			}
			elsif ($type eq 'var') {
				# Can't overwrite reserved variables.
				my $err = undef;
				if ($what =~ /^env_/i) {
					$err = "Can't modify an environmental variable!";
				}

				if ($err) {
					warn "$err";
					next;
				}

				# Set a botvariable.
				$lastCmd = "! var $what";
				if ($is ne 'undef') {
					$self->debug ("\tSet botvar $what = $is");
					$self->{botvars}->{$what} = $is;
				}
				else {
					$self->debug ("\tDeleting botvar $what");
					delete $self->{botvars}->{$what};
				}
			}
			elsif ($type eq 'array') {
				# An array.
				$lastCmd = "! array $what";

				# Delete the array?
				if ($is eq 'undef') {
					$self->debug ("\tDeleting array $what");
					delete $self->{botarrays}->{$what};
					next;
				}

				$self->debug ("\tSetting array $what = $is");
				my @array = ();

				# Does it contain pipes?
				if ($is =~ /\|/) {
					# Split at them.
					@array = split(/\|/, $is);
				}
				else {
					# Split at spaces.
					@array = split(/\s+/, $is);
				}

				# Keep them.
				$self->{botarrays}->{$what} = [ @array ];
			}
			elsif ($type eq 'sub') {
				# Substitutions.

				if ($is ne 'undef') {
					$self->debug ("\tSet substitution $what = $is");
					$self->{substitutions}->{$what} = $is;
				}
				else {
					$self->debug ("\tDeleting substitution $what");
					delete $self->{substitutions}->{$what};
				}
			}
			elsif ($type eq 'person') {
				# Person substitutions.

				if ($is ne 'undef') {
					$self->debug ("\tSet person $what = $is");
					$self->{person}->{$what} = $is;
				}
				else {
					$self->debug ("\tDeleting person $what");
					delete $self->{person}->{$what};
				}
			}
			elsif ($type eq 'addpath') {
				# Add a search path.
				if (defined $what) {
					push (@{$self->{library}}, $what);
				}
			}
			elsif ($type eq 'include') {
				# An Include Directive

				my $found = 0;
				my $path = '';
				foreach my $inc (@{$self->{library}}) {
					if (-e "$inc/$what") {
						$found = 1;
						$path = "$inc/$what";
						last;
					}
				}

				$self->loadFile ("$path");
			}
			elsif ($type eq 'syslib') {
				# Include a system library

				my $lib = $what;
				if ($lib =~ /[^A-Za-z0-9:_\(\) ]/i) {
					warn "Cannot load syslib $what: bad module name at $file line $num";
				}
				else {
					eval ("use $what;");
				}
			}
			else {
				warn "Unsupported type at $file line $num";
			}
		}
		elsif ($command eq '+') {
			$self->debug ("+ Command - Reply Trigger!");

			if ($inReply == 1) {
				# Reset the topics?
				if ($topic =~ /^__that__/i) {
					$topic = 'random';
				}

				# New reply.
				$inReply = 0;
				$trigger = '';
				$replies = 0;
				$conds = 0;
			}

			# Reply trigger.
			$inReply = 1;
			$trigger = $data;
			$lastCmd = "+ $trigger";
			$self->debug ("\tTrigger: $trigger");

			# Set the trigger under its topic.
			$self->{replies}->{$topic}->{$trigger}->{topic} = $topic;
			$self->{syntax}->{$topic}->{$trigger}->{ref} = "$file line $num";
		}
		elsif ($command eq '%') {
			$self->debug ("% Command - Previous!");

			if ($inReply != 1) {
				# Error.
				warn "Syntax error at $file line $num";
				next;
			}

			# Save this one for sorting.
			push (@thats,$data);

			# Set the topic to "__that__$data"
			$lastCmd = "\% $data";
			$topic = "__that__$data";
		}
		elsif ($command eq '-') {
			$self->debug ("- Command - Response!");

			$lastCmd = ''; # -Reply is the default usage for ^Continue

			if ($inReply != 1) {
				# Error.
				warn "Syntax error at $file line $num";
				next;
			}

			# Reply response.
			$replies++;

			$self->{replies}->{$topic}->{$trigger}->{$replies} = $data;
			$self->{syntax}->{$topic}->{$trigger}->{$replies}->{ref} = "$file line $num";
		}
		elsif ($command eq '@') {
			$self->debug ("\@ Command - Redirect");

			if ($inReply != 1) {
				# Error.
				warn "Syntax error at $file line $num";
				next;
			}

			$lastCmd = "\@ $data";

			$self->{replies}->{$topic}->{$trigger}->{redirect} = $data;
			$self->{syntax}->{$topic}->{$trigger}->{redirect}->{ref} = "$file line $num";
		}
		elsif ($command eq '*') {
			$self->debug ("* Command - Conditional");

			if ($inReply != 1) {
				# Error.
				warn "Syntax error at $file line $num";
				next;
			}

			$conds++;
			$self->{replies}->{$topic}->{$trigger}->{conditions}->{$conds} = $data;
			$self->{syntax}->{$topic}->{$trigger}->{conditions}->{$conds}->{ref} = "$file line $num";
		}
		elsif ($command eq '&') {
			$self->debug ("\& Command - Perl Code");

			if ($inReply != 1) {
				# Error.
				warn "Syntax error at $file line $num";
				next;
			}

			$self->{replies}->{$topic}->{$trigger}->{system}->{codes} .= $data;
			$self->{syntax}->{$topic}->{$trigger}->{system}->{codes}->{ref} = "$file line $num";
		}
		else {
			warn "Unknown command $command at $file line $num;";
		}
	}

	if (scalar(@thats)) {
		$self->sortThats (@thats);
	}
}

sub sortReplies {
	my ($self) = @_;

	# Reset defaults.
	$self->{sort}->{replycount} = 0;

	# Fail if replies hadn't been loaded.
	return 0 unless (scalar (keys %{$self->{replies}}));

	# Delete the replies array if it exists.
	if (exists $self->{array}) {
		delete $self->{array};
	}

	$self->debug ("Sorting the replies...");

	# Count them while we're at it.
	my $count = 0;

	# Go through each reply.
	foreach my $topic (keys %{$self->{replies}}) {
		# print "Sorting replies under topic $topic...\n";

		# Sort by number of whole words (or, not wildcards).
		my $sort = {
			def => [],
			unknown => [],
		};
		for (my $i = 0; $i <= 50; $i++) {
			$sort->{$i} = [];
		}

		# Set trigger arrays.
		my @trigNorm = ();
		my @trigWild = ();

		# Go through each item.
		foreach my $key (keys %{$self->{replies}->{$topic}}) {
			$count++;

			# print "\tSorting $key\n";

			# If this has wildcards...
			if ($key =~ /\*/) {
				# See how many full words it has.
				my @words = split(/\s/, $key);
				my $cnt = 0;
				foreach my $word (@words) {
					$word =~ s/\s//g;
					next unless length $word;
					if ($word !~ /\*/) {
						# A whole word.
						$cnt++;
					}
				}

				# What did we get?
				$cnt = 50 if $cnt > 50;

				# print "\t\tWildcard with $cnt words\n";

				if (exists $sort->{$cnt}) {
					push (@{$sort->{$cnt}}, $key);
				}
				else {
					push (@{$sort->{unknown}}, $key);
				}
			}
			else {
				# Save to normal array.
				# print "\t\tNormal trigger\n";
				push (@{$sort->{def}}, $key);
			}
		}

		# Merge all the arrays.
		$self->{array}->{$topic} = [
			@{$sort->{def}},
		];
		for (my $i = 50; $i >= 1; $i--) {
			push (@{$self->{array}->{$topic}}, @{$sort->{$i}});
		}
		push (@{$self->{array}->{$topic}}, @{$sort->{unknown}});
		push (@{$self->{array}->{$topic}}, @{$sort->{0}});
	}

	# Save the count.
	$self->{sort}->{replycount} = $count;
	return 1;
}

sub sortThats {
	my ($self,@thats) = @_;

	# Fail if no that's are provided.
	return 0 unless (scalar (@thats));

	# Delete the replies array if it exists.
	if (scalar(@{$self->{thatarray}})) {
		push (@thats, @{$self->{thatarray}});
	}

	$self->debug ("Sorting the that's...");

	# Sort by number of whole words (or, not wildcards).
	my $sort = {
		def => [],
		unknown => [],
	};
	for (my $i = 0; $i <= 50; $i++) {
		$sort->{$i} = [];
	}

	# Set trigger arrays.
	my @trigNorm = ();
	my @trigWild = ();

	# Go through each item.
	foreach my $key (@thats) {

		# If this has wildcards...
		if ($key =~ /\*/) {
			# See how many full words it has.
			my @words = split(/\s/, $key);
			my $cnt = 0;
			foreach my $word (@words) {
				$word =~ s/\s//g;
				next unless length $word;
				if ($word !~ /\*/) {
					# A whole word.
					$cnt++;
				}
			}

			# What did we get?
			$cnt = 50 if $cnt > 50;

			if (exists $sort->{$cnt}) {
				push (@{$sort->{$cnt}}, $key);
			}
			else {
				push (@{$sort->{unknown}}, $key);
			}
		}
		else {
			# Save to normal array.
			push (@{$sort->{def}}, $key);
		}
	}

	# Merge all the arrays.
	$self->{thatarray} = [
		@{$sort->{def}},
	];
	for (my $i = 50; $i >= 1; $i--) {
		push (@{$self->{thatarray}}, @{$sort->{$i}});
	}
	push (@{$self->{thatarray}}, @{$sort->{unknown}});
	push (@{$self->{thatarray}}, @{$sort->{0}});

	return 1;
}

sub write {
	my $self = shift;
	my $to = shift || 'written.rs';

	my @file = ();

	# Write all replies to file.
	foreach my $topic (keys %{$self->{replies}}) {
		if ($topic eq 'random' || $topic =~ /^__that__/i) {
			# Don't add this in.
		}
		elsif ($topic eq '__begin__') {
			push (@file, "> begin");
			push (@file, "");
		}
		else {
			push (@file, "> topic $topic");
			push (@file, "");
		}

		# Get all triggers.
		foreach my $t (keys %{$self->{replies}->{$topic}}) {
			push (@file, "+ $t");

			# Get conditions
			for (my $i = 1; exists $self->{replies}->{$topic}->{$t}->{conditions}->{$i}; $i++) {
				my $line = $self->{replies}->{$topic}->{$t}->{conditions}->{$i};
				push (@file, "* $line");
			}

			# Get all the replies.
			for (my $i = 1; exists $self->{replies}->{$topic}->{$t}->{$i}; $i++) {
				push (@file, "- $self->{replies}->{$topic}->{$t}->{$i}");
			}

			# Get redirections.
			if (exists $self->{replies}->{$topic}->{$t}->{redirect}) {
				my $redir = $self->{replies}->{$topic}->{$t}->{redirect};
				push (@file, "\@ $redir");
			}

			# Get sys codes.
			if (exists $self->{replies}->{$topic}->{$t}->{system}->{codes}) {
				my $sys = $self->{replies}->{$topic}->{$t}->{system}->{codes};
				push (@file, "& $sys");
			}

			push (@file, "");
		}

		if ($topic eq 'random' || $topic =~ /^__that__/i) {
			# Don't add this in.
		}
		elsif ($topic eq '__begin__') {
			push (@file, "< begin");
			push (@file, "");
		}
		else {
			push (@file, "< topic");
			push (@file, "");
		}
	}

	open (OUT, ">$to") or return 0;
	print OUT join ("\n", @file);
	close (OUT);

	return 1;
}

=head1 NAME

RiveScript::Parser -- Read and Write routines for RiveScript documents.

=head1 DESCRIPTION

This module is used by B<RiveScript> for reading and writing of RiveScript documents.

=head1 METHODS

=head2 new()

Create a new parser. Takes all the same arguments as B<RiveScript> does.

=head2 debug()

Prints a debug message (internal).

=head2 loadFile()

Load in a single file. Takes the same arguments as B<RiveScript::loadFile>

=head2 sortReplies()

Sort the replies. Takes the same arguments as B<RiveScript::sortReplies>

=head2 sortThats()

Sort all the values of "%PREVIOUS" in the same fashion that replies are sorted.

=head2 write()

Writes the loaded replies to a file. Takes the same arguments as B<RiveScript::write>

=head1 SEE ALSO

The B<RiveScript> manpage.

=head1 AUTHOR

  Cerone Kirsle, kirsle --at-- rainbowboi.com

=head1 COPYRIGHT AND LICENSE

    RiveScript - Rendering Intelligence Very Easily
    Copyright (C) 2006  Cerone J. Kirsle

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

=cut
