use strict;
use Config::IniFiles;
use FindBin qw( $RealBin );
use lib "$RealBin/Lib";
use Win32::Console;

use AntiCaptcha;
use File;
use PlayServer;
use Var qw(@count @success @fail);
my $cfg = Config::IniFiles->new( -file => "config.ini" );
my $server = $cfg->val('Setting','URL');
my $serverid = $cfg->val('Setting','SERVERID');
my $gameid = $cfg->val( 'Setting', 'GAMEID' );
my $antikey = $cfg->val('Setting','AntiCaptchakey');
my $CONSOLE = new Win32::Console();

main();
sub main {
	loadlib();
	system $^O eq 'MSWin32' ? 'cls' : 'clear';
	print "================================\n";
	print "PlayServer-Perl\n";
	print "By sctnightcore\n";
	print "================================\n";
	my $nextruntime = 0;
	$CONSOLE->Title("[Count]: ".scalar(@count)." | [Success]: ".scalar(@success)." | [Fail]: ".scalar(@fail)." | BY sctnightcore");
	while () {
		my $checksum = PlayServer::getimg_saveimg($server); #get img 
		my ($ans,$b) = AntiCaptcha::anti_captcha($checksum,$antikey); # get ans
		sleep 0.5;
		File::file_remove($checksum);
		if(time() >= $nextruntime) {
				my $time = PlayServer::send_answer($ans,$checksum,$server,$gameid,$serverid,$b);
				$nextruntime = time() + $time;
		}
		$CONSOLE->Title("[Count]: ".scalar(@count)." | [Success]: ".scalar(@success)." | [Fail]: ".scalar(@fail)." | By sctnightcore");
	}
}

sub loadlib {
	require Config::IniFiles;
	require HTTP::Tiny;
	require JSON;
	require AntiCaptcha;
	require File;
	require PlayServer;
	require Var;
	require WebService::Antigate::V2;
	require Win32::Console::ANSI;
	require Win32::Console;
}