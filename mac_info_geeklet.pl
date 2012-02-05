#!perl
#
$|=1;
#
#
# sw_vers | awk -F':\t' '{print $2}' | paste -d ' ' - - -;
#
#
#
my $SCUTIL = '/usr/sbin/scutil';
my $SYSCTL = '/usr/sbin/sysctl';
#
#
sub getComputerName
	{
	open (PFH, "$SCUTIL --get ComputerName |");
	my $retval =  <PFH>;
	close PFH;
	chomp $retval;
	open (PFH, "$SYSCTL -n kern.hostname |");
	my $retval2 = <PFH>;
	close PFH;
	chomp $retval2;
	$retval = "$retval [$retval2]";
	return $retval;
	}
#
sub getCPU
	{
	open (PFH, "$SYSCTL -n machdep.cpu.brand_string |");
	my $retval =  <PFH>;
	close PFH;
	chomp $retval;
	my ($top,$bottom) = split(/   /,$retval);
	$retval = "$top\n$bottom";
	return $retval;
	}
#
sub getMemory
		{
		open (PFH, "$SYSCTL -n hw.memsize |");
		my $retval =  <PFH>;
		close PFH;
		chomp $retval;
		$retval = int( $retval/1073741824 );
		return $retval;
		}
#
#
# MAIN
printf "%s\n", &getComputerName;
# this is where the O/S related info will be (once it is written).
printf "%d GB RAM\n", &getMemory;
printf "%s\n", &getCPU;