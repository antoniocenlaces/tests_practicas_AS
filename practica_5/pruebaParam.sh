#!/bin/bash
echo "Parámetros recibidos $@"
for i in "$@"
do 
    echo "Parámetro: $i"
done
parametros=$(echo "$@" | gawk 'BEGIN {FS="[,.;: ]";}
    {
        parametros=""
        for (i=0; i<NF; i++){
            OFS = i==0 ? "" : " ";
            parametros = parametros OFS $(i+1);
            }
    }
    END {
        print parametros
    }')
echo "parámetros convertidos:"
echo "$parametros"