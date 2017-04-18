#!/store/app/bin/php
<?
if(file_exists("/store/data/currentcontentdetial")){
$cnt=file_get_contents("/store/data/currentcontentdetial");
echo $cnt;
}
?>
