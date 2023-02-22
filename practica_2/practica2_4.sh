#!/bin/bash
echo -n "Introduzca una tecla: "
read entrada

# Extraigo el primer caracter por la izquierda de entrada
caracter=${entrada:0:1}
# Convierto caracter en su valor decimal en ascii
ascii=$(printf %u \'$caracter)

if [ $ascii -ge 48 -a $ascii -le 57 ]
then
    echo "$caracter es un numero"
elif [ \( $ascii -ge 65 -a $ascii -le 90 \) -o \( $ascii -ge 97 -a $ascii -le 122 \) ]
then
    echo "$caracter es una letra"
else
    echo "$caracter es un caracter especial"
fi