#!/bin/bash
# ���ָ�����Ƶ��豸�Ƿ���ڣ����ڵĻ�����0�������ڷ���1��
# �ýű��� pvprocessor/fileimport/pvpcautoimportthread.cpp ʹ�á������ж��û��Ƿ��Ѽ�����ɵ��豸�γ���
# �����ű���mount_disk.sh, unmount_disk.sh
# Copyright(C) 2010 Kazo Vision (http://www.kazovision.com)

if [ -z $1 ]
then
	echo "error: must input the device name.";
	exit 1
fi

if [ -e $1 ]
then
	echo "device exists."
	exit 0
fi

exit 1

