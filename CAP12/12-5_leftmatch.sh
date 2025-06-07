#!/bin/bash
# Write a function called leftmatch that works similarly to the rightmatch function developed in
# Exercise 4. Its two arguments should be as follows:
#
#     leftmatch pattern value
#
# Here are some example uses:
#
#     $ leftmatch /usr/spool/ /usr/spool/uucppublic
#     uucppublic
#     $ leftmatch s. s.main.c
#     main.c


# Check that exactly 2 arguments were provided

#if [ $# -ne 2 ]
#then
#    echo "uso: leftmatch patrón valor"
#    exit 1
#fi        

# Check that exactly 2 or 3 arguments were provided
if [ $# -lt 2 ] || [ $# -gt 3 ]
then
    echo "uso: leftmatch patrón valor [--calc]" 
    exit 1 
fi        

patron="$1"
valor="$2"
solo_calc="$3"

# Realiza la operación de pattern matching por la izquierda
#resultado=${valor#$patron} #original
resultado=${valor#"$patron"}

# Verificar si el patrón coincidió (si resultado es igual al archivo original, no hubo coincidencia)
#if [ "$resultado" = "$valor" ]
#then
#    echo "El patrón '$patron' no coincide con '$valor'"
#    exit 3
#fi


# Verificar si el patrón coincidió (si resultado es igual al valor original, no hubo coincidencia)
if [ "$resultado" = "$valor" ]
then
if [ "$solo_calc" != "--calc" ]; then
  echo "El patrón '$patron' no coincide con el inicio de '$valor'"
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
if [ ! -e "$valor" ]
then
    echo "El archivo '$valor' no existe."
    exit 2
fi




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
    mv "$valor" "$resultado"
    echo "Archivo renombrado de '$valor' a '$resultado'"
fi
