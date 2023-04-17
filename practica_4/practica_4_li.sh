#!/bin/bash
#779035, Bernad Ferrando, Lizer, T, 2, A
#143045, Gonzalez Almela, Antonio, T, 2, A
if [ $EUID -ne 0 ]
then
	echo "Este script necesita privilegios de administracion"
	exit 1
else
	if [ $# -ne 3 ]
	then
		echo "Numero incorrecto de parametros"
	else
		case "$1" in
			-a)
				while read ip
				do
					ssh -n as@$ip
					if [ "$?" -eq 0 ]
					then
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
								echo "El usuario "$nombre" ya existe"
							else
								ssh -n as@$ip "useradd "$nombre" -U -m -k /etc/skel -K UID_MIN=1815 -c "$apodo" ; usermod --expiredate "$(date -d "+30 days" +%Y-%m-%d)" "$nombre" ; echo "$nombre:$clave" | chpasswd ; echo ""$apodo" ha sido creado""
							fi
						done < $2
					else
						echo "$ip no es accesible"
					fi
				done < $3;;
			-s)
				while read ip
				do
					ssh -n as@$ip
					if [ "$?" -eq 0 ]
					then
						ssh -n as@$ip "if [ ! -d \"/extra/backup\" ]; then if [ ! -d \"/extra\" ]; then mkdir /extra; mkdir /extra/backup; else mkdir /extra/backup; fi; fi"
						while read linea
						do
							nombre=$(echo "$linea" | cut -d ',' -f 1)
							ssh -n as@$ip "directorio=$(grep "$nombre" /etc/passwd | cut -d ':' -f 6) ; homeUsuario=\"${directorio%/*}\" ; if tar -cf "$nombre".tar \"\$homeUsuario\"/"$nombre" ; then mv "$nombre".tar /extra/backup ; userdel -r "$nombre" 2>/dev/null ; fi"
						done < $2
					fi
				done < "$3";;
				
			*)
				echo "Opcion invalida" 2>/dev/stderr;;
		esac
	fi	
fi
