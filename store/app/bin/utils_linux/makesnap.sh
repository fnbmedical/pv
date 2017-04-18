#!/bin/sh
rm /store/data/snapshot/* -rf
mkdir /store/data/snapshot
for i in /store/data/filepool/*.avi;do
c=/store/data/snapshot/`basename $i .avi`.png
echo $c
touch $c
done
