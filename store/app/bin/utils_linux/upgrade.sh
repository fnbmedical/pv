#!/bin/bash
# 系统软件升级脚本。根据参数中提供的升级包所在路径，自动将升级软件替换到当前目录，并重启软件。
# 该脚本被 pvprocessor/fileimport/pvpcupgradefileimporter.cpp 使用。
# Copyright(C) 2010 Kazo Vision (http://www.kazovision.com)

upgradepath=$1
if [ -z "$upgradepath" ]
then
	echo "error: must input the path of upgrade package."
	exit 1
fi
if [ ! -d "$upgradepath" ]
then
	echo "error: path $upgradepath not exists."
	exit 1
fi

# 关闭当前正在运行的软件。
sleep 5
killall pvplayer
sleep 5
killall -9 pvplayer

# 删除系统目录下，上次升级遗留下来的后期升级处理文件。
postupgradefile=/store/app/postupgrade.sh
if [ -f $postupgradefile ]
then
	rm $postupgradefile
fi

# 将升级目录夹内的所有文件复制到当前系统目录。
cp $upgradepath/. /store/app --recursive --force
if [ $? -ne 0 ]
then
	echo "error: can not copy upgrade file."
	reboot	# 依然重启系统，否则系统就挂在这里了。
	exit 1
fi

# 执行后期升级处理文件。
if [ -f $postupgradefile ]
then
	chmod +x $postupgradefile
	$postupgradefile
	if [ $? -ne 0 ]
	then
		echo "error: error when run postupgrade.sh."
	fi
fi

sync
sleep 5

reboot

exit 0

