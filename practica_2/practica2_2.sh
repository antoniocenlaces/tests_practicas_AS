#!/bin/bash
# 
for file in "$@"
do
    if [ -f "$file" ]
    then
        more "$file"
    else
        echo "$file no es un fichero"
    fi
done