#!/bin/bash
# 检查网络是否已连接，若已连接返回0，否则返回1。
# 该脚本被 network/linux/pvprlinuxdialupcontroller.cpp 使用。
# 关联脚本：network_prepare.sh, network_connect.sh, network_disconnect.sh
# Copyright(C) 2000-2009 Shanghai Polar Vision (http://www.polarvision.net)

networkmode=$1
server=$2

case "$networkmode" in
	LAN)
	;;
	WIFI)
		ping -c 1 $server
		if [ $? -ne 0 ]
		then
			echo "info: network not connected.";
			exit 1
		fi
	;;
	GPRS)
		ifconfig ppp0 mtu 200
		ping -c 1 $server
		if [ $? -ne 0 ]
		then
			echo "info: network not connected.";
			exit 1
		fi
	;;
	CDMA)
		ifconfig ppp0 mtu 200
		ping -c 1 $server
		if [ $? -ne 0 ]
		then
			echo "info: network not connected.";
			exit 1
		fi
	;;
	*)
		echo "error: unknown network mode."
		exit 1
esac

exit 0

