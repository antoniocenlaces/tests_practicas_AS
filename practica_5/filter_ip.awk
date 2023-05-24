BEGIN {
print "Inicia lectura del fichero con Ip's"
}
# .[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}

# if ($0 ~ /123/) {print $0;} else {print $0, "No cumple las normas de IP";}
/^[0-9][0-9]{0,2}$/ {print $0}

