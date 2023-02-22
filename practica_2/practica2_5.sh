#!/bin/bash
hour=$(date | cut -c12-13)
if [ "$hour" -ge 0 -a "$hour" -le 11 ]
then
 echo "Buenos días"
elif [ "$hour" -ge 12 -a "$hour" -le 17 ]
then
    echo "Buenas tardes"
else
    echo "Buenas noches"
fi