#!/bin/bash
# 结束系统，退出X。
# Copyright(C) 2000-2009 Shanghai Polar Vision (http://www.polarvision.net)

killall pvplayer
killall start_player.sh
killall start_regionserver.sh
killall status_report
killall status_report.sh
killall start_service.sh
killall start_communicator.sh
killall -9 Xorg
killall -9 pvrunner
killall -9 pvsensor
killall -9 s.php
killall -9 play_check.php
exit 0

