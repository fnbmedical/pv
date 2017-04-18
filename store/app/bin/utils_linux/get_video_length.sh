#!/bin/bash
# 调用mplayer，获取视频的播放时长。
# 该脚本被 pvplayer/playcontrol/linux/pvprmplayervideofileplayinfowidget.cpp 使用。
# Copyright(C) 2010 Kazo Vision (http://www.kazovision.com)

# mplayer的返回信息中会包含 ID_LENGTH=15.36 这样的信息，就是视频的时间长度。
videolength=`mplayer -identify -nosound -vc dummy -vo null "$1" 2>/dev/null | grep 'ID_LENGTH' | sed 's/.*=//'`

if [ $? -ne 0 ]
then
	echo "error: error when run mplayer."
	exit 1
fi
if [ -z $videolength ]
then
	echo "error: can not found video length info."
	exit 1
fi

# 将时间单位转换为微秒。
printf "%.0f\n" `echo "scale=0; $videolength*1000" | bc`

