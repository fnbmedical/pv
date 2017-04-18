#!/bin/bash
# 进行网络拨号连接，将参数中所给的拨号文件复制到 /etc/ppp/peers/pvplayer-provider 位置，并调用pon指令进行拨号。
# 该脚本被 network/linux/pvprlinuxdialupcontroller.cpp 使用。
# 关联脚本：network_prepare.sh, network_disconnect.sh, network_isconnected.sh
# Copyright(C) 2000-2009 Shanghai Polar Vision (http://www.polarvision.net)

networkmode=$1

case "$networkmode" in
	LAN)
	;;
	WIFI)
		/etc/init.d/networking stop
		sleep 5
		/etc/init.d/networking start
	;;
	GPRS)
		killall -9 wvdial
		killall -9 pppd
		/etc/init.d/networking stop	#必须停掉当前的网络连接，否则wvdial不会添加新的路由。
		sleep 30
		wvdial
	;;
	CDMA)
		killall -9 wvdial
		killall -9 pppd
		/etc/init.d/networking stop	#必须停掉当前的网络连接，否则wvdial不会添加新的路由。
		sleep 30
		wvdial
	;;
	*)
		echo "error: unknown network mode."
		exit 1
esac

exit 0

