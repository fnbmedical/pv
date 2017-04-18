#!/bin/bash
# Run communicator.
# Copyright(C) 2010-2011 Kazo Vision (http://www.kazovision.com)
export LD_LIBRARY_PATH=/store/app/lib

chmod +x /store/app/bin/utils_linux/com

while [ true ]
do
	/store/app/bin/utils_linux/com $1 $2 $3 $4 $5 $6 $7 $8 $9
	exitcode=$?
	sleep 120
done

exit 0

