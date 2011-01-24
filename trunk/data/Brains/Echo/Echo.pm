package Echo::Echo;

use strict;

my $VERSION = 'Echo v1';

sub new
{
	my $class = shift;

	my $this = {};

	bless $this, $class;

	print( $VERSION . "\n" );

	return $this;
}

sub DESTROY
{
	my $this = shift;

}

sub getVersion
{
	my $this = shift;
	return $VERSION;
}

sub AUTOLOAD
{
	my $this = shift;

	print( "method $Trigger::AUTOLOAD not defined\n" );
}

sub transform
{
	my $this = shift;

	return( @_ );
}

1;
