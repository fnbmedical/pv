#!/store/app/bin/php
<?
if(file_exists("/store/data/storedcontents")){
$cnt=file_get_contents("/store/data/storedcontents");
echo urlencode($cnt);
}
?>
