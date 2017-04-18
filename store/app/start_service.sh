#!/bin/bash
# Run specified service.
# Copyright(C) 2010-2011 Kazo Vision (http://www.kazovision.com)

chmod +x $1
export LD_LIBRARY_PATH=/store/app/lib

while [ true ]
do
	$1 $2 $3 $4 $5 $6 $7 $8 $9
	exitcode=$?

	if [ $exitcode -eq 0 ]
	then
		break
	fi

	sleep 5
done
