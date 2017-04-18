#!/bin/bash
# 调用listswf，返回flash文件的播放时长。
# 该脚本被 pvplayer/playcontrol/linux/pvprwebkitflashfileplayinfowidget.cpp 使用。
# Copyright(C) 2010 Kazo Vision (http://www.kazovision.com)

swfinfo=`listswf "$1"`
if [ $? -ne 1 ]		# listswf 返回1作为成功的标志。
then
	echo "error: error when run listswf."
	exit 1
fi

# 取得FrameRate信息。
framerate=`echo $swfinfo | sed 's/.*Frame rate://' | awk '{print $1}'`
#echo "framerate=$framerate"
if [ -z $framerate ]
then
	echo "can not found frame rate info."
	exit 1
fi

# 取得TotalFrames信息。
totalframes=`echo $swfinfo | sed 's/.*Total frames://' | awk '{print $1}'`
#echo "totalframes=$totalframes"
if [ -z $totalframes ]
then
	echo "can not found total frames info."
	exit 1
fi

# flash文件的播放时长为TotalFrames ＊ 1000 / FrameRate。
printf "%.0f\n" `echo "scale=0; $totalframes*1000 / $framerate" | bc`

exit 0

