#!/bin/bash
#779035, Bernad Ferrando, Lizer, T, 2, A
#143045, Gonzalez Almela, Antonio, T, 2, A
directorios=$(ls $HOME | grep -E 'bin+\w+\w+\w')
momentoApertura=0
if [ -z "$directorios" ]
then
	directorio=$(mktemp -d $HOME/binXXX)
	echo "Se ha creado el directorio $directorio"
else
	echo "$directorios" > practica2_6.tmp
	while read candidato
	do
		if [ $(stat -c %Y "$HOME/$candidato") -gt "$momentoApertura" ]
		then
			momentoApertura=$(stat -c %Y "$HOME/$candidato")
			directorio="$candidato"
		fi
	done < practica2_6.tmp
	directorio="$HOME/$directorio"
fi
echo "Directorio destino de copia: $directorio"
ls | find -maxdepth 1 -type f -executable > practica2_6_2.tmp
copias=0
while read linea
do
	cp "$linea" $directorio
	echo "$linea ha sido copiado a $directorio"
	copias=$(( copias+1 ))
done < practica2_6_2.tmp
if [ "$copias" -eq 0 ]
then
	echo "No se ha copiado ningun archivo"
else
	echo "Se han copiado $copias archivos"
fi
rm *.tmp