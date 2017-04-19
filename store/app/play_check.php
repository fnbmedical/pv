#!/store/app/bin/php
<?
while(true){
`DISPLAY=:0 nvidia-settings -a OverscanCompensation=200`;
`rm /store/data/curr* -rf`;
`rm /store/data/store* -rf`;
`rm /store/data/snapfile -rf`;
$x=`/store/app/bin/utils_linux/revisewindowsize.php`;
`/store/app/bin/utils_linux/makesnap.sh`;
$b=`/store/app/bin/utils_linux/convert_content.php`;
$a=`/store/app/bin/utils_linux/select_content.php`;
echo "play prgs $a\n";
$c=`/store/app/bin/utils_linux/script_info.php $a`;
//`/store/app/bin/utils_linux/md5_check.php $c`;
echo "info is\n".$c;
$pv='/store/app/bin/pvplayer  -language chinese -scriptfile "'.$a.'"';
`$pv`;
`killall mplayer`;
}
?>
