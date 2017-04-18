#!/store/app/bin/php
<?php
$url=$argv[1];
$dest_file=$argv[2];
if(strlen($url)==0){exit;}
if(strlen($dest_file)==0){exit;}
//extract file 
$workingdir=tempnam("/tmp","dl");
unlink($workingdir);
mkdir($workingdir);

//get the file server address..if file server match ntpserver,use localserver
$prefix=explode("//",$url);
$dlhost=explode("/",$prefix[1]);
//region server did not have this file....
//if(file_exists("/store/data/ntpserver")){
//$localserver=file_get_contents("/store/data/ntpserver");
//}
$urlip=explode(".",$dlhost[0]);
//compare the url and ntpserver

$flag=0;
if(strcmp($urlip[0],"192") == 0 || strcmp($urlip[0],"10") == 0 ){echo "L|";$fileserver="http://".$dlhost[0]."/files";$flag=1;}
else{
//if not match ,use remote server
$mainserver=trim(file_get_contents("/store/data/mainserver"));
$mainserver.="/manager/urlinfox.php";
$arr_f=explode("<pv>",file_get_contents($mainserver));
$fileserver=$arr_f[1];
echo "R|";
$flag=0;
}
r_echo("file server:".$fileserver."\n");
r_echo("GET:".$url."\n");
//end of server decide 
//delete the file of last time download
if(file_exists($dest_file)){unlink($dest_file);};
//if dl_file execute fail,delete the temp file and quit.
if(dl_file($url,$dest_file,$flag)>0){unlink($dest_file);r_echo("download faild");exit(1);}

//check if online.txt in zip file
$zip = new ZipArchive;
if (!$zip->open($dest_file)){r_echo("zip error\n");exit;}
for($i = 0; $i < $zip->numFiles; $i++)
{
	if(trim($zip->getNameIndex($i))=="online.txt")
	{
		$found++;
		echo "package listsfound.\n";
	}	
}
$zip->close();
//checked
//if not netfile in the zip,the zip maybe standalone package or updatefile or some stuff
//exit and do next job(extract file and do some thing)
if($found==0){r_echo("go on\n");exit(0);}

//extract the netfile zip...
$ex_res=`/store/app/bin/utils_linux/extract_file.sh $dest_file $workingdir`;

//clean the zero script file
foreach(glob("/store/data/contents/*") as $filename) {
	if(filesize($filename)==0){
        	r_echo("clean a zero script\n");
        	unlink($filename);
        }
}

//clean ok


//if zip is a netfile,continue to download other files in the lists....
foreach (glob($workingdir. "/*.xml") as $filename) {
	r_echo("Get all file in lists\n");
        $mediafiles = `LD_LIBRARY_PATH=/store/app/lib /store/app/bin/utils_linux/script_info.php $filename`;
        $mediafilelist = explode("\n", trim($mediafiles));
        foreach ($mediafilelist as $mediafile) {
                $mediafilename = "/store/data/filepool/" . $mediafile;
                if (file_exists($mediafilename)) {
			//r_echo("E ".$mediafile." ");
			//get md5
			$md5=explode(" ",`md5sum $mediafilename`);
			//r_echo($md5[0]);
		        $src_md5=explode(".",$mediafile);	
			if(strcmp($src_md5[0],$md5[0])){
				r_echo(" W");
				unlink($mediafilename);
			}
                        continue;
                }
		echo $fileserver.$mediafile."\n";
		dl_file($fileserver."/".$mediafile,$mediafilename,$flag);
                r_echo("D ".$mediafile." ");
		//check md5sum
		$md5=explode(" ",`md5sum $mediafilename`);
                //r_echo($md5[0]);
                $src_md5=explode(".",$mediafile);
                if(strcmp($src_md5[0],$md5[0])){
			r_echo(" W\n");
                        unlink($mediafilename);
                }
		r_echo("\n");
		//check md5 ok
        }
}

r_echo("no error\n");
exit;
//end of main

function dl_file($url,$dest_file,$flag){
$mainserver=trim(file_get_contents("/store/data/mainserver"));
$mainserver.="/manager/dlspeed.php";
$arr_f=explode("<pv>",file_get_contents($mainserver));
$dls=$arr_f[1];

if($flag == 1){
$dls="1000k";
}
#check over
r_echo("limit dl speed is $dls\n");
$cmdl="wget -t 4 -T 20 --dns-timeout=10 --connect-timeout=15 --read-timeout=20 --limit-rate=".$dls." -w 10 -c --quiet ".$url." -O ".$dest_file;
passthru($cmdl,$b);
switch($b){
        case 0:
        break;
        case 1:
        r_echo("Generic error\n");
        break;
        case 2:
        r_echo("Parse error\n");
        break;
        case 3:
        r_echo("File I/O error\n");
        break;
        case 4:
        r_echo("Network faulure\n");
        break;
        case 6:
        r_echo("auth faulure\n");
        break;
        case 7:
        r_echo("protocol error\n");
        break;
        case 8:
        r_echo("server issued an error response\n");
        break;
}
if(filesize($dest_file)==0){echo "nothing get\n";
	if(!file_exists($dest_file)){unlink("test");}
}

}

function r_echo($str){
//put messages into stderr...
file_put_contents('php://stderr',$str);
}
?> 
