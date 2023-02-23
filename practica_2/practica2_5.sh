#!/bin/bash
echo -n "Introduzca el nombre de un directorio: "
read directorio
# echo "Lo que he leido: $directorio"
if [ -d "$directorio" ]
then
    ficheros=0
    directorios=0
   # contador=0
    cd "$directorio"
    for item in *
    do
    # contador=$((contador+1))
    # echo "Para el item numero $contador el ls ha dado $directorio/$item"
    if [ -f "./$item" ]
	then
		ficheros=$((ficheros+1))
	elif [ -d "./$item" ]
    then
	    directorios=$((directorios+1))
    fi
    done
    echo "El numero de ficheros y directorios en $directorio es de $ficheros y $directorios, respectivamente"
else
    echo "$directorio no es un directorio"
fi