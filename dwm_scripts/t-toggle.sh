#!/bin/bash

result=$(ps ax | grep -v "grep" | grep "trayer")
if [[ "${result}" == "" ]]; then
    trayer --transparent true --expand false --align center --width 20 --SetDockType false --tint 0x88888888 &
else
    killall trayer
fi

