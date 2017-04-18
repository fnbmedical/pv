#!/bin/bash
# �������粦�����ӣ��������������Ĳ����ļ����Ƶ� /etc/ppp/peers/pvplayer-provider λ�ã�������ponָ����в��š�
# �ýű��� network/linux/pvprlinuxdialupcontroller.cpp ʹ�á�
# �����ű���network_prepare.sh, network_disconnect.sh, network_isconnected.sh
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
		/etc/init.d/networking stop	#����ͣ����ǰ���������ӣ�����wvdial��������µ�·�ɡ�
		sleep 30
		wvdial
	;;
	CDMA)
		killall -9 wvdial
		killall -9 pppd
		/etc/init.d/networking stop	#����ͣ����ǰ���������ӣ�����wvdial��������µ�·�ɡ�
		sleep 30
		wvdial
	;;
	*)
		echo "error: unknown network mode."
		exit 1
esac

exit 0

