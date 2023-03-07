#!/bin/bash
#779035, Bernad Ferrando, Lizer, T, 2, A
#143045, Gonzalez Almela, Antonio, T, 2, A
echo -n "Introduzca el nombre de un directorio: "
read respuesta
if [ -d "$respuesta" ]
then
	numDirectorios=$(find "$respuesta" -maxdepth 1 -type d | wc -l)
	numDirectorios=$[ numDirectorios-1 ]
	numFicheros=$(find "$respuesta" -maxdepth 1 -type f | wc -l)
	echo "El numero de ficheros y directorios en $respuesta es de $numFicheros y $numDirectorios, respectivamente"
else
	echo "$respuesta no es un directorio"
fi