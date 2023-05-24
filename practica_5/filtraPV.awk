BEGIN { FS=" ";extiende=0;}
{
    print "Línea:",NR,"campo1:",$1,"campo2:",$2
    if(NR==1 && $2!="VG"){
        print "No hay ningún vg definido visto en línea 1: va a crearlo"
        extiende=1;
        exit 0;
    }
    else {
        if($1==my_pv && $2=="lvm2" && NR>1){
            print "Sí hay algún vg definido pero",$1,"no está asociado"
            extiende=1;
            exit 0;
        }
    }
}
END {
if(extiende)
print $1
}