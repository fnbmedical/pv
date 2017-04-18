#!/bin/bash
# 重启系统。
# 该脚本被 shutdown/linux/pvprlinuxshutdowncontroller.cpp 使用。
# Copyright(C) 2000-2009 Shanghai Polar Vision (http://www.polarvision.net)

sleep 5
killall pvplayer
sleep 5
killall -9 pvplayer

killall -9 status_report 
killall -9 status_report.sh 
killall -9 start_player.sh 
killall -9 start_with_x.sh
killall -9 Xorg

sync
sleep 2

rm /store/data/download_status.*  /store/data/commandcache.* /store/data/commandcache_status.* /store/data/errorlog.db 

reboot

exit 0

