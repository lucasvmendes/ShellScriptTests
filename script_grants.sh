#!/bin/bash
while getopts "f:u:g:r:d:h:n:c:s:" OPTION
do
        case $OPTION in
                f) lista=$OPTARG;;
                u) usuario=$OPTARG;;
                g) grant=$OPTARG;;
                r) revoke=$OPTARG;;
                d) database=$OPTARG;;
                h) host=$OPTARG;;
                n) nome=$OPTARG;;
                c) comando=$OPTARG;;
                s) senha=$OPTARG;;
        esac
done
if [ "$nome" ]; then
mysql -u $nome $database -p$senha -e "$comando"
[ "$?" = "0" ] && echo "Operacao OK" || echo "Operação: ERRO"
else
        if [ "$lista" ]; then
                while read LINHA; do
                        USUARIO=$(echo $LINHA | awk '{print $1}')
                        if [ "$grant" ]; then
                        comandogr="GRANT $grant ON $database.* TO $USUARIO@$host;"
                        else
                        comandogr="REVOKE $revoke ON $database.* FROM $USUARIO@$host;"
                        fi
                        echo "Executando query ' $comandogr ' "
                        mysql -uroot -proot -e "$comandogr"
						[ "$?" = "0" ] && echo "Operacao OK" || echo "Operação: ERRO"
                done < "$lista"
        else
                if [ "$grant" ]; then
                comandogr="GRANT $grant ON $database.* TO $usuario@$host;"
                else
                comandogr="REVOKE $revoke ON $database.* FROM $usuario@$host;"
                fi
                echo "Executando query ' $comandogr ' "
                mysql -uroot -proot -e "$comandogr"
				[ "$?" = "0" ] && echo "Operacao OK" || echo "Operação: ERRO"
        fi
fi
