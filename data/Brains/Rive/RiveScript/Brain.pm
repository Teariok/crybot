package Rive::RiveScript::Brain;

use strict;
use warnings;
use Rive::RiveScript::Util;

our $VERSION = '0.03';

sub reply {
	my $self = shift;
	my $id = shift;
	my $msg = shift;

	my %args = (
		scalar   => 0, # Force scalar return
		no_split => 0, # No sentence-splitting
		retry    => 0, # DO NOT RECONFIGURE THIS
		@_,
	);

	# Reset loops.
	$self->{loops} = 0;

	# print "reply called\n";

	# Send this through the "BEGIN" reply first.
	my $begin = '{ok}';
	if (exists $self->{replies}->{__begin__}->{request}) {
		my $userTopic = $self->{users}->{$id}->{topic} || 'random';
		$self->{users}->{$id}->{topic} = '__begin__';
		$begin = $self->intReply ($id,'request', tags => 0);
		$self->{users}->{$id}->{topic} = $userTopic;

		# Prerun any topic tags present.
		if ($begin =~ /\{topic=(.*?)\}/i) {
			my $to = $1;
			$self->{users}->{$id}->{topic} = $to;
			$begin =~ s/\{topic=(.*?)\}//g;
		}
	}

	my @out = ();
	if ($begin =~ /\{ok\}/i) {
		# Format their message.
		unless ($args{no_split}) {
			my @sentences = $self->splitSentences ($msg);
			foreach my $in (@sentences) {
				$in = $self->formatMessage ($in);
				next unless length $in > 0;
				# print "Sending sentence \"$in\" in...\n";
				my @returned = $self->intReply ($id,$in);
				push (@out,@returned);
			}
		}
		else {
			$msg = $self->formatMessage ($msg);
			my @returned = $self->intReply ($id,$msg);
			push (@out,@returned);
		}

		my @final = ();

		my $reply = $begin;
		foreach (@out) {
			$reply =~ s/\{ok\}/$_/ig;
			$reply = $self->tagFilter ($reply,$id,$msg);
			push (@final,$reply);
		}

		# Get it in scalar form.
		my $scalar = join (" ", @final);

		# Run final filters on it (for begin statement's sake).
		# $scalar = $self->tagFilter ($scalar,$id,$msg);

		# If no reply, try again without sentence-splitting.
		if (($scalar =~ /^ERR: No Reply/ || length $scalar == 0) && $args{retry} != 1) {
			my @array = $self->reply ($id,$msg, no_split => 1, retry => 1, scalar => 0);
			(@final) = (@array);
		}

		# Return in scalar form?
		if ($args{scalar}) {
			return join (" ", @final);
		}

		return (@final);
	}
	else {
		# Run tag filters anyway.
		my $userTopic = $self->{users}->{$id}->{topic} || 'random';
		$self->{users}->{$id}->{topic} = '__begin__';
		$begin = $self->tagFilter ($begin,$id,$msg);
		$self->{users}->{$id}->{topic} = $userTopic;
		return $begin;
	}
}

sub intReply {
	my ($self,$id,$msg,%inArgs) = @_;
	$inArgs{tags} = 1 unless exists $inArgs{tags};

	# Sort replies if they haven't been yet.
	if (!(scalar(keys %{$self->{array}}))) {
		warn "You should sort replies BEFORE calling reply()!";
		$self->sortReplies;
	}

	# Create this user's history.
	if (!exists $self->{users}->{$id}->{history}) {
		$self->{users}->{$id}->{history}->{input} = ['', 'undefined', 'undefined', 'undefined', 'undefined',
			'undefined', 'undefined', 'undefined', 'undefined', 'undefined' ];
		$self->{users}->{$id}->{history}->{reply} = ['', 'undefined', 'undefined', 'undefined', 'undefined',
			'undefined', 'undefined', 'undefined', 'undefined', 'undefined' ];
		# print "\tCreated user history\n";
	}

	# Too many loops?
	if ($self->{loops} >= 15) {
		$self->{loops} = 0;
		my $topic = $self->{users}->{$id}->{topic} || 'random';
		return "ERR: Deep Recursion (15+ loops in reply set) at $self->{syntax}->{$topic}->{$msg}->{redirect}->{ref}";
	}

	# Create variables.
	my @stars = (); # Wildcard captors
	my $reply; # The final reply.

	# Topics?
	$self->{users}->{$id}->{topic} ||= 'random';

	# Setup the user's temporary history.
	$self->{users}->{$id}->{last} = '' unless exists $self->{users}->{$id}->{last}; # Last Msg
	$self->{users}->{$id}->{that} = '' unless exists $self->{users}->{$id}->{that}; # Bot Last Reply

	# Make sure some replies are loaded.
	if (!exists $self->{replies}) {
		return "ERR: No replies have been loaded!";
	}

	# See if this topic has any "that's" associated with it.
	my $thatTopic = "__that__$self->{users}->{$id}->{that}";
	my $lastSent = $self->{users}->{$id}->{that};
	my $isThat = 0;
	my $keepTopic = '';

	# Go through each reply.
	# print "Scanning through topics...\n";
	foreach my $topic (keys %{$self->{array}}) {
		# print "\tOn Topic: $topic\n";

		# New code: check for "that's" against a regexp.
		if ($isThat != 1 && length $lastSent > 0 && $self->{users}->{$id}->{topic} ne '__begin__') {
			($isThat,$thatTopic) = Rive::RiveScript::Brain::checkThat ($self,$lastSent);

			if ($isThat == 1) {
				$keepTopic = $self->{users}->{$id}->{topic};
				$self->{users}->{$id}->{topic} = $thatTopic;
			}
		}

	#	if ($isThat != 1 && length $lastSent > 0 && exists $self->{replies}->{$thatTopic}->{$msg}) {
	#		# It does exist. Set this as the topic so this reply should be matched.
	#		$isThat = 1;
	#		$keepTopic = $self->{users}->{$id}->{topic};
	#		$self->{users}->{$id}->{topic} = $thatTopic;
	#	}

		# Don't look at topics that aren't ours.
		next unless $topic eq $self->{users}->{$id}->{topic};

		# Check the inputs.
		foreach my $in (@{$self->{array}->{$topic}}) {
			last if defined $reply;
			# Slightly format the trigger to be regexp friendly.
			my $regexp = $in;
			$regexp =~ s~\*~(.*?)~g;

			# Run optional modifiers.
			while ($regexp =~ /\[(.*?)\]/i) {
				my $o = $1;
				my @parts = split(/\|/, $o);
				my @new = ();

				foreach my $word (@parts) {
					$word = '\s*' . $word . '\s*';
					push (@new,$word);
				}

				push (@new,'\s*');
				my $rep = '(' . join ('|',@new) . ')';

				$regexp =~ s/\s*\[(.*?)\]\s*/$rep/i;
			}

			# Filter in arrays.
			while ($regexp =~ /\@(.+?)\b/i) {
				my $o = $1;
				my $name = $o;
				my $rep = '';
				if (exists $self->{botarrays}->{$name}) {
					$rep = '(?:' . join ('|', @{$self->{botarrays}->{$name}}) . ')';
				}
				$regexp =~ s/\@$o\b/$rep/ig;
			}

			# Filter in botvariables.
			while ($regexp =~ /<bot (.*?)>/i) {
				my $o = $1;
				my $value = $self->{botvars}->{$o};
				$value =~ s/[^A-Za-z0-9 ]//g;
				$value = lc($value);
				$regexp =~ s/<bot (.*?)>/$value/i;
			}

			# print "\tComparing $msg with $regexp\n";

			# See if it's a match.
			if ($msg =~ /^$regexp$/i) {
				# Collect the stars.
				@stars = $msg =~ /^$regexp$/i;
				unshift (@stars, ''); # Make $stars[1] equal <star1>

				# A solid redirect? (@ command)
				if (exists $self->{replies}->{$topic}->{$in}->{redirect}) {
					my $redirect = $self->{replies}->{$topic}->{$in}->{redirect};

					# Filter wildcards into it.
					$redirect = $self->mergeWildcards ($redirect,\@stars);

					# Plus a loop.
					$self->{loops}++;
					$reply = $self->intReply ($id,$redirect);
					return $reply;
				}

				# Check for conditionals.
				if (exists $self->{replies}->{$topic}->{$in}->{conditions}) {
					for (my $c = 1; exists $self->{replies}->{$topic}->{$in}->{conditions}->{$c}; $c++) {
						last if defined $reply;

						my $condition = $self->{replies}->{$topic}->{$in}->{conditions}->{$c};
						my ($cond,$happens) = split(/=>/, $condition, 2);
						$cond =~ s/\s$//g;
						$happens =~ s/^\s//g;

						# Find out what type of condition this is.
						if ($cond =~ /^(.*?)(=|!=|<=|>=|<|>|\?)(.*?)$/i) {
							my ($var,$type,$value) = ($1,$2,$3);

							$var =~ s/\s+$//g; $var =~ s/^\s+//g;
							$value =~ s/\s+$//g; $value =~ s/^\s+//g;

							# If this is specifically a botvariable...
							my $isBotVar = 0;
							my $checkUser = 1;
							if ($var =~ /^\#/) {
								$isBotVar = 1;
								$var =~ s/^\#//g;
							}

							# Get candidates for value matches.
							my $botVar = $self->{botvars}->{$var};
							my $usrVar = $self->{uservars}->{$id}->{$var};

							if (defined $botVar || defined $usrVar) {

								# Our check types:
								# =  equal to
								# != not equal
								# <  less than
								# <= less than or equal to
								# >  greater than
								# >= greater than or equal to
								# ?  defined

								if ($type eq '?') {
									if (defined $usrVar) {
										$reply = $happens;
									}
								}
								elsif ($type eq '=') {
									if (defined $botVar || defined $usrVar) {
										if (defined $botVar && $botVar eq $value) {
											$reply = $happens;
											$checkUser = 0;
										}

										if ($checkUser && !$isBotVar && defined $usrVar && $usrVar eq $value) {
											$reply = $happens;
										}
									}
								}
								elsif ($type eq '!=') {
									if (defined $botVar || defined $usrVar) {
										if (defined $botVar && $botVar ne $value) {
											$reply = $happens;
											$checkUser = 0;
										}

										if ($checkUser && !$isBotVar && defined $usrVar && $usrVar ne $value) {
											$reply = $happens;
										}
									}
								}
								elsif ($type eq '<') {
									if (defined $botVar || defined $usrVar) {
										if (defined $botVar && $botVar !~ /[^0-9]/ && $botVar < $value) {
											$reply = $happens;
											$checkUser = 0;
										}

										if ($checkUser && !$isBotVar && defined $usrVar && $usrVar !~ /[^0-9]/ && $usrVar < $value) {
											$reply = $happens;
										}
									}
								}
								elsif ($type eq '<=') {
									if (defined $botVar || defined $usrVar) {
										if (defined $botVar && $botVar !~ /[^0-9]/ && $botVar <= $value) {
											$reply = $happens;
											$checkUser = 0;
										}

										if ($checkUser && !$isBotVar && defined $usrVar && $usrVar !~ /[^0-9]/ && $usrVar <= $value) {
											$reply = $happens;
										}
									}
								}
								elsif ($type eq '>') {
									if (defined $botVar || defined $usrVar) {
										if (defined $botVar && $botVar !~ /[^0-9]/ && $botVar > $value) {
											$reply = $happens;
											$checkUser = 0;
										}

										if ($checkUser && !$isBotVar && defined $usrVar && $usrVar !~ /[^0-9]/ && $usrVar > $value) {
											$reply = $happens;
										}
									}
								}
								elsif ($type eq '>=') {
									if (defined $botVar || defined $usrVar) {
										if (defined $botVar && $botVar !~ /[^0-9]/ && $botVar >= $value) {
											$reply = $happens;
											$checkUser = 0;
										}

										if ($checkUser && !$isBotVar && defined $usrVar && $usrVar !~ /[^0-9]/ && $usrVar >= $value) {
											$reply = $happens;
										}
									}
								}
							}
						}
					}
				}

				# If we have a reply, quit.
				last if defined $reply;

				# Get a random reply now.
				my @random = ();
				my $totweight = 0;
				for (my $i = 1; exists $self->{replies}->{$topic}->{$in}->{$i}; $i++) {
					my $item = $self->{replies}->{$topic}->{$in}->{$i};
					if ($item =~ /\{weight=(.*?)\}/i) {
						my $weight = $1;
						$item =~ s/\{weight=(.*?)\}//g;
						if ($weight !~ /[^0-9]/i) {
							$totweight += $weight;

							for (my $i = $weight; $i >= 0; $i--) {
								push (@random,$item);
							}
						}
						next;
					}
					push (@random, $self->{replies}->{$topic}->{$in}->{$i});
				}

				# print "\@random = " . scalar(@random) . "\n";
				$reply = $random [ int(rand(scalar(@random))) ];

				# Run system commands.
				if (exists $self->{replies}->{$topic}->{$in}->{system}->{codes}) {
					my $eval = eval ($self->{replies}->{$topic}->{$in}->{system}->{codes});
				}
			}
		}
	}

	# Reset "that" topics.
	if ($isThat == 1) {
		$self->{users}->{$id}->{topic} = $keepTopic;
		$self->{users}->{$id}->{that} = '<<undef>>';
	}

	# A reply?
	if (defined $reply) {
		# Filter in stars...
		$reply = $self->tagShortcuts ($reply);
		$reply = $self->mergeWildcards ($reply,\@stars);
	}
	else {
		# Were they in a possibly broken topic?
		if ($self->{users}->{$id}->{topic} ne 'random') {
			if (exists $self->{array}->{$self->{users}->{$id}->{topic}}) {
				$reply = "ERR: No Reply Matched in Topic $self->{users}->{$id}->{topic}";
			}
			else {
				$self->{users}->{$id}->{topic} = 'random'; # Breakaway
				$reply = "ERR: No Reply in Topic $self->{users}->{$id}->{topic} (possibly void topic?)";
			}
		}
		else {
			$reply = "ERR: No Reply Found";
		}
	}

	# Filter tags in.
	$reply = $self->tagFilter ($reply,$id,$msg) if $inArgs{tags};

	# Update history.
	shift (@{$self->{users}->{$id}->{history}->{input}});
	shift (@{$self->{users}->{$id}->{history}->{reply}});
	unshift (@{$self->{users}->{$id}->{history}->{input}}, $msg);
	unshift (@{$self->{users}->{$id}->{history}->{reply}}, $reply);
	unshift (@{$self->{users}->{$id}->{history}->{input}}, '');
	unshift (@{$self->{users}->{$id}->{history}->{reply}}, '');
	pop (@{$self->{users}->{$id}->{history}->{input}});
	pop (@{$self->{users}->{$id}->{history}->{reply}});

	# Format the bot's reply.
	if ($self->{users}->{$id}->{topic} ne '__begin__') {
		# Save this message.
		$self->{users}->{$id}->{that} = $reply;
		$self->{users}->{$id}->{last} = $msg;
		$self->{users}->{$id}->{hold} ||= 0;
	}

	# Reset the loop timer.
	$self->{loops} = 0;

	# There SHOULD be a reply now.
	# Return it in pairs at {nextreply}
	if ($reply =~ /\{nextreply\}/i) {
		my @returned = split(/\{nextreply\}/i, $reply);
		return @returned;
	}

	# Filter in line breaks.
	$reply =~ s/\\n/\n/g;

	return $reply;
}

sub search {
	my ($self,$string) = @_;

	# Search for this string.
	$string = $self->formatMessage ($string);

	my @result = ();
	foreach my $topic (keys %{$self->{array}}) {
		foreach my $trigger (@{$self->{array}->{$topic}}) {
			my $regexp = $trigger;
			$regexp =~ s~\*~\(\.\*\?\)~g;

			# Run optional modifiers.
			while ($regexp =~ /\[(.*?)\]/i) {
				my $o = $1;
				my @parts = split(/\|/, $o);
				my @new = ();

				foreach my $word (@parts) {
					$word = ' ' . $word . ' ';
					push (@new,$word);
				}

				push (@new,' ');
				my $rep = '(' . join ('|',@new) . ')';

				$regexp =~ s/\s*\[(.*?)\]\s*/$rep/g;
			}

			# Filter in arrays.
			while ($regexp =~ /\(\@(.*?)\)/i) {
				my $o = $1;
				my $name = $o;
				my $rep = '';
				if (exists $self->{botarrays}->{$name}) {
					$rep = '(' . join ('|', @{$self->{botarrays}->{$name}}) . ')';
				}
				$regexp =~ s/\(\@$o\)/$rep/ig;
			}

			# Filter in botvariables.
			while ($regexp =~ /<bot (.*?)>/i) {
				my $o = $1;
				my $value = $self->{botvars}->{$o};
				$value =~ s/[^A-Za-z0-9 ]//g;
				$value = lc($value);
				$regexp =~ s/<bot $o>/$value/ig;
			}

			# Match?
			if ($string =~ /^$regexp$/i) {
				push (@result, "$trigger (topic: $topic) at $self->{syntax}->{$topic}->{$trigger}->{ref}");
			}
		}
	}

	return @result;
}

sub checkThat {
	my ($self,$lastSent) = @_;

	# We're looking for any "that's" which match the regexp against $lastSent.
	my $isThat    = 0;
	my $thatTopic = undef;
	$lastSent = Rive::RiveScript::Util::formatMessage ($self->{substitutions},$lastSent);

	foreach my $past (@{$self->{thatarray}}) {
		my $regexp = $past;

		# Run substitutions.
		$regexp =~ s~\*~__rivescript_wildcard__~g;
		$regexp = Rive::RiveScript::Util::formatMessage ($self->{substitutions},$regexp);
		$regexp =~ s~rivescriptwildcard~(.*?)~g;

		# This is a "that" topic. Check it against the regexp.
		if ($lastSent =~ /^$regexp$/i) {
			# It's a match!
			$isThat = 1;
			$thatTopic = "__that__$past";
			last;
		}
	}

	return ($isThat,$thatTopic);
}

=head1 NAME

RiveScript::Brain - Reply-getting routines for B<RiveScript>.

=head1 DESCRIPTION

This module is used by B<RiveScript> for handling the B<reply()>, B<intReply()>, and B<search()> methods.

=head1 METHODS

=head2 reply ($RiveScript, $userID, $message[, %tags])

Returns a reply from the RiveScript brain. Takes the same arguments as B<RiveScript::reply()>

=head2 intReply ($RiveScript, $userID, $message)

The internal reply-getting subroutine.

=head2 search ($RiveScript, $string)

Search the loaded replies for everything that matches B<$string>.

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
