#!/store/app/bin/php
<?
$dir=glob("/store/data/contents/*");
if(!$dir){echo "nothing\n";exit;}
foreach ($dir as $filename) {
		$cnt=file_get_contents($filename);
		$checksum = substr(md5($cnt),0,8);
		rename($filename,"/store/data/contents/".$checksum);
				}
?>
