#!/bin/bash
echo -n "Introduzca una tecla: "
read entrada

# Extraigo el primer caracter por la izquierda de entrada
caracter=${entrada:0:1}

ascii=$(printf %d\\n \'$caracter)
echo $ascii
if [ $ascii -ge 48 ]
then
    echo "$caracter es un numero"
# elif [ \($ascii -ge 65 && $ascii -le 90\) || \($ascii -ge 97 && $ascii -le 122\) ]
# then
#     echo "$caracter es una letra"
# else
#     echo "$caracter es un caracter especial"
fi