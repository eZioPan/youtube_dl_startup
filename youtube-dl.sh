#!/bin/bash
cd "$(dirname "$0")"
function checkbin {
	if [ -x youtube-dl ]; then
		return 0
	else
		echo "No youtube-dl exist"
		echo "Please put youtube-dl program in same directory of this script"
		return 1
	fi
}

function checkaddr {
	echo "Please Input Video Web Page Address"
	read addr
	if [ -n "${addr}" ]; then
		return 0
	else
		echo "No address specified"
		return 1
	fi
}

function checkproxy {
	read -p "Does we need proxy?[Y/N] " rtn
	if [ -z ${rtn} ] || [ ${rtn} == "N" ] || [ ${rtn} == "n" ]; then
		proxy=0
		return 0
	elif [ ${rtn} == "Y" ] || [ ${rtn} == "y" ]; then
		echo "Please keep your sock5 proxy open"
		proxy=1
		return 0
	else
		echo "Wrong Input"
		return 1
	fi
}

function checkdir {
	if [ -d youtube-dl-dir ]; then
		indir=1
		echo "All video will be download in directory youtube-dl-dir"
	elif [ -f youtube-dl-dir ]; then
		indir=0
		echo "youtube-dl-dir is not a directory"
		echo "will download video file in same directory of this script"
	else
		indir=1
		echo "Create youtube-dl-dir for downloaded video"
		mkdir youtube-dl-dir
	fi
}

function download {
	if [ "${proxy}" == 1 ]; then
		proxycmd="--proxy socks5://127.0.0.1:1080/"
	else
		proxycmd=""
	fi
	if [ "${indir}" == 1 ]; then
		desDir="-o ./youtube-dl-dir/%(title)s-%(id)s.%(ext)s"
	else
		desDir="-o ./%(title)s-%(id)s.%(ext)s"
	fi
	./youtube-dl ${proxycmd} ${desDir} ${addr}
}

checkbin && checkaddr && checkproxy && checkdir && download

