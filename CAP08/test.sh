time=$(date | cut -c12-16)
hour=$(echo $time | cut -c1-2)
min=$(echo $time | cut -c4-5)

# Eliminar ceros a la izquierda
hour=$((10#$hour))

if [ $hour -eq 0 ]; then
    echo "12:$min am"
    elif [ $hour -le 11 ]; then
        echo "$hour:$min am"
        elif [ $hour -eq 12 ]; then
            echo "12:$min pm"
            else
                echo "$((hour - 12)):$min pm"
                fi
