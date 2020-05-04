#!/bin/bash

while getopts "u:" OPTION
do
        case $OPTION in
                u) usuario=$OPTARG;;
        esac
done
echo "Conectando ao server"
ssh $usuario@127.0.0.1