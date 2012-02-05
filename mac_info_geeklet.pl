#!perl
#
$|=1;
#
#
#
#
my $SCUTIL = '/usr/sbin/scutil';
my $SYSCTL = '/usr/sbin/sysctl';
my $SWVERS = '/usr/bin/sw_vers';
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
		return "${retval} Gig RAM";
		}
#
#
sub getOSVersion
		{
		open (PFH, "$SWVERS |");
		my $productname = <PFH>;
		my $productver = <PFH>;
		my $buildver = <PFH>;
		close PFH;
		chomp $productname;
		chomp $productver;
		chomp $buildver;
		($junk,$productname) = split(/:/,$productname);
		($junk,$productver) = split(/:/,$productver);
		($junk,$buildver) = split(/:/,$buildver);
		$productname =~ s#^\s+##;
		$productver =~ s#^\s+##;
		$buildver =~ s#^\s+##;
		return "$productname  $productver ($buildver)";
		}
#
# MAIN
my @LEFT=();
my @RIGHT=();
push @LEFT, split( /\n/, &getOSVersion );
push @LEFT, split( /\n/, &getMemory );
push @RIGHT, split( /\n/, &getCPU );

printf "%s\n", &getComputerName;
print "-------------------------------------------------------------\n";
while ($#LEFT > -1 || $#RIGHT > -1)
	{
	my $l = ( $#LEFT > -1 ? shift @LEFT : "");
	my $r = ( $#RIGHT > -1 ? shift @RIGHT : "");
	printf "%-30s %s\n", $l,$r;
	}