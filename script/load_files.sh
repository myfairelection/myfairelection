#!/bin/sh

for file in feeds/*.xml
do
	rails runner 'Feed.load_from_file' $file
	if [[ $? != 0 ]] ; then
    	exit 1
	fi
done
