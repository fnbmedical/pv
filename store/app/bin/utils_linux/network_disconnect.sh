#!/bin/bash
# 断开用pvplayer-provider建立的网络连接。
# 该脚本被 network/linux/pvprlinuxdialupcontroller.cpp 使用。
# 关联脚本：network_prepare.sh, network_connect.sh, network_isconnected.sh
# Copyright(C) 2000-2009 Shanghai Polar Vision (http://www.polarvision.net)

networkmode=$1

case "$networkmode" in
	LAN)
	;;
	WIFI)
	;;
	GPRS)
		killall -9 wvdial
		killall -9 pppd
	;;
	CDMA)
		killall -9 wvdial
		killall -9 pppd
	;;
	*)
		echo "error: unknown network mode."
		exit 1
esac

exit 0

