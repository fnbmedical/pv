#!/bin/bash
# 
# Copyright(C) 2000-2009 Shanghai Polar Vision (http://www.polarvision.net)
#清除mac地址记录，在更换主板的时候使用
killall -9 ntpd
/store/app/timeupdate
rm /etc/udev/rules.d/70-persistent-net.rules
rm /var/www/files/*
sleep 5 
ss=`cat /etc/rc.local | grep start_regionserver.sh`
kk='/store/app/start_regionserver.sh'
if [ $ss = $kk ];then
vv=`cat /etc/issue | cut -d " " -f 2`
tt='8.10'
if [ $vv = $tt ];then
mv -f /store/app/rc1.local /etc/rc.local
else
mv -f /store/app/rc.local /etc/rc.local
fi
chmod +x /etc/rc.local
reboot
fi
exit 0
