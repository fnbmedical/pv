#!/store/app/bin/php
<?php
#
# Copyright (C) 2010-2011 Kazo Vision. (http://www.kazovision.com)
# All rights reserved.
#
# select_content.php
# @version 0.01
# @author tony (tonixinot@gmail.com)
# 搜索指定目录中的所有脚本文件，按优先级排序后，返回当前需要播放的文件名。
#
date_default_timezone_set('Asia/Chongqing');
//靠靠靠靠靠靠靠縨d5靠靠靠靠靠 


$content_path = "/store/data/contents";

//遍历所有文件。
$dir=glob($content_path . '/*');
if(!$dir){echo "";
file_put_contents("/store/data/currentcontent", "");
file_put_contents("/store/data/storedcontents", "");
file_put_contents("/store/data/currentcontentdetial","");
exit;}
foreach ($dir as $filename) {
//	echo "$filename\n";
	//加载XML结构。
	$doc = new DOMDocument();
	$doc->preserveWhiteSpace = false;
	if (! $doc->load($filename)) {
		echo "Error when load content file: $filename\n";
		continue;
	}
	$scripts_element = $doc->documentElement;
	//遍历所有script节点。
	$i = 0;
	foreach ($scripts_element->childNodes as $script_xml) {
		//加载播放时间定义，存储到 scripts 数组中。
		$script['caption'] = $script_xml->getAttribute('caption');
		$script['datetype'] = $script_xml->getAttribute('datetype');
		$script['startdate'] = $script_xml->getAttribute('startdate');
		$script['stopdate'] = $script_xml->getAttribute('stopdate');
		$script['timetype'] = $script_xml->getAttribute('timetype');
		$script['starttime'] = $script_xml->getAttribute('starttime');
		$script['stoptime'] = $script_xml->getAttribute('stoptime');
		$script['priority'] = $script_xml->getAttribute('priority');
		$script['filename'] = $filename;
		$script['index'] = $i;
		$scripts[$filename . '-' . $i] = $script;
		$i ++;
	}
}

//遍历 scripts 数组，找出当前需要播放的那套。
//stage 1 靠靠?靠靠靠靠?//shift 靠靠靠靠靠靠靠 
$found_script = null;
$date = date("Y-m-d");
$x=0;
        foreach ($scripts as $script) {
        if(strtotime(trim($script['stopdate']))>=strtotime($date) && strtotime(trim($script['startdate']))<=strtotime($date)){
			$shift= strtotime($date)-strtotime($script['startdate']);	
			$script['shift']=$shift;
			$vaild_prgs[$x]=$script;
			$x++;
			}
        }
//check if exist fullday prgs..
if(count($vaild_prgs)==0){
	foreach ($scripts as $script) {
		if($script['datetype']==0){
	 		 $found_script=$script;
			 make_over($scripts,$found_script);
			 exit;	
		}
	}
unset($found_script);
make_over($scripts,$found_script);
exit;
}
//縮hift靠靠靠
usort($vaild_prgs,"cmp");
function cmp($a,$b){
if ($a['shift']>$b['shift']){return true;}
return false;
}

$program=$vaild_prgs[0];
if($vaild_prgs){
	for($i=1;$i<count($vaild_prgs);$i++){
		if($vaild_prgs[$i]['shift']==$program['shift']){
			if($vaild_prgs[$i]['priority'] > $program['priority'])
			{
				$program=$vaild_prgs[$i];
			}
		}
	}
}


//靠靠
//靠靠靠靠靠靠靠(靠靠靠靠靠靠靠靠靠

//foreach($vaild_prgs as $check){
//	if(strtotime(trim($check['stopdate']))==strtotime($check['startdate']))
//		{
//		$found_script=$check;
//		make_over($scripts,$found_script);
//		exit;
//		}
//	}
//靠靠靠靠靠靠靠靠?	
//foreach($vaild_prgs as $check_today){
//	if($check_today['shift']==0)
//		{
//		$found_script=$check_today;
//		make_over($scripts,$found_script);
//		exit;
//		}	
//}
	
//靠靠靠靠靠靠?靠靠靠靠靠靠靠
$found_script=$program;
make_over($scripts,$found_script);


function make_over($scripts,$found_script){
if ($found_script != null) {
echo $found_script['filename'];
                echo " ";
	echo $found_script['index'];
}

//保存当前节目名。
if ($found_script) {
	$current_content = '('.basename($found_script['filename']).') '.$found_script['caption'] . ' [' . $found_script['startdate'] . '-' . $found_script['stopdate'] . ']';
write_detial($found_script['filename'],$found_script['startdate'],$found_script['stopdate']);
}
else {
	$current_content = "";
}
//$current_content=iconv("GB2312","UTF-8",$current_content);
file_put_contents("/store/data/currentcontent", $current_content);

//保存当前节目详细？？需要取缔一个窗口中的内容，如何处理？

//保存预存节目列表
$stored_contents = "";
foreach ($scripts as $script) {
	$stored_contents .= '('.basename($script['filename']).') '.$script['caption'] . ' [' . $script['startdate'] . '/' . $script['stopdate'] . ']';
if($script['datetype']==0){$stored_contents .="[fullday]\n";}
else{$stored_contents .="\n";}
}
//$stored_contents=iconv("GB2312","UTF-8",$stored_contents);
file_put_contents("/store/data/storedcontents", $stored_contents);
}



function write_detial($filename,$startdate,$stopdate){
if(!$filename){echo "";
file_put_contents("/store/data/currentcontent", "");
file_put_contents("/store/data/storedcontents", "");
file_put_contents("/store/data/currentcontentdetial","");
exit;}
$doc = new DOMDocument();
$doc->preserveWhiteSpace = false;
if (! $doc->load($filename)) {
	echo "Error when load content file: $filename\n";
	continue;
}
$scripts_element = $doc->documentElement;
//遍历所有script节点。
foreach ($scripts_element->childNodes as $script_element) {
  if($script_element->getAttribute('startdate')==$startdate && $script_element->getAttribute('stopdate')==$stopdate){
	foreach ($script_element->childNodes as $program_element) {
		foreach ($program_element->childNodes as $window_element) {
			foreach ($window_element->childNodes as $item_element) {
				$filename=$item_element->getAttribute('filename');
				if ($filename != null) {
					//$list_ar[$filename]++;
					$str_chunk=explode(".",$filename);
					if($str_chunk[1]=='avi'){
					$all.=$filename."\n";
						}
				}
			}
			//仅处理第一个窗口中的信息
//			break;
		}
	}
}
}
file_put_contents("/store/data/currentcontentdetial",$all);
}
