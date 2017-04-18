#!/bin/bash
# Run as player.
# Copyright(C) 2010-2011 Kazo Vision (http://www.kazovision.com)
set -x
ifconfig eth0 mtu 1300
rm /etc/udev/rules.d/70*
rm /store/data/logs/* &
export LD_LIBRARY_PATH=/store/app/lib
mkdir /store
mkdir /store/data
mkdir /store/data/contents
mkdir /store/data/filepool
rm /store/data/logs/* -rf
chmod +x /store/app/*.sh
chmod +x /store/app/bin/utils_linux/*
chmod +x /store/app/bin/*
chmod +x /store/app/*.php
echo "http://139.129.229.15">/store/data/mainserver
/store/app/bin/utils_linux/getmac
if [ -r /store/app/vpn_on ]
then
/store/app/bin/vtund -f /store/app/vpn cobra 139.129.229.15
fi
apppath=$(dirname $0)
debugmode=$1

start_and_wait_x() {
	xstarted=0

	# kill previous Xorg if exists.
	killall -9 Xorg >/dev/null 2>&1

	sleep 3
	
	# run X
	X -dpi 96 -br -noreset -p 0 -s 0 -dpms -nolisten tcp &

	# wait until X started.
	waitcount=0
	while [ $waitcount -lt 10 ]
	do
		if [ -r /tmp/.X11-unix/X0 ]
		then
			xstarted=1
			break
		fi
		waitcount=$(($waitcount+1))
		sleep 1
	done
}

chmod +x /store/app/*.sh
chmod +x /store/app/bin/utils_linux/*
chmod +x /store/app/bin/*

export DISPLAY=:0


/store/app/start_communicator.sh -terminaltype MEDIAPLAYER -commanddir command_mediaplayer &
/store/app/start_service.sh /store/app/bin/pvrunner -terminaltype mediaplayer -commanddir command_mediaplayer -language chinese &
/store/app/start_service.sh /store/app/bin/pvsensor -devicename /dev/ttyACM0 &


if [ "$debugmode" != "debug" ]
then
	start_and_wait_x
	if [ $xstarted -ne 1 ]
	then
		echo "error: error when start X."
		exit 1
	fi
	sleep 4
fi

# Set Webkit flash path.
export MOZ_PLUGIN_PATH=$apppath/libflash10

mkdir /store
mkdir /store/data
mkdir /store/data/snapshot
date +"%Y-%m-%d %H:%M:%S" > /store/data/starttime

# Run player.
chmod +x /store/app/bin/pvplayer
chmod +x /store/app/bin/pvosd
chmod +x /store/app/bin/pvtextplayer
while [ true ]
do

	if [ "$debugmode" != "debug" ]
	then
		/store/app/bin/movemouse

		/store/app/play_check.php
	else
		/store/app/bin/pvplayer -language chinese -scriptfile "`/store/app/bin/utils_linux/select_content.php`" -position 0,0,500,300
	fi
	exitcode=$?

	# if software crashed, run it again.
	if [ $exitcode -eq 0 ]
	then
		# finish all
		break;
	elif [ $exitcode -eq 1 ]
	then
		# restart the player
		echo "restart pvplayer."
	else
		echo "error: pvplayer fatal error. code = $exitcode"
	fi

	sleep 5
done

/store/app/stop.sh
sleep 5

if [ "$debugmode" != "debug" ]
then
	killall -9 Xorg >/dev/null 2>&1
fi

echo "bye."

exit 0

