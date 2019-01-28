#!/usr/bin/env bash
# Copyright (C) 2019 LinkedData.Center - All Rights Reserved
# Permission to copy and modify is granted under the MIT license
# see https://wiki.alpinelinux.org/wiki/How_to_get_regular_stuff_working

if [  -z "$PWD/.git" ]; then
        echo "please launch this script in  project home page"
        exit
fi

if [ $(id -u) -ne 0 ];then
        echo "please launch this script as root"
        exit
fi

apk --no-cache add \
	coreutils \
	curl \
	findutils \
	gawk \
	grep \
	openssl \
	raptor2 \
	sed \
	net-tools