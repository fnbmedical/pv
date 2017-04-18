#!/bin/bash
# 检查指定名称的设备是否存在，存在的话返回0，不存在返回1。
# 该脚本被 pvprocessor/fileimport/pvpcautoimportthread.cpp 使用。用于判断用户是否将已加在完成的设备拔除。
# 关联脚本：mount_disk.sh, unmount_disk.sh
# Copyright(C) 2010 Kazo Vision (http://www.kazovision.com)

if [ -z $1 ]
then
	echo "error: must input the device name.";
	exit 1
fi

if [ -e $1 ]
then
	echo "device exists."
	exit 0
fi

exit 1

