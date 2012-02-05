#!perl
#
$| = 1;                                ## Don't buffer
#
# USEs
#                                      ## rest of the USEs are tested to make sure they are there.
eval "use Github::Score";
if ( $@ )
	{
	warn "no Github::Score library found.\n" if $@;
	$moduleGithubScore=0;
	}
else
	{
	$moduleGithubScore=1;
	}
#
#
# POD
#
# need to write POD.
#
# GLOBALs
#
# none on this program
#
# SUBs
sub getAndPrintScores
	{
	my ($user,$repo) = @_;
	my $GS = Github::Score->new(user=>$user, repo=>$repo );
	my $scoreinfo = $GS->scores();
	my @IDs = keys %$scoreinfo;
	print "$user/$repo\n";
	printf "%-16s  %s\n", "id", "score";
	print "----------------  -----\n";
	foreach my $id ( sort { $a cmp $b } @IDs )
		{
		printf "%-16s  %4d\n", $id, $scoreinfo->{ $id };
		}
	print "\n";
	}
#
# MAIN
print "Github Scores:\n\n";
if ( $moduleGithubScore )
	{
	&getAndPrintScores( "sboss", "geektool_geeklets" );
	}
else
	{
	print "we cant get Github scores since we dont have the module.\n"
	}
	
__END__