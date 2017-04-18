#!/bin/bash
# 使用给定的NTP服务器地址，进行网络时间同步。
# 该脚本被 pvplayer/ntp/pvprntpcontrolthread.cpp 使用。
# Copyright(C) 2010 Kazo Vision (http://www.kazovision.com)

# 取得NTP服务器地址
ntpserver=$1
if [ -z $ntpserver ]
then
	echo "error: must input the ntp server."
	exit 1
fi

ntpdate -b $ntpserver
