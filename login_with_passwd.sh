#!/bin/bash

while getopts "u:s:" OPTION
do
        case $OPTION in
                u) usuario=$OPTARG;;
                s) senha=$OPTARG;;
        esac
done
echo "Conectando ao server"
sshpass -p $senha ssh $usuario@127.0.0.1