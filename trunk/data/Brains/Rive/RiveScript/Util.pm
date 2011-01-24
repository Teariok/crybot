package Rive::RiveScript::Util;

use strict;
use warnings;

our $VERSION = '0.02';

sub splitSentences {
	my ($splitters,$msg) = @_;

	# Split at sentence-splitters
	my @syms = ();
	my @splitters = split(/\s+/, $splitters);
	foreach my $item (@splitters) {
		$item =~ s/([^A-Za-z0-9 ])/\\$1/g;
		push (@syms,$item);
	}

	my $regexp = join ('|',@syms);

	my @sentences = split(/($regexp)/, $msg);
	return @sentences;
}

sub formatMessage {
	my ($subs,$msg) = @_;

	# Lowercase the string.
	$msg = lc($msg);

	# Get the words and run substitutions.
	my @words = split(/\s+/, $msg);
	my @new = ();
	foreach my $word (@words) {
		if (exists $subs->{$word}) {
			$word = $subs->{$word};
		}
		push (@new, $word);
	}

	# Reconstruct the message.
	$msg = join (' ',@new);

	# Remove punctuation and such.
	$msg =~ s/[^A-Za-z0-9 ]//g;
	$msg =~ s/^\s//g;
	$msg =~ s/\s$//g;

	return $msg;
}

sub person {
	my ($subs,$msg) = @_;

	# Lowercase the string.
	$msg = lc($msg);

	# Get the words and run substitutions.
	my @words = split(/\s+/, $msg);
	my @new = ();
	foreach my $word (@words) {
		if (exists $subs->{$word}) {
			$word = $subs->{$word};
		}
		push (@new, $word);
	}

	# Reconstruct the message.
	$msg = join (' ',@new);

	return $msg;
}

sub tagShortcuts {
	my ($self,$reply) = @_;

	# Run command shortcuts
	$reply =~ s~<person>~{person}<star>{/person}~ig;
	$reply =~ s~<@>~{@<star>}~ig;
	$reply =~ s~<formal>~{formal}<star>{/formal}~ig;
	$reply =~ s~<sentence>~{sentence}<star>{/sentence}~ig;
	$reply =~ s~<uppercase>~{uppercase}<star>{/uppercase}~ig;
	$reply =~ s~<lowercase>~{lowercase}<star>{/lowercase}~ig;

	return $reply;
}

sub tagFilter {
	my ($self,$reply,$id,$msg) = @_;

	# Comment Escapers.
	$reply =~ s~\\/~/~ig;
	$reply =~ s~\\#~#~ig;

	# History tags.
	$reply =~ s/<input(\d)>/$self->{users}->{$id}->{history}->{input}->[$1]/g;
	$reply =~ s/<reply(\d)>/$self->{users}->{$id}->{history}->{reply}->[$1]/g;

	# Insert variables.
	$reply =~ s/<bot (.*?)>/$self->{botvars}->{$1}/g;
	$reply =~ s/<id>/$id/ig;

	# String modifiers.
	while ($reply =~ /\{(formal|uppercase|lowercase|sentence)\}(.*?)\{\/(formal|uppercase|lowercase|sentence)\}/i) {
		my ($type,$string) = ($1,$2);
		$type = lc($type);
		my $o = $string;
		$string = $self->stringUtil ($type,$string);
		$o =~ s/([^A-Za-z0-9 =<>])/\\$1/g;
		$reply =~ s/\{$type\}$o\{\/$type\}/$string/ig;
	}

	# Topic setters.
	if ($reply =~ /\{topic=(.*?)\}/i) {
		my $to = $1;
		$self->{users}->{$id}->{topic} = $to;
		# print "Setting topic to $to\n";
		$reply =~ s/\{topic=(.*?)\}//g;
	}

	# Variable setters?
	while ($reply =~ /\{\!(.*?)\}/i) {
		my $o = $1;
		my $data = $o;
		$data =~ s/^\s//g;
		$data =~ s/\s$//g;

		my ($type,$details) = split(/\s+/, $data, 2);
		my ($what,$is) = split(/=/, $details, 2);
		$what =~ s/\s//g; $is =~ s/^\s//g;
		$type =~ s/\s//g;
		$type = lc($type);

		# Stream this in.
		# print "Streaming in: ! $type $what = $is\n";
		$self->stream ("! $type $what = $is");
		$reply =~ s/\{\!$o\}//i;
	}

	# Sub-replies.
	while ($reply =~ /\{\@(.*?)\}/i) {
		my $o = $1;
		my $trig = $o;
		$trig =~ s/^\s//g;
		$trig =~ s/\s$//g;

		my $resp = $self->intReply ($id,$trig);

		$reply =~ s/\{\@$o\}/$resp/i;
	}

	# Randomness.
	while ($reply =~ /\{random\}(.*?)\{\/random\}/i) {
		my $text = $1;
		my @options = ();

		# Pipes?
		if ($text =~ /\|/) {
			@options = split(/\|/, $text);
		}
		else {
			@options = split(/\s+/, $text);
		}

		my $rep = $options [ int(rand(scalar(@options))) ];
		$reply =~ s/\{random\}(.*?)\{\/random\}/$rep/i;
	}

	# Get/Set uservars?
	while ($reply =~ /<set (.*?)>/i) {
		my $o = $1;
		my $data = $o;
		my ($what,$is) = split(/=/, $data, 2);
		$what =~ s/\s$//g;
		$is =~ s/^\s//g;

		# Set it.
		if ($is eq 'undef') {
			delete $self->{uservars}->{$id}->{$what};
		}
		else {
			# print "Set $what to $is for $id\n";
			$self->{uservars}->{$id}->{$what} = $is;
		}

		$reply =~ s/<set (.*?)>//i;
	}
	while ($reply =~ /<(add|sub|mult|div) (.*?)>/i) {
		my $method = $1;
		my $o = $2;
		my $data = $o;
		my ($what,$is) = split(/=/, $data, 2);

		# See if this variable exists.
		if (!exists $self->{uservars}->{$id}->{$what}) {
			$self->{uservars}->{$id}->{$what} = 0; # Make it numeric
		}

		# Only accept numeric variables.
		if ($self->{uservars}->{$id}->{$what} =~ /[^0-9]/) {
			$reply =~ s/<$method $o>/(Var=NaN)/i;
			next;
		}
		elsif ($is =~ /[^0-9]/) {
			$reply =~ s/<$method $o>/(Value=NaN)/i;
			next;
		}

		# Do the operation.
		my $value = $self->{uservars}->{$id}->{$what} || 0;
		if ($method =~ /add/i) {
			$value += $is;
		}
		elsif ($method =~ /sub/i) {
			$value -= $is;
		}
		elsif ($method =~ /mult/i) {
			$value *= $is;
		}
		elsif ($method =~ /div/i) {
			$value /= $is;
		}

		$self->{uservars}->{$id}->{$what} = $value;

		$reply =~ s/<$method $o>//i;
	}
	while ($reply =~ /<get (.*?)>/i) {
		my $o = $1;
		my $data = $o;
		my $value = 'undefined';
		$value = $self->{uservars}->{$id}->{$data} if defined $self->{uservars}->{$id}->{$data};

		# print "Inserting $data ($value)\n";

		$reply =~ s/<get $o>/$value/i;
	}

	# Insert person tags.
	while ($reply =~ /\{person\}(.*?)\{\/person\}/i) {
		my $o = $1;
		my $data = $o;
		my $new = $self->person ($data);

		$reply =~ s/\{person\}(.*?)\{\/person\}/$new/i;
	}

	# Run macros.
	while ($reply =~ /\&(.*?)\((.*?)\)/i) {
		my $rel = $1;
		my $data = $2;

		my ($object,$method) = split(/\./, $rel, 2);
		$method = 'default' unless defined $method;

		my $returned = '';

		if (defined $self->{macros}->{$object}) {
			$returned = &{$self->{macros}->{$object}} ($method,$data);
		}
		else {
			if ($self->{macro_failure}) {
				$returned = $self->{macro_failure};
			}
			else {
				warn "ERR(Macro Failure)";
				$returned = '';
			}
		}

		$reply =~ s/\&(.*?)\((.*?)\)/$returned/i;
	}

	return $reply;
}

sub mergeWildcards {
	my ($string,$stars) = @_;

	$string =~ s/<star(\d+)?>/$$stars[$1?$1:1] || ''/eig;

	return $string;
}

sub stringUtil {
	my ($type,$string) = @_;

	if ($type eq 'uppercase') {
		return uc($string);
	}
	elsif ($type eq 'lowercase') {
		return lc($string);
	}
	elsif ($type eq 'sentence') {
		$string =~ s~\b(\w)(.*?)(\.|\?|\!|$)~\u$1\L$2$3\E~ig;
		return $string;
	}
	elsif ($type eq 'formal') {
		$string =~ s~\b(\w+)\b~\L\u$1\E~ig;
		return $string;
	}
	else {
		return $string;
	}
}

=head1 NAME

RiveScript::Util - Methods for the RiveScript brain.

=head1 DESCRIPTION

This module is used by B<RiveScript> for performing common tasks.

=head1 METHODS

=head2 splitSentences ($splitters, $msg)

Take B<$msg> and split it at B<$splitters>, where B<$splitters> is formatted like
". ! ? ;"

=head2 formatMessage ($subs, $msg)

Format B<$msg> using the substitutions defined in hashref B<$subs>.

=head2 person ($subs, $text)

Run person substitutions in hashref B<$subs> on data B<$text>.

=head2 tagFilter ($RiveScript, $reply, $id, $msg)

Run tag filters on B<$reply> using all the same arguments as B<RiveScript::tagFilter>.

=head2 mergeWildcards ($string, $stars)

Merge wildcards from arrayref B<$stars> into string B<$string>.

=head2 stringUtil ($type, $string)

Run a text modifier on B<$string>, where B<$type> is one of uppercase, lowercase, formal,
or sentence.

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
