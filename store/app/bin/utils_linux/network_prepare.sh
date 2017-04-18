#!/bin/bash
# 对各类网络连接方式进行初始化，准备相应的配置文件等。在pvplayer启动或者中途修改网络配置时被调用。
# 该脚本被 network/linux/pvprlinuxdialupcontroller.cpp 使用。
# 关联脚本：network_connect.sh, network_disconnect.sh, network_isconnected.sh
# Copyright(C) 2000-2009 Shanghai Polar Vision (http://www.polarvision.net)

networkmode=$1

case "$networkmode" in
	LAN)
	;;
	WIFI)
		connection=$2
		password=$3

		configfile=/etc/network/interfaces
		rm $configfile
		echo "# This file was created by pvplayer (http://www.polarvision.net)" >> $configfile
		echo "# Please do not modify this file." >> $configfile
		echo "" >> $configfile
		echo "# The loopback network interface" >> $configfile
		echo "auto lo" >> $configfile
		echo "iface lo inet loopback" >> $configfile
		echo "" >> $configfile
		echo "# WIFI" >> $configfile
		echo "auto wlan0" >> $configfile
		echo "iface wlan0 inet dhcp" >> $configfile
		echo "wireless-essid $connection" >> $configfile
		echo "wireless-enc $password" >> $configfile
	;;
	GPRS)
		devicetype=$2

		# 清空interfaces文件中的内容。
		configfile=/etc/network/interfaces
		rm $configfile
		echo "# This file was created by pvplayer (http://www.polarvision.net)" >> $configfile
		echo "# Please do not modify this file." >> $configfile
		echo "" >> $configfile
		echo "# The loopback network interface" >> $configfile
		echo "auto lo" >> $configfile
		echo "iface lo inet loopback" >> $configfile
		# 设置GPRS拨号配置文件。
		configfile=/etc/wvdial.conf
		rm $configfile
		echo "# This file was created by pvplayer (http://www.polarvision.net)" >> $configfile
		echo "# Please do not modify this file." >> $configfile
		echo "" >> $configfile
		echo "[Dialer defaults]" >> $configfile
		if [ $devicetype == "ACM" ]
		then
			echo "Modem = /dev/ttyACM0" >> $configfile
			echo "Init1 = AT" >> $configfile
			echo "Init2 = AT+cgdcont=1,\"IP\",\"CMNET\",\"\",0,0" >> $configfile
		elif [ $devicetype == "USB" ]
		then
			echo "Modem = /dev/ttyUSB0" >> $configfile
			echo "Init1 = ATZ" >> $configfile
			echo "Init2 = ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0" >> $configfile
			echo "Init3 = AT+cgdcont=1,\"IP\",\"CMNET\",\"\",0,0" >> $configfile
		elif [ $devicetype == "MBD-100EU" ]
		then
			echo "Modem = /dev/ttyACM0" >> $configfile
			echo "Init1 = ATZ" >> $configfile
			echo "Init2 = AT+CPIN?" >> $configfile
			echo "Init3 = AT+CMEE=2" >> $configfile
			echo "Init4 = AT+CGDCONT=1,\"IP\",\"cmnet\"" >> $configfile
			echo "Init5 = AT+CGATT?" >> $configfile
			echo "Stupid Mode = 1" >> $configfile
		elif [ $devicetype == "EG162G" ]
		then
			echo "Modem = /dev/ttyUSB0" >> $configfile
			echo "Init1 = ATZ" >> $configfile
			echo "Init2 = AT+CPIN?" >> $configfile
			echo "Init3 = AT+CMEE=2" >> $configfile
			echo "Init4 = AT+CGDCONT=1,\"IP\",\"cmnet\"" >> $configfile
			echo "Init5 = AT+CGATT?" >> $configfile
			echo "Stupid Mode = 1" >> $configfile
		else
			echo "error: unknown device type."
			exit 1
		fi
		echo "Modem Type = Analog Modem" >> $configfile
		echo "ISDN = 0" >> $configfile
		echo "Phone = *99***1#" >> $configfile
		echo "Username = any" >> $configfile
		echo "Password = any" >> $configfile
		echo "Baud = 115200" >> $configfile
	;;
	CDMA)
		# 清空interfaces文件中的内容。
		configfile=/etc/network/interfaces
		rm $configfile
		echo "# This file was created by pvplayer (http://www.polarvision.net)" >> $configfile
		echo "# Please do not modify this file." >> $configfile
		echo "" >> $configfile
		echo "# The loopback network interface" >> $configfile
		echo "auto lo" >> $configfile
		echo "iface lo inet loopback" >> $configfile
		# 设置CDMA拨号配置文件。
		configfile=/etc/wvdial.conf
		rm $configfile
		echo "# This file was created by pvplayer (http://www.polarvision.net)" >> $configfile
		echo "# Please do not modify this file." >> $configfile
		echo "" >> $configfile
		echo "[Dialer defaults]" >> $configfile
		echo "Modem = /dev/ttyACM0" >> $configfile
		echo "Init1 = ATZ" >> $configfile
		echo "Modem Type = USB Modem" >> $configfile
		echo "ISDN = 0" >> $configfile
		echo "Phone = #777" >> $configfile
		echo "Username = CARD" >> $configfile
		echo "Password = CARD" >> $configfile
		echo "Baud = 115200" >> $configfile
		echo "Inherits = Modem0" >> $configfile
	;;
	*)
		echo "error: unknown network mode."
		exit 1
esac

exit 0

