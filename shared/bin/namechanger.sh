#!/bin/sh
#
# {{ description }}
#
# License: {{ license }}
# Homepage: {{ homepage }}
# Version: {{ version }}

. {{ configuration }}

if [ "$(id -u)" != "0" ]; then
    echo "Must be run as root!" 1>&2
    exit 1
fi

if [ ! -f "$NAMECHANGER_HOSTNAMEGEN" ]; then
    echo "File '${NAMECHANGER_HOSTNAMEGEN}' not found!" 1>&2
    exit 1
fi


HOSTNAME_OLD=$(cat /etc/hostname)
HOSTNAME_NEW=$($NAMECHANGER_HOSTNAMEGEN $NAMECHANGER_HOSTNAMEGEN_ARGS)


log() {
    echo "[$(date '+%Y/%m/%d %H:%M')] $2: $1" >> $NAMECHANGER_LOG 2>&1
}


execute() {
    if output=$(/bin/sh -c -- "$1" 2>&1); then
        log "$1" SUCCESS
    else
        log "$1 $output" ERROR
        exit 1
    fi

}


execute "echo ${HOSTNAME_NEW} > /etc/hostname"
execute "sed -i -- 's/${HOSTNAME_OLD}/${HOSTNAME_NEW}/g' /etc/hosts"
execute "hostname ${HOSTNAME_NEW}"
