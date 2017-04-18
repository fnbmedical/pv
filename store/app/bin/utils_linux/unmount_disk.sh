#!/bin/bash
# 卸载之前用mount_disk.sh挂接到/media/目录下的设备。并在成功卸载后弹出光驱，以给予用户提示。
# 该脚本被 pvprocessor/fileimport/pvpcautoimportthread.cpp 使用。
# 关联脚本：mount_disk.sh, is_device_exists.sh
# Copyright(C) 2010 Kazo Vision (http://www.kazovision.com)

umount /media/

# 弹出CD-ROM
eject cdrom

exit 0

