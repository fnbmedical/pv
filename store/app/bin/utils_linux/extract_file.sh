#!/bin/bash
# 调用unzip，将指定的文件解压缩到指定的目录夹下。
# 该脚本被 pvplayer/common/pvprtemppath.cpp 使用。
# Copyright(C) 2010 Kazo Vision (http://www.kazovision.com)

zipfile=$1
if [ ! -f "$zipfile" ]
then
	echo "error: file $zipfile not exists."
	exit 1
fi

extractpath=$2
if [ ! -d "$extractpath" ]
then
	echo "error: path $extractpath not exists."
	exit 1
fi



unzip -P th78601460ht -o "$zipfile" -d "$extractpath"
if [ $? -ne 0 ]
then
	echo "error: error when extract file."
	exit 1
fi

# 调用脚本检查该节目报是否视在线节目包，并下载相关文件。

exit 0

