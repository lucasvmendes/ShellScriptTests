#!/bin/bash

while getopts "f:" OPTION
do
        case $OPTION in
                f) filename=$OPTARG;;
        esac
done

echo "Carregando e criando lista de usuários."
while read LINHA; do
	USUARIO=$(echo $LINHA | awk '{print $1}')
	SENHA=$(echo $LINHA | awk '{print $2}')
	GRUPO=$(echo $LINHA | awk '{print $3}')
	useradd -m -d /home/$USUARIO $USUARIO -p $(openssl passwd -1 $SENHA) -s /bin/bash -g $GRUPO
done < "$filename"
echo "Lista de usuários carregada."

while [ "$opcao" != "5" ]; do
	echo "1 - Bloquear todos usuários da lista"
	echo "2 - Desbloquear todos usuários da lista"
	echo "3 - Alterar nome de usuário da lista"
	echo "4 - Alterar grupo de todos usuarios da lista"
	echo "5 - Sair"
	read opcao
	if [ "$opcao" = "1" ]; then
		echo "Bloquear todos usuários da lista"
		while read LINHA; do
			USUARIO=$(echo $LINHA | awk '{print $1}')
			passwd -l $USUARIO
		done < "$filename"
		echo "Todos usuários bloqueados."
	elif [ "$opcao" = "2" ]; then
		echo "Desbloquear todos usuarios da lista"
		while read LINHA; do
			USUARIO=$(echo $LINHA | awk '{print $1}')
			passwd -u $USUARIO
		done < "$filename"
		echo "Todos usuários desbloqueados."
	elif [ "$opcao" = "3" ]; then
		echo "Digite o nome original do usuário"
		read nomeoriginal
		echo "Digite o nome de usuário desejado"
		read nomedesejado
		sed -i "s/$nomeoriginal/$nomedesejado/g" "$filename"
		usermod -l $nomedesejado $nomeoriginal
		echo "Nome de usuário alterado."
	elif [ "$opcao" = "4" ]; then
		echo "Digite o nome do novo grupo:"
		read novogrupo
		while read LINHA; do
			USUARIO=$(echo $LINHA | awk '{print $1}')
			GRUPO=$(echo $LINHA | awk '{print $3}')
			sed -i "s/$GRUPO/$novogrupo/g" "$filename"
			usermod -g $novogrupo $USUARIO
		done < "$filename"
		echo "Grupo alterado."
	fi
done
