#!/bin/sh

while true; do
    sleep 10
    printf "background\n"
done &

while true; do
    sleep 10
    printf "foreground\n"
done
