#!/store/app/bin/php
<?php

   $uploadfile=$argv[2]; 
//make snapshot...
$bname=basename($uploadfile,".png");

$snap_cmd='/store/app/bin/ffmpeg.generic -i /store/data/filepool/'.$bname.'.avi -y -vf scale=320:180 -f image2 -ss 6 -vframes 1 /store/data/snapshot/'.$bname.".png";
echo $snap_cmd;
$res=`$snap_cmd`;
echo $res;


//make ok
   $ch = curl_init($argv[1]."/snapshot/receiver.php");  
   curl_setopt($ch, CURLOPT_POSTFIELDS,
               array('file'=>"@$uploadfile"));
   curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

//proxy....

if(file_exists("/store/app/proxy.conf")){

$tmp=trim(file_get_contents("/store/app/proxy.conf"));
if(strlen($tmp)>0){
$ag=explode("\n",$tmp);
$proxy=explode("=",$ag[0]);
$port=explode("=",$ag[1]);
$user=explode("=",$ag[2]);
$pass=explode("=",$ag[3]);
echo $proxy[1].$port[1];
curl_setopt($ch,CURLOPT_PROXY,$proxy[1]);
curl_setopt($ch,CURLOPT_PROXYPORT,$port[1]);
curl_setopt($ch, CURLOPT_PROXYAUTH, CURLAUTH_BASIC);
curl_setopt($ch, CURLOPT_PROXYUSERPWD,$user[1].":".$pass[1]);
curl_setopt($ch,CURLOPT_PROXYTYPE,CURLPROXY_HTTP);
}
}

//end of proxy...

   $postResult = curl_exec($ch);
   curl_close($ch);
   print "$postResult";

?>
