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
        OLDIFS=$IFS
        IFS=','
        case "$1" in
            -a)
                echo "Opción -a leida";;
            -s)
                # echo "Opción -s leida"
                while read user pass nombre
                do
                    echo "Usuario: $user $pass $nombre está en el fichero";
                    id -u "$user" >/dev/null 2>/dev/null # Comprueba si existe este $user
                    if [ $? -eq 0 ]
                    then # El $user existe y podemos borrarlo
                        if [ ! -d /extra/backup ] # Comprueba si ya existe el directorio para backup
                        then # Caso contrario lo crea
                            mkdir -p /extra/backup
                        fi
                        if [ -d /home/"$user" ] # Comprueba que este usuario tiene directorio local
                        then
                            tar -cf /extra/backup/"$nombre".tar /home/"$nombre"/ # Hace copia de seguridad de directorio local
                        fi
                        # Borra el usuario y su directorio /home/user
                        userdel -r "$user" >/dev/null 2>/dev/null
                    else
                        echo "El usuario $user no existe"
                    fi
                done < "$2";;
            *)
                echo "Opcion invalida" 2>/dev/stderr;;
        esac
        IFS=$OLDIFS
    fi
fi
