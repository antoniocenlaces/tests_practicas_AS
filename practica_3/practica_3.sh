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
        case $1 in
            -a)
                echo "Opción -a leida";;
            -s)
                echo "Opción -s leida";;
            *)
                echo "Opción no válida";;
        esac
    fi
fi
