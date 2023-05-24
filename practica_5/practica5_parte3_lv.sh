#!/bin/bash
#143045, Gonzalez Almela, Antonio, T, 2, A
#779035, Bernad Ferrando, Lizer, T, 2, A
# Extracción de los parámetros recibidos separdos por "[,.;: ]"
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

numParam=$(echo "$parametros" | gawk '{print NF}')

echo "Lista de parámetros: $parametros"
echo "Número de parámetros: $numParam"

if [ $numParam -ne 5 ]
then
    echo "Se esperan 5 parámetros en cada ejecución de este script:"
    echo "nombreGrupoVolumen,nombreVolumenLogico,tamaño,tipoSistemaFicheros,directorioMontaje"
    exit 1
fi
vg_name=$(echo "$parametros" | gawk '{print $1}')
lv_name=$(echo "$parametros" | gawk '{print $2}')
size=$(echo "$parametros" | gawk '{print $3}')
fs_type=$(echo "$parametros" | gawk '{print $4}')
mount_point=$(echo "$parametros" | gawk '{print $5}')

lvExists=""
lvExists=$(sudo lvs | grep "$lv_name")
newLvRoute=$(echo "/dev/$vg_name/$lv_name")
if [ -z "$lvExists" ]
then
    # No existe el volumen lógico
    sudo lvcreate -L "$size" -n "$lv_name" "$vg_name"
    if [ $?0 -ne 0 ]
    then
        echo "Ha habido un error al crear el volumen lógico $lv_name"
        exit 1
    fi
    echo "Creado volumen lógico $lv_name en el grupo volumen $vg_name"
    echo "Voy a formatear: $newLvRoute"
    sudo mkfs -t "$fs_type" "$newLvRoute"
    if [ $? -ne 0 ]
    then
        echo "Ha habido un error al formatear $newLvRoute"
        exit 1
    fi
    echo "Formateado $newLvRoute"
    echo "Voy a montar $mount_point en $newLvRoute"
    sudo mount -t "$fs_type" "$newLvRoute" "$mount_point"
    if [ $? -ne 0 ]
    then
        echo "Ha habido un error al montar $newLvRoute en $mount_point"
        exit 1
    fi
    echo "Montado $newLvRoute en $mount_point"
    # falta escribir en /etc/fstab
    UUID=$(sudo blkid | grep "/dev/mapper/$vg_name-$lv_name" | gawk '{uuid=substr($2,7,36); print uuid}')
    echo "UUID encontrado $UUID"
    # sudo echo "UUID=$UUID $mount_point   $fs_type errors=remount-ro 0       2" >> /etc/fstab
    echo "Lo que iría a /etc/fstab"
    sudo echo "UUID=$UUID $mount_point   $fs_type errors=remount-ro 0       2"
else
    # Ya existe este volumen lógico, se va a extender
    sudo lvextend -L+"$size" "$newLvRoute"
fi

