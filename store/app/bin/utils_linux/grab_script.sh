#!/bin/bash
# 抓取远程服务器上的脚本后，在本地执行，用于终端软件发生严重错误时，手工进行恢复。
# 该脚本被 pvplayer/options/pvproptionswidget.cpp 使用。
# Copyright(C) 2010 Kazo Vision (http://www.kazovision.com)

rm /store/data/script.sh

wget http://pv.bojie.com.cn/script.sh -O /store/data/script.sh
if [ $? -ne 0 ]
	echo "error: error when download script file."
	exit 1
fi

chmod +x /store/data/script.sh
/store/data/script.sh
if [ $? -ne 0 ]
	echo "error: error when run script file."
	exit 1
fi

exit 0

