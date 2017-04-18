#!/store/app/bin/php
<?php
#
# Copyright (C) 2010-2011 Kazo Vision. (http://www.kazovision.com)
# All rights reserved.
#
# check_script.php
# @version 0.01
# @author tony (tonixinot@gmail.com)
# 检查节目报是否为一个在线节目包，是的话，下载其引用到的所有文件。
#
//遍历所有脚本。
foreach (glob("/store/data/contents/*") as $packagefile) {

	$mediafiles = `LD_LIBRARY_PATH=/store/app/lib /store/app/bin/utils_linux/script_info.php $packagefile`;
	$mediafilelist = explode("\n", trim($mediafiles));
	//遍历所有媒体文件。
	foreach ($mediafilelist as $mediafile) {
		//检查媒体文件是否存在。
				$f="/store/data/filepool/".$mediafile;
				if (!file_exists($f)) {
//				   $res=`md5sum $f`;
//					$md5=explode(" ",$res);
//					echo "$f 's md5 is ";
//					echo $md5[0];
//					echo "\n";
						$list[$f]=$list[$f]+1;
					}
				}
		}
	echo count($list);
?>
