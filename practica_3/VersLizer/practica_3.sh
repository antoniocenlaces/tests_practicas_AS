#!/bin/bash
#779035, Bernad Ferrando, Lizer, T, 2, A
#143045, Gonzalez Almela, Antonio, T, 2, A
if [ $EUID -ne 0 ]
then
	echo "Este script necesita privilegios de administracion"
	exit 1
else
	if [ $# -ne 2 ]
	then
		echo "Numero incorrecto de parametros"
	else
		case "$1" in
			-a)
				while read linea
				do
					nombre=$(echo "$linea" | cut -d ',' -f 1)
					clave=$(echo "$linea" | cut -d ',' -f 2)
					apodo=$(echo "$linea" | cut -d ',' -f 3)
					if [ -z "$nombre" ] || [ -z "$clave" ] || [ -z "$apodo" ]
					then
						echo "Campo invalido"
						exit 1
					fi
					uid=$(id -u "$nombre" 2>/dev/null)
					if [ -n "$uid" ]
					then
						echo "El usuario "$uid" ya existe"
					else
						useradd -m -u 1815 -s /bin/bash -d "/home/$nombre" -k /etc/skel "$nombre"
						usermod --expiredate "$(date -d "+30 days" +%Y-%m-%d)" "$nombre"
						echo "$nombre:$clave" | chpasswd
						echo ""$apodo" ha sido creado"
					fi
				done < $2;;
			-s)
				if [ ! -d "/extra/backup" ]
				then
					mkdir extra
					mkdir /extra/backup
				fi
				while read linea
				do
					nombre=$(echo "$linea" | cut -d ',' -f 1)
					if tar -cf /extra/backup/"$nombre".tar /home/"$nombre"/
					then
						userdel -r "$nombre" 2>/dev/null
					fi
				done < $2;;
			*)
				echo "Opcion invalida" 2>/dev/stderr;;
		esac
	fi	
fi