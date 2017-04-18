#!/store/app/bin/php
<?
if(file_exists("/store/data/currentcontent")){
$cnt=file_get_contents("/store/data/currentcontent");
echo urlencode($cnt);
}
?>
