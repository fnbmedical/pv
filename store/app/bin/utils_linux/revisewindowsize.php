#!/store/app/bin/php
<?php
error_reporting(E_ALL^E_NOTICE^E_WARNING);

function detect_encoding($file) {
	$list = array('GBK', 'UTF-8', 'UTF-16LE', 'UTF-16BE', 'ISO-8859-1');
	$str = file_get_contents($file);
	foreach ($list as $item) {
		$tmp = mb_convert_encoding($str, $item, $item);
		if (md5($tmp) == md5($str)) {
			return $item;
		}
	}
	return null;
}

$dir = "/store/data/contents/";
// Open a known directory, and proceed to read its contents
if (is_dir($dir)) {
	if ($dh = opendir($dir)) {
		while (($file = readdir($dh)) !== false) {
			if(filetype($dir . $file) == "file"){
				$filepath = $dir.$file;
				//<window left="0" top="0" right="1920" bottom="1080">
				$xml_doc = new DOMDocument;
				$xml_doc->load($filepath);//这里填写你的xml文件
				$user_info = $xml_doc->documentElement->getElementsByTagName("window");
				$height = 1;
				$width = 1;
				foreach ($user_info as $value){
					if($value->getAttribute("bottom") < "1080")
					{
						if($value->getAttribute("bottom") >= "768")
						{
							$height = 1080/$value->getAttribute("bottom");
						}
					}
					if($value->getAttribute("right") < "1920")
					{
						if($value->getAttribute("right") >="1366")
						{
							$width = 1920/$value->getAttribute("right");
						}
					}
					$value->setAttribute("left",floor($value->getAttribute("left")*$width));
					$value->setAttribute("top",floor($value->getAttribute("top")*$height));
					$value->setAttribute("right",floor($value->getAttribute("right")*$width));
					$value->setAttribute("bottom",floor($value->getAttribute("bottom")*$height));
				} 

				//<play font=",39" 
				$user_info = $xml_doc->documentElement->getElementsByTagName("play");
				foreach ($user_info as $value){
					if($value->getAttribute("font")==",28")
					{
						$value->setAttribute("font",",39");
					}
				}

				$xml_doc->encoding = detect_encoding($filepath);
				$xml_doc->save($filepath);
			}
		} closedir($dh);
	}
}
?>
