#!/bin/sh

IFACE=$(ifconfig | grep cscotun | awk '{print $1}')

if [ "$IFACE" = "cscotun*" ]; then
    echo " :$(ifconfig cscotun0 | grep inet | awk '{print $2}' | cut -f2 -d ':')"
else
    echo "%{+u}: : Disconnected%{u-}"
fi
