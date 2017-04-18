#!/store/app/bin/php
<?
$all_s=glob("/store/data/contents/*");
foreach ($all_s as $filename){
if(!$filename){echo "nothing..\n";exit;}
$doc = new DOMDocument();
$doc->preserveWhiteSpace = false;
if (! $doc->load($filename)) {
        echo "Error when load content file: $filename\n";
        continue;
}
$t=$doc->getElementsByTagName('play');
foreach($t as $p){
$x=$p->getAttribute('filename');
if(strlen($x)>0){
$list_a[$x]++;
}
}
foreach($t as $p){
$x=$p->getAttribute('backgroundimage');
if(strlen($x)>0){
$list_a[$x]++;
}
}
}
$all=glob("/store/data/filepool/*");
foreach($all as $sp){
$sp_new=basename($sp);
$all_new[]=$sp_new;
}
$b=array_keys($list_a);
foreach($b as $prt){
$cot= array_search($prt,$all_new);
unset($all_new[$cot]);
}
echo "delete file..\n";
foreach($all_new as $be_del){
echo "$be_del\n";
unlink ("/store/data/filepool/".$be_del);
}
?>
