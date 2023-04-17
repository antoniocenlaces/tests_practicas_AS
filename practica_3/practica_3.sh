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
        # Cambia el separador por defecto a ','
        OLDIFS=$IFS
        IFS=','
        case "$1" in
            -a)
                while read user pass nombre
                do
                    if [ -z "$user" ] || [ -z "$pass" ] || [ -z "$nombre" ] # Comprueba si algún campo leido del fichero está vacío
                    then # Si algún campo no tiene valor muestra mensaje
                        echo "Campo invalido"
                        exit 1
                    else
                        id -u "$user" >/dev/null 2>/dev/null # Comprueba si existe este $user
                        if [ $? -eq 0 ]
                        then # El $user existe. Muestra mensaje
                            echo "El usuario $user ya existe"
                        else
                            useradd "$user" -U -m -k /etc/skel -K UID_MIN=1815 -c "$nombre"
                            usermod --expiredate "$(date -d "+30 days" +%Y-%m-%d)" "$user"
                            echo "$user:$pass" | chpasswd
                            echo "$nombre ha sido creado"
                        fi
                    fi
                done < "$2";;
            -s)
               # echo "Opción -s leida"
                if [ ! -d /extra/backup ] # Comprueba si ya existe el directorio para backup
                then # Caso contrario lo crea
                    mkdir -p /extra/backup
                fi
                while read user pass nombre
                do
                    # echo "Usuario: $user $pass $nombre está en el fichero";
                    id -u "$user" >/dev/null 2>/dev/null # Comprueba si existe este $user
                    if [ $? -eq 0 ]
                    then # El $user existe y podemos borrarlo
                        directorio=$(grep "$user" /etc/passwd | cut -d ':' -f 6)
                        if [ -d "$directorio" ] # Comprueba que este usuario tiene directorio local
                        then
                            tar -cf "/extra/backup/$user".tar "$directorio/" # Hace copia de seguridad de directorio local
                        fi
                        # Borra el usuario y su directorio home
                        userdel -r "$user" >/dev/null 2>/dev/null
                    fi
                done < "$2";;
            *)
                echo "Opcion invalida" 2>/dev/stderr;;
        esac
        # Restaura el separador por defecto
        IFS=$OLDIFS
    fi
fi
