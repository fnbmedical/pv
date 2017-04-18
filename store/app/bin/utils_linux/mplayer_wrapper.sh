#!/bin/sh
#sys=`lspci`
#echo $sys | grep nVidia >/dev/null && /store/app/bin/mplayer.nv  -vo vdpau -vc ffh264vdpau,ffmpeg12vdpau,ffvc1vdpau,ffwmv3vdpau $* ;exit
export DISPLAY=:0
if [ -f /store/app/bin/mplayer ];
then
/store/app/bin/mplayer  -ni -vo vdpau -vc ffh264vdpau  -format s32le -ao alsa -vo vdpau $*
#/store/app/bin/mplayer -hardframedrop -framedrop -nortc -softsleep -vo xv $*
exit
fi
mplayer -hardframedrop -framedrop -nortc -softsleep -vo xv $*


