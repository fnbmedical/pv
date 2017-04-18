#!/bin/bash
# 返回系统硬件信息。
# 该脚本被 pvprocessor/process/pvpcgetstatuscommandprocessor.cpp 使用。
# Copyright(C) 2010 Kazo Vision (http://www.kazovision.com)
terminaltype=$1

haswarning=0
haserror=0

systeminfo="SYS:LINUX; "

# 系统运行总时间
uptime=`uptime`
if $(echo $uptime | grep -E "min|day" > /dev/null)
then
	uptime=$(echo $uptime | awk '{print $3" "$4" "$5}')
else
	uptime=$(echo $uptime | awk '{print $3}')
fi
systeminfo=$systeminfo"UP:$uptime; "

# 本机IP地址
ipaddress=`ip -f inet addr | grep global | awk '{print $2}' | awk -F/ '{print $1}'`
systeminfo=$systeminfo"IP:$ipaddress; "

# 内存使用情况
memorytotalsize=`free -m | awk 'NR==2 {print $2"M"}'`
systeminfo=$systeminfo"MEM_SIZE:$memorytotalsize; "
memoryusedsize=`free -m | awk 'NR==3 {print $3"M"}'`
systeminfo=$systeminfo"MEM_USED:$memoryusedsize; "

# 硬盘总空间/剩余空间
disktotalsize=`df / -h | awk 'NR==2 {print $2}'`
systeminfo=$systeminfo"DISK_SIZE:$disktotalsize; "
diskfreesize=`df / -h | awk 'NR==2 {print $4}'`
systeminfo=$systeminfo"DISK_FREE:$diskfreesize; "

# 播放系统。
if [ "$terminaltype" == "MEDIAPLAYER" ]
then
	# 同步模式
	synchronizemode="UNKNOWN"
	if [ -f /store/data/mediaplayer/synchronizemode ]
	then
		synchronizemode=`cat /store/data/mediaplayer/synchronizemode`
	fi
	systeminfo=$systeminfo"SYNC_MODE:$synchronizemode; "

	# 硬盘上媒体文件占据的空间
	diskmediasize=`du -h /store/data/filepool | awk '{print $1}'`
	systeminfo=$systeminfo"MEDIA_SIZE:$diskmediasize; "

	# 显示器电源
	monitorpower=""
	which get-edid >/dev/null
	if [ $? -eq 0 ]
	then
		get-edid >/dev/null 2>&1
		monitorstatus=$?
		if [ $monitorstatus -eq 0 ]
		then
			monitorpower="ON"
		elif [ $monitorstatus -eq 1 ]
		then
			monitorpower="OFF"
			haswarning=1
		else
			monitorpower="UNKNOWN"
			haswarning=1
		fi
	else
		monitorpower="UNKNOWN"
		haswarning=1
	fi
	systeminfo=$systeminfo"MONITOR_POWER:$monitorpower; "

	# 前台播放软件
	killall -0 pvplayer >/dev/null 2>&1
	if [ $? -eq 0 ]
	then
		systeminfo=$systeminfo"PLAYER:ON; "
	else
		systeminfo=$systeminfo"PLAYER:OFF; "
		haserror=1
	fi

	# 固件版本号
	firmwareversion="UNKNOWN"
	if [ -f /store/data/sensor/firmware_version ]
	then
		firmwareversion=`cat /store/data/sensor/firmware_version`
	fi
	systeminfo=$systeminfo"DOG_VER:$firmwareversion; "

	# 显示屏温度
	screentemperature="UNKNOWN"
	if [ -f /store/data/sensor/screen_temperature ]
	then
		screentemperature=`cat /store/data/sensor/screen_temperature`
	fi
	systeminfo=$systeminfo"SCR_TEM:$screentemperature; "

	# 显示屏亮度
	screenbrightness="UNKNOWN"
	if [ -f /store/data/sensor/screen_brightness ]
	then
		screenbrightness=`cat /store/data/sensor/screen_brightness`
	fi
	systeminfo=$systeminfo"SCR_BRI:$screenbrightness; "

	# PCB温度
	pcbtemperature="UNKNOWN"
	if [ -f /store/data/sensor/pcb_temperature ]
	then
		pcbtemperature=`cat /store/data/sensor/pcb_temperature`
	fi
	systeminfo=$systeminfo"PCB_TEM:$pcbtemperature; "

	# PCB湿度
	pcbhumidity="UNKNOWN"
	if [ -f /store/data/sensor/pcb_humidity ]
	then
		pcbhumidity=`cat /store/data/sensor/pcb_humidity`
	fi
	systeminfo=$systeminfo"PCB_HUM:$pcbhumidity; "
	
	# 显示屏12V电源
	screenboard12v="UNKNOWN"
	if [ -f /store/data/sensor/screen_board_12v ]
	then
		screenboard12v=`cat /store/data/sensor/screen_board_12v`
	fi
	systeminfo=$systeminfo"SCR_12V:$screenboard12v; "
	
	# 显示屏24V电源
	screenboard24v="UNKNOWN"
	if [ -f /store/data/sensor/screen_board_24v ]
	then
		screenboard24v=`cat /store/data/sensor/screen_board_24v`
	fi
	systeminfo=$systeminfo"SCR_24V:$screenboard24v; "
	
	# 显示屏继电器状态
	relaystatusscreen="UNKNOWN"
	if [ -f /store/data/sensor/relay_status_screen ]
	then
		relaystatusscreen=`cat /store/data/sensor/relay_status_screen`
	fi
	systeminfo=$systeminfo"RLY_SCR:$relaystatusscreen; "
	
	# PC继电器状态
	relaystatuspc="UNKNOWN"
	if [ -f /store/data/sensor/relay_status_pc ]
	then
		relaystatuspc=`cat /store/data/sensor/relay_status_pc`
	fi
	systeminfo=$systeminfo"RLY_PC:$relaystatuspc; "
	
	# 温控阈值
	temperaturethreshold="UNKNOWN"
	if [ -f /store/data/sensor/temperature_threshold ]
	then
		temperaturethreshold=`cat /store/data/sensor/temperature_threshold`
	fi
	systeminfo=$systeminfo"TEM_THR:$temperaturethreshold; "
	
	#监控板时间
	dog_time="UNKNOWN"
        if [ -f /store/data/sensor/system_time ]
        then
                dog_time=`cat /store/data/sensor/system_time`
        fi
        systeminfo=$systeminfo"DOG_TIME:$dog_time; "

	# 开关机时间
	openclosetime="UNKNOWN"
	if [ -f /store/data/sensor/open_close_time ]
	then
		openclosetime=`cat /store/data/sensor/open_close_time`
	fi
	systeminfo=$systeminfo"RUN_TIME:$openclosetime; "
	
	# 屏主板TTL数据
	screenboarddatattl="UNKNOWN"
	if [ -f /store/data/sensor/screen_board_data_ttl ]
	then
		screenboarddatattl=`cat /store/data/sensor/screen_board_data_ttl`
	fi
	systeminfo=$systeminfo"SCR_TTL:$screenboarddatattl; "
	
	# 屏主板I2C数据
	screenboarddatai2c="UNKNOWN"
	if [ -f /store/data/sensor/screen_board_data_i2c ]
	then
		screenboarddatai2c=`cat /store/data/sensor/screen_board_data_i2c`
	fi
	systeminfo=$systeminfo"SCR_I2C:$screenboarddatai2c; "
	
	# 跳线状态
	jumperstatus="UNKNOWN"
	if [ -f /store/data/sensor/jumper_status ]
	then
		jumperstatus=`cat /store/data/sensor/jumper_status`
	fi
	systeminfo=$systeminfo"JUMP:$jumperstatus; "
# 区域服务器。
elif [ "$terminaltype" == "REGIONSERVER" ]
then
	# 区域服务器本地apache服务地址。
	regionserveraddress="UNKNOWN"
	if [ -f /store/data/regionserver/regionserveraddress ]
	then
		# 所读取的当前区域服务器本地地址，是由 pvstCommunicate 类初始化的时候生成的。
		regionserveraddress=`cat /store/data/regionserver/regionserveraddress`
	fi
	systeminfo=$systeminfo"RS_ADD:$regionserveraddress; "

	# APACHE
	killall -0 apache2 >/dev/null 2>&1
	if [ $? -eq 0 ]
	then
		systeminfo=$systeminfo"APACHE:ON; "
	else
		systeminfo=$systeminfo"APACHE:OFF; "
		haserror=1
	fi
fi
scount=`/store/app/bin/utils_linux/verify.php`
if [ $haserror -eq 1 ]
then
	systeminfo="V20160927;lost:"$scount";"$systeminfo"STATUS:ERROR"
elif [ $haswarning -eq 1 ]
then
	systeminfo="V20160927;lost:"$scount";"$systeminfo"STATUS:WARNING"
else
	systeminfo="V20160927;lost:"$scount";"$systeminfo"STATUS:NORMAL"
fi

echo $systeminfo

