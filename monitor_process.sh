#!/bin/bash

while getopts "f:" OPTION
do
    case $OPTION in
        f) arquivo=$OPTARG;;
    esac
done

(crontab -l; echo "*/15 * * * * /bin/ps aux >> /home/lucasvarisco/$arquivo") | crontab
