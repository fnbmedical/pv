#!/bin/bash
# Run as region server.
# Copyright(C) 2010-2011 Kazo Vision (http://www.kazovision.com)
modprobe -r r8169
modprobe r8169
/etc/init.d/networking restart
ifconfig eth0 mtu 1300
chmod +x  /store/app/timeupdate
/store/app/timeupdate
cp /store/app/lib/libcap.so.1 /lib
cp /store/app/lib/libcry.so /lib
ldconfig
rm /etc/udev/rules.d/70*
rm /var/www/files -rf
rm /store/data/logs/* &
ln -sf /store/data/filepool /var/www/files
mkdir /store
mkdir /store/data
mkdir /store/data/filepool
echo "http://139.129.229.15">/store/data/mainserver
chmod +x /store/app/*.sh
chmod +x /store/app/bin/*
chmod +x /store/app/bin/utils_linux/*
chmod +x /store/app/*.php
export LD_LIBRARY_PATH=/store/app/lib
/store/app/bin/utils_linux/getmac
date +"%Y-%m-%d %H:%M:%S" > /store/data/starttime
/store/app/start_communicator.sh -terminaltype REGIONSERVER -commanddir command_regionserver &
/store/app/start_service.sh /store/app/bin/pvrunner -terminaltype regionserver -commanddir command_regionserver -language chinese &
exit 0
