#!/bin/bash
# 检查是否有闪存或CD-ROM设备插入在系统中，有的话则自动对其mount，设备中的内容被mount到 /media 路径下。
# 该脚本被 pvprocessor/fileimport/pvpcautoimportthread.cpp 使用。
# 关联脚本：unmount_disk.sh, is_device_exists.sh
# Copyright(C) 2010 Kazo Vision (http://www.kazovision.com)

# 先卸载之前挂载的设备。
umount /media/

# 遍历所有USB设备，并尝试挂接。
dev=(sdb sdc sdd)
for d in ${dev[@]}
do
	if [ -e /sys/block/$d ]
	then
		devicename=/dev/${d}1
		mount $devicename /media -w
		if [ $? -eq 0 ]
		then
			# 告知已挂接的设备名称。
			echo "mounted device: $devicename"
			exit 0
		fi
	fi
done

# 没有任何设备被挂接。
exit 1

