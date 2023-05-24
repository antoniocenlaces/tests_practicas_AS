#!/bin/bash
#143045, Gonzalez Almela, Antonio, T, 2, A
#779035, Bernad Ferrando, Lizer, T, 2, A
# Este script no necesita permisos de superusuario para ser ejecutado.
# Los comandos ejecutados en máquina remota que sí necesitan de sudo,
# están incluidos de forma que se envían a esa máquina para ejecutar
# con el cambio de usuario pertinente.
if [ $# -ne 1 ]
then
    echo "Numero incorrecto de parametros"
    exit 1
fi
# Comprueba si la dirección IP suministrada tiene un formato válido
IP=$(echo "$1" | gawk '
BEGIN{
FS="[.,;: ]";
outIP="";
imprime=1;
}
{
if (NF != 4) {
        print $0, "No es una dirección IP válida";
        print "Toda dirección IP está compuesta por 4 bytes expresados en decimal y separados por '.'";
        print "Del tipo 255.255.255.255";
        imprime=0;
        exit 1;
        }
for (i=1; i < 5; i++) {
        if ($i>=0 && $i<=255){
                sep = i == 4 ? "" : ".";
                outIP = outIP $i sep;
                } else {
                print $0, "No es una dirección IP válida";
                print "Cada byte de una dirección IP puede tomar valores entre 0 y 255";
                imprime=0;
                exit 1;
                }
        }
}
END {
if(imprime == 1) print outIP;
}')
if [ $? -ne 0 ]
then
	echo -e "$IP"
	exit 1
fi
# Comprueba si hay conexión por ssh al puerto 22 de la IP suministrada
netcat -z "$IP" 22 2 > /dev/null
if [ $? -eq 0 ]
then
	BLUE_WHITE="\033[34;47m"
	RESET="\033[0m"
	echo -e "$BLUE_WHITE Discos duros disponibles y sus tamaños en bloques. $RESET"
	ssh  "as@$IP" "sudo sfdisk -s"
	echo -e "$BLUE_WHITE Las particiones y sus tamaños. $RESET"
	ssh  "as@$IP" "sudo sfdisk -l"
	echo -e "$BLUE_WHITE Información sobre el montaje de sistemas de ficheros $RESET"
	ssh  "as@$IP" "sudo df -hT" | sed -n '/tmpfs/!p' 
else
	echo "No hay conexión a la IP: $IP"
fi
