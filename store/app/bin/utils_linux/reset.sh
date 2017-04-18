#!/bin/sh
/store/app/stop.sh
sleep 5
rm /store/data -rf
reboot
