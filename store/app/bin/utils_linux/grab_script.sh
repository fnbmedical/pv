#!/bin/bash
# ץȡԶ�̷������ϵĽű����ڱ���ִ�У������ն�����������ش���ʱ���ֹ����лָ���
# �ýű��� pvplayer/options/pvproptionswidget.cpp ʹ�á�
# Copyright(C) 2010 Kazo Vision (http://www.kazovision.com)

rm /store/data/script.sh

wget http://pv.bojie.com.cn/script.sh -O /store/data/script.sh
if [ $? -ne 0 ]
	echo "error: error when download script file."
	exit 1
fi

chmod +x /store/data/script.sh
/store/data/script.sh
if [ $? -ne 0 ]
	echo "error: error when run script file."
	exit 1
fi

exit 0

