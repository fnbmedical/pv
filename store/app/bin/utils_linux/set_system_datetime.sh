#!/bin/bash
# 设置系统时间，并写入BIOS。参数中必须提供系统时间，参数格式为：2009-01-01 08:00:00
# 该脚本被 pvplayer/common/linux/pvprlinuxutility.cpp 使用。
# Copyright(C) 2010 Kazo Vision (http://www.kazovision.com)

# 取得年月日信息。
if [ -z $1 ]
then
	echo "error: must input the date."
	exit 1
fi
year=`echo $1 | awk -F "-" '{print $1}'`
month=`echo $1 | awk -F "-" '{print $2}'`
day=`echo $1 | awk -F "-" '{print $3}'`

# 取得时分秒信息。
if [ -z $2 ]
then
	echo "error: must input the time."
	exit 1
fi
hour=`echo $2 | awk -F ":" '{print $1}'`
minute=`echo $2 | awk -F ":" '{print $2}'`
second=`echo $2 | awk -F ":" '{print $3}'`

# 调用date指令，设置系统时间，date接收的参数格式为：010318242008.30（月日时分年.秒）
date $month$day$hour$minute$year.$second
if [ $? -ne 0 ]
then
	echo "error: can not set date time."
	exit 1
fi

# 将系统时间写入BIOS。
hwclock --systohc
if [ $? -ne 0 ]
then
	echo "error: can not save date time to system."
	exit 1
fi

exit 0

