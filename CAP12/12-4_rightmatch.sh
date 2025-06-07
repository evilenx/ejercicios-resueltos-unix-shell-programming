#!/bin/bash

# Write a function called rightmatch that takes two arguments as shown:
#
#     rightmatch value pattern 
#
# where value is a sequence of one or more characters, and pattern is a shell
# pattern that is to be removed from the right side of value. The shortest
# matching pattern should be removed from value and the result written to
# standard output. Here is some sample output:
#
#     $ rightmatch test.c .c
#     test
#     $ rightmatch /usr/spool/uucppublic '/*'
#     /usr/spool
#     $ rightmatch /usr/spool/uucppublic o
#     /usr/spool/uucppublic
#
# The last example shows that the rightmatch function should simply echo its
# first argument if it does not end with the specified pattern.
# aplicando el porcentaje 


#if [ $# -ne 2 ]
#then
#    echo "Uso: insertar 2 argumentos"
#    exit 1
#fi


if [ $# -lt 2 ] || [ $# -gt 3 ]
then
    echo "Uso: insertar 2 argumentos [--calc]"
    exit 1
fi

archivo="$1"
patron="$2"
solo_calc="$3"


# Realiza la operación de pattern matching por la derecha
#resultado=${archivo%$patron} # original
resultado=${archivo%"$patron"}

# Verificar si el patrón coincidió (si resultado es igual al archivo original, no hubo coincidencia)
#if [ "$resultado" = "$archivo" ]
#then
#    echo "El patrón '$patron' no coincide con '$archivo'"
#    exit 3
#fi

# Verificar si el patrón coincidió (si resultado es igual al archivo original, no hubo coincidencia)
if [ "$resultado" = "$archivo" ]
then
    if [ "$solo_calc" != "--calc" ]; then
        echo "El patrón '$patron' no coincide con el final de '$archivo'"
    fi
    exit 3
fi



# Si es solo cálculo, solo mostrar resultado
if [ "$solo_calc" = "--calc" ]
then
    echo "$resultado"
    exit 0
fi

# Comportamiento original con archivos
if [ ! -e "$archivo" ]
then
    echo "El archivo '$archivo' no existe."
    exit 2
fi

# Realiza la operación de pattern matching por la derecha
#resultado=${1%$2}

echo $resultado 


if [ -f "$resultado" ]
then
    echo "$resultado (archivo existe)"
elif [ -d "$resultado" ]
then
    echo "$resultado (directorio existe)"
elif [ -e "$resultado" ]
then
    echo "$resultado (existe en el directorio actual)"
else
    echo "$resultado (no existe en el directorio actual)"
    mv "$archivo" "$resultado"
    echo "Archivo renombrado de '$1' a '$resultado'"
fi
