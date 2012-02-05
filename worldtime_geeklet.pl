#!/usr/bin/perl
#
#
$|=1;
#
use DateTime;
use DateTime::TimeZone;
use Getopt::Long;
#
#
$dt = DateTime->now;
#
%TZs = 
	( 
	'GMT', 'GMT',
	);
#
#
GetOptions ( 'prefs|prefsfile|preferencefile=s' => \$prefile,
             'locationfirst' => \$locationfirst );
#
if (!defined $prefile )
	{
	print "ERROR:\n\nneed a prefernces file\n$0 -prefs <filename>\n";
	exit 1;
	}
else
	{
	open (IFH, "< $prefile") or die "cant open $prefile\n.";
	foreach my $line (<IFH>)
		{
		next if grep(/^#/,$line);
		next if grep(/^$/,$line);
		chomp $line;
		my ($loc,$tz) = split(/;/,$line);
		$TZs{$loc}=$tz;
		## printf "%s --> %s\n", $loc, $TZs{$loc}; ## used for debuging only
		}
	}
#
$locationfirst = ( defined $locationfirst ? "1" : "0" ); #make it TRUE/FALSE
#
#
# MAIN 
foreach my $city ( sort { $a cmp $b } keys %TZs )
	{
	$dt->set_time_zone( $TZs{ $city } );
	if ( $locationfirst )
		{
		printf "%s   %02d:%02d  %-3s [%02d/%02d]\n", "${city}",  $dt->hour,$dt->min, $dt->day_abbr, $dt->month, $dt->day;			
		}
	else
		{
		printf "%02d:%02d  %-3s [%02d/%02d]  %s\n",  $dt->hour,$dt->min, $dt->day_abbr, $dt->month, $dt->day, "${city}";						
		}
	}