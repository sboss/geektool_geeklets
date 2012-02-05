#!perl
#
$| = 1;                                ## Don't buffer
#
# USEs
#use strict;                           ## dont use this one always
#use warnings;                         ## dont use this one always
#                                      ## rest of the USEs are tested to make sure they are there.
use LWP::Simple;
#
## For testing
eval "use Data::Dumper";
if ( $@ )
	{
	warn "no Data::Dumper library found.\n";
	}
else
	{
	$Data::Dumper::Useqq=1;            ## Escape metachars (WARNING: Turns off XS))		
	}
#
# POD

#
#
# GLOBALs
my $URL = 'http://query.yahooapis.com/v1/public/yql?q=select%20item.description%20from%20weather.forecast%20where%20location%3D30101';
my $weatherimage = '/Users/sboss/etc/weather_30101.gif';
#
#
# SUBs

#
# MAIN
open ( IFH, "<.$0");
my $oldURL = <IFH>;
close IFH;
my $yahooReturn = get( $URL );
if ( length( $yahooReturn ) > 5 )
	{
	my ( $l,$r ) = split( /<!\[CDATA\[/,$yahooReturn );
	( $l,$r ) = split( /\]\]>/,$r );
	( $l,$r ) = split( /<br \/>\n<br \/>\n<a /i, $l );
	$l =~ s#<br />##gi;
	$l =~ s#\n#\n  #g;
	$l =~ s#  <b>##g;
	$l =~ s#</b>##g;
	my $url = '';
	foreach my $line ( split( /\n/, $l ) )
		{
		if ( grep( /<img /,$line ) )
			{
			$url = $line;
			$url =~ s#  <img src=\"##;
			$url =~ s#\"/>##;
			if ( $oldURL ne $url )
				{
				my $ec = getstore( $url,$weatherimage ) or die "cant write to $weatherimage\n";					
				## $ec == 200 is a good thing.
				open ( OFH, ">.$0" ) or die "cant open .$0 for writing.\n";
				print OFH $url;
				close OFH;
				}
			}
		else
			{
			print "$line\n";			
			}
		}
		
	}
else
	{
	print "no internet connections...";
	}

__END__