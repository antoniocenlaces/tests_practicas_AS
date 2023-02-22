#!/bin/bash
# Pide un nombre de fichero y si es válido y existe
# muestra los permisos de usuario   
# stat -c "%A" ${file} | cut -c1-3
    # Es legible el fichero
        # permisos=$((permisos+"r"))
echo -n "Introduzca el nombre del fichero: "
read file
if [ -f "$file" ]
then
    echo -n "Los permisos del archivo $file son: "
    # stat -c "%A" ${file} | cut -c1-3
    if [ -r "$file" ]
    then
 
        echo -n "r"
        if [ -w "$file" ]
        then
            echo -n "w"
            if [ -x "$file" ]
            then
                echo "x"
            else
                echo "-"
            fi
        else
            echo -n "-"
            if [ -x "$file" ]
            then
                echo "x"
            else
                echo "-"
            fi
        fi
    else
    echo -n "-"
    if [ -w "$file" ]
        then
            echo -n "w"
            if [ -x "$file" ]
            then
                echo "x"
            else
                echo "-"
            fi
        else
            echo -n "-"
            if [ -x "$file" ]
            then
                echo "x"
            else
                echo "-"
            fi
        fi
    fi
else
    echo "$file no existe"
fi