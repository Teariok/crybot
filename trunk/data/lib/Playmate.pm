package Playmate;

use 5.008;
use strict;
use warnings;

use LWP::UserAgent;

our @ISA = qw();

our $VERSION = '0.03';


my $url = "http://www.playboy.com/playmates/directory/";

sub new 
{
	my $class = shift;
	my ($year, $month ) = @_;
	$year = "1953" unless defined $year;
	$month = "12" unless defined $month;
	my $ua = LWP::UserAgent->new;
	$ua->agent("Acme::Playmate " . $VERSION);
	my $req = HTTP::Request->new(GET => $url . $year . $month . ".html");
	$req->header('Accept' => 'text/html');
	my $res = $ua->request($req);
	if(!$res->is_success) {
		die "Failed to fetch information: " . $res->status_line . " \n";
	}
	my $con = $res->content;
	$con =~ s/[\r\n]//g;
	$con =~ s/&nbsp;/ /g;
	$con =~ /.*?<title>(.*?)<\/title>.*?/is;
	my $namedata = $1;
	$con =~ /.*?<p><b>BIRTHPLACE:<\/b>(.*?)<\/p>.*?/is;
        my $birthPlace = $1;
	$birthPlace =~ s/ //g;
        $con =~ /.*?<p><b>BUST:<\/b>(.*?)<\/p>.*?/is;
        my $bust = $1;
	$bust =~ s/ //g;
        $con =~ /.*?<p><b>WAIST:<\/b>(.*?)<\/p>.*?/is;
        my $waist = $1;
	$waist =~ s/ //g;
        $con =~ /.*?<p><b>HIPS:<\/b>(.*?)<\/p>.*?/is;
        my $hips = $1;
	$hips =~ s/ //g;
        $con =~ /.*?<p><b>HEIGHT:<\/b>(.*?)<\/p>.*?/is;
        my $height = $1;
	$height =~ s/ //g;
        $con =~ /.*?<p><b>WEIGHT:<\/b>(.*?)<\/p>.*?/is;
        my $weight = $1;
	$weight =~ s/ //g;

	my( $name, undef ) = split( ' - ', $namedata, 2 );

	my $self = {  Name => $name,
		      BirthPlace => $birthPlace, Bust => $bust,
		      Waist => $waist, Hips => $hips,
		      Height => $height, Weight => $weight };
	bless $self, $class;
	return $self;
}
1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Acme::Playmate

=head1 SYNOPSIS

  use Acme::Playmate;

  my $playmate = new Acme::Playmate("2003", "04");

  print "Details for playmate " . $playmate->{ "Name" } . "\n";
  print "Birthdate" . $playmate->{ "BirthDate" } . "\n";
  print "Birthplace" . $playmate->{ "BirthPlace" } . "\n";
  print "Bust" . $playmate->{ "Bust" } . "\n";
  print "Waist" . $playmate->{ "Waist" } . "\n";
  print "Hips" . $playmate->{ "Hips" } . "\n";
  print "Height" . $playmate->{ "Height" } . "\n";
  print "Weight" . $playmate->{ "Weight" } . "\n";

=head1 DESCRIPTION

Acme::Playmate is a Perl extension to consult the playboy playmate directory for playmate information.

=head2 EXPORT

None.


=head1 SEE ALSO

=head1 AUTHOR

O. S. de Zwart, E<lt>olle@endforward.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by O. S. de Zwart

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
