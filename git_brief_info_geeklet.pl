#!perl
#
$| = 1;                                ## Don't buffer
#
# USEs
#use strict;                           ## dont use this one always
#use warnings;                         ## dont use this one always
#                                      ## rest of the USEs are tested to make sure they are there.
use Getopt::Long;
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
#
GetOptions ( 'prefs|prefsfile|preferencefile=s' => \$prefile,
           );
#
# POD

#
#
# GLOBALs
my $gitBIN = '/usr/local/git/bin/git';
#
my %gitRepoPaths ; #= {};
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
		my ($id,$path) = split(/;/,$line);
		$gitRepoPaths{$id}=$path;
		}
	}
#
my @gitIDs = sort { $a cmp $b } keys %gitRepoPaths;
#
#
# SUBs
#
sub getGitBranchName
	{
	my ( $path ) = @_;
	my $branch='';
	my $CMD = sprintf "%s --git-dir=\"%s/.git\" --no-pager branch", $gitBIN, $path;
	open(PFH, "$CMD |");
	foreach my $line (<PFH>)
		{
		next if !grep(/^\*/,$line);
		($j,$branch) = split( / /, $line);
		}
	close PFH;
	chomp $branch;
	return $branch
	}
#
sub getGitBranchStatus
	{
	my ( $path ) = @_;
	my $count=0;
	my $CMD = sprintf "%s --git-dir=\"%s/.git\" --no-pager status", $gitBIN, $path;
	open(PFH, "$CMD |");
	foreach my $line (<PFH>)
		{
		if ( grep( /:/,$line) ) 
			{ 
			$count++; 
			}
		}
	close PFH;
	if ( $count < 1 )
		{
		return "";
		}
	else
		{
		return "⚡";
		}
	}
#
sub getRemoteStatus
	{
	my ( $path, $commitID ) = @_;

	if ( ! -f "${path}/.git/FETCH_HEAD" )
		{
		# no file
		return "";
		}
	else
		{
		my $retval = "";
		open( IFH, "<${path}/.git/FETCH_HEAD" );
		foreach my $line ( <IFH> )
			{
			my ($remoteID,$control,$remoteBranch) = split( /	/,$line );
			next if ( length( $control ) > 0 );
			$remoteID = substr( $remoteID,0,7 );
			if ( $commitID != $remoteID )
				{
				$retval .= "↕";
				}
			else
				{
				$retval .= "•";
				}
			}
		close IFH;
		return $retval;
		}
	
	}
#
sub printGitInfo
	{
	my ( $header,$id,$path ) = @_;
	if ( $header)
		{
		printf "%-7s  %-10s  %s\n%-7s  %-10s  %s\n", "commit","branch","git repo name","-------","----------","--------------------------------";
		}
	else
		{
		my $CMD = sprintf "%s --git-dir=\"%s/.git\" --no-pager log -1 --oneline", $gitBIN, $path;
		open(PFH, "$CMD |");
		my $line = <PFH>;
		close PFH;

		$commitID = substr( $line,0,index( $line," " ) );
		$commitStatus = &getGitBranchStatus( $path );
		$commitBranch = &getGitBranchName( $path );
		$commitRemote = &getRemoteStatus( $path,$commitID );
		
		printf "%-7s  %-10s  %s\n", $commitID, $commitBranch, $id . " " . $commitStatus . $commitRemote;			
		}

	}
#
# MAIN
&printGitInfo( 1, "", "" );
foreach my $id ( @gitIDs )
	{
	
	&printGitInfo( 0, $id, $gitRepoPaths{$id} );
	}

__END__