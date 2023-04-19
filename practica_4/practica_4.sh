#!/bin/bash
#779035, Bernad Ferrando, Lizer, T, 2, A
#143045, Gonzalez Almela, Antonio, T, 2, A
# Este script no necesita permisos de superusuario para ser ejecutado.
# Los comandos ejecutados en máquina remota que sí necesitan de sudo,
# están incluidos de forma que se envían a esa máquina para ejecutar
# con el cambio de usuario pertinente. 
if [ $# -ne 3 ]
then
    echo "Numero incorrecto de parametros"
    exit 1
fi
# Cambia el separador por defecto a ','
OLDIFS=$IFS
IFS=','
case "$1" in
    -a)
        while read ip
        do
            netcat -z $ip 22 2 > /dev/null
            if [ $? -eq 0 ]
            then
                while read user pass nombre
                do
                    # Comprueba si algún campo leido del fichero está vacío
                    if [ -z "$user" ] || [ -z "$pass" ] || [ -z "$nombre" ]
                    then # Si algún campo no tiene valor muestra mensaje
                        echo "Campo invalido"
                        exit 1
                    else
                        # Comprueba si existe este $user en la máquina remota
                        ssh -n as@$ip "id -u $user &>/dev/null"
                        if [ $? -eq 0 ]
                        then # El $user existe. Muestra mensaje
                            echo "El usuario $user ya existe"
                        else
                            ssh -n as@$ip 'sudo useradd' "$user" '-U -m -k /etc/skel -K UID_MIN=1815 -c' \""$nombre"\"
                            ssh -n as@$ip "echo $user:$pass | sudo chpasswd"
                            ssh -n as@$ip "echo $nombre ha sido creado"
                        fi
                    fi
                done < "$2"
            fi
        done < "$3" ;;
    -s)
        # echo "Opción -s leida"
        while read ip
        do
            netcat -z $ip 22 2 > /dev/null
            if [ $? -eq 0 ]
            then
                # Comprueba si ya existe el directorio para backup
                ssh -n as@$ip [ ! -d /extra/backup ]
                if  [ $? -eq 0 ]
                then # Caso contrario lo crea
                    ssh -n as@$ip "sudo mkdir -p /extra/backup"
                fi
                while read user pass nombre
                do
                    # Comprueba si existe este $user
                    ssh -n as@$ip "id -u $user &>/dev/null"
                    if [ $? -eq 0 ]
                    then # El $user existe y podemos borrarlo

                    # La siguiente línea ejecuta en la máquina remota
                    # solo ssh -n as@192.168.56.11 "cat /etc/passwd" el resto en local
                    directorio=$(ssh -n as@192.168.56.11 "cat /etc/passwd" | grep "$user" | cut -d ':' -f 6)
                    
                    # Hace copia de seguridad de directorio local
                    ssh -n as@$ip "sudo tar -cf /extra/backup/$user.tar $directorio &>/dev/null"

                    # Borra el usuario y su directorio home
                    ssh -n as@$ip "sudo userdel -r $user &>/dev/null"
                    fi
                done < "$2"
            fi
        done < "$3" ;;
    *)
        echo "Opcion invalida" 2>/dev/stderr;;
esac
# Restaura el separador por defecto
IFS=$OLDIFS