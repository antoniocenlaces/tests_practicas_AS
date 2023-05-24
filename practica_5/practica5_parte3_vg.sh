#!/bin/bash
#143045, Gonzalez Almela, Antonio, T, 2, A
#779035, Bernad Ferrando, Lizer, T, 2, A
# Función que comprueba si un PV ya está incluido en algún VG
# Recibe dos parámetros, primero el nombre del VG y después el nombre del PV
# Si encuentra ese PV asociado a algún VG no devuelve nada
# Caso que no haya asocición devuelve el nombre del PV
function filtraPV() {
	  sudo pvs -o#pv_name | 
		gawk -v my_pv="$2" -v my_vg="$1" 'BEGIN { FS=" ";extiende=0;}
		      {
			if(NR==1 && $2!="VG"){ 
				extiende=1;
				exit 0;
			}
			else {
				if($1==my_pv && $2=="lvm2" && NR>1){
					extiende=1;
					exit 0;
				}
			}
		      }
		      END {
			if(extiende)
				print $1
		      }'
}
# Función filtraVG recibe un nombre de VG
# Devuelve vacío si ese VG no está creado
# Devuelve el nombre del VG si ya está creado
function filtraVG() {
	sudo vgs | gawk -v my_vg="$1" '{if($1==my_vg) print $1}'
}
if [ $# -lt 2 ]
then
	echo "Número de parámetros incorrecto."
	echo "Mínimo dos parámetros: <vg_name> <pv1>"
	exit 1
fi

# Comprobación si el vg indicado ya existe
vg_info=$(filtraVG "$1")

if [ -z $vg_info ] # El VG $vg_info no existe
then
# Para todos los PVs que han pasado como argumentos
	vg_info="$1"
	shift
	# Ahora $1 es el nombre  del primer PV y el vg_name está almacenado en $vg_info
	echo "VG: $vg_info no exite y va a ser creado"
	creaVG=0
	# Bucle de iteración para todos los PVs recibidos como parámetro
	for thisPV in "$@"
	do
		# Comprueba si el PV que estamos analizando ya está asociado con otro VG
		pv_info=$(filtraPV "$vg_info" "$thisPV")
		if [ -z $pv_info ]
		then
			echo "El volumen físico: $thisPV ya está asociado con otro grupo volumen"
			echo "Continúo con el siguiente PV"
		else
			if [ $creaVG -eq 0 ]
			then
				sudo vgcreate  "$vg_info" "$thisPV"
				creaVG=1
			else
				sudo vgextend "$vg_info" "$thisPV"
			fi
		fi
	done
else
	echo "VG: $1 ya existe y por tanto solo puede ser ampliado"
	shift
	# Ahora $1 es el nombre  del primer PV y el vg_name está almacenado en $vg_info
	# Bucle para todos los PVs recibidos como parámetros
	echo "Los parametros después del shift: $@"
	for thisPV in "$@"
	do
		# comprobación si el physical volume indicado ya está en algún otro VG
		pv_info=""
		pv_info=$(filtraPV "$vg_info" "$thisPV")
		if [ -z $pv_info ] 
		then
			echo "El volumen físico: $thisPV ya forma parte de otro grupo volumen"
		else
			sudo vgextend "$vg_info" "$thisPV"
		fi
	done
fi
