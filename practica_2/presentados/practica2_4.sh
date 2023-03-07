#!/bin/bash
#779035, Bernad Ferrando, Lizer, T, 2, A
#143045, Gonzalez Almela, Antonio, T, 2, A
ifsOriginal=$IFS
IFS=$''
echo -n "Introduzca una tecla: "
read -r respuesta
tecla=${respuesta:0:1}
case $tecla in
	[a-z] | [A-Z])
		echo "$tecla es una letra" ;;
	[0-9])
		echo "$tecla es un numero" ;;
	*)
		echo "$tecla es un caracter especial" ;;
esac
IFS=$ifsOriginal