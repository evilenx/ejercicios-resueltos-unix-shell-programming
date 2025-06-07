 #!/bin/bash
 # write a function called substring that uses the leftmatch and rightmatch
 # functions developed in Exercises 4 and 5 to remove a pattern from the left and
 # right side of a value. It should take three arguments as shown:
 #
 #     $ substring /usr/ /usr/spool/uucppublic /uucppublic
 #     spool
 #     $ substring s. s.main.c .c
 #     main
 #     $ substring s. s.main.c .o
 #     main.c
 #     $ substring x. s.main.c .o
 #     s.main.c

# Check that exactly 3 arguments were provided
if [ $# -ne 3 ]
then
    echo "Uso: substring patron_izq valor patron_der"
    echo "Ejemplo: substring s. s.main.c .c"
    exit 1
fi

# Associate names with positional params for clarity
lpattern="$1"  # Patrón a remover de la izquierda
value="$2"     # Valor original
rpattern="$3"  # Patrón a remover de la derecha

# Store original value for comparison
original_value="$value"
temp_value="$value"
patterns_matched=0

echo "Procesando: '$value'"
echo "Patrón izquierdo: '$lpattern'"
echo "Patrón derecho: '$rpattern'"

# First, try to remove the left pattern using leftmatch with --calc option
echo "Intentando remover patrón izquierdo..."
left_removed=$(./12-5_leftmatch.sh "$lpattern" "$temp_value" --calc 2>/dev/null)
left_exit_code=$?

# Check if left pattern was actually removed
if [ $left_exit_code -eq 0 ] && [ "$left_removed" != "$temp_value" ]; then
    echo "✓ Patrón izquierdo '$lpattern' removido exitosamente"
    temp_value="$left_removed"
    patterns_matched=$((patterns_matched + 1))
else
    echo "✗ Patrón izquierdo '$lpattern' no coincide al inicio de '$temp_value'"
fi

# Now try to remove the right pattern from temp_value using rightmatch with --calc option
echo "Intentando remover patrón derecho..."
final_result=$(./12-4_rightmatch.sh "$temp_value" "$rpattern" --calc 2>/dev/null)
right_exit_code=$?

# Check if right pattern was actually removed
if [ $right_exit_code -eq 0 ] && [ "$final_result" != "$temp_value" ]; then
    echo "✓ Patrón derecho '$rpattern' removido exitosamente"
    temp_value="$final_result"
    patterns_matched=$((patterns_matched + 1))
else
    echo "✗ Patrón derecho '$rpattern' no coincide al final de '$temp_value'"
    final_result="$temp_value"
fi

# Show summary
echo ""
echo "=== RESULTADO ==="
if [ $patterns_matched -eq 0 ]; then
    echo "Ningún patrón coincidió. Resultado: '$final_result'"
elif [ $patterns_matched -eq 1 ]; then
    echo "Un patrón coincidió. Resultado: '$final_result'"
else
    echo "Ambos patrones coincidieron. Resultado: '$final_result'"
fi

# Always output the final result
echo "$final_result"

# If working with actual files, perform the renaming operation
# First check if the exact file exists
if [ -f "$original_value" ]; then
    source_file="$original_value"
else
    # Look for files that match the pattern (for cases like s.main.c vs s.mainc.c)
    source_file=""
    for file in *; do
        if [ -f "$file" ]; then
            # Try to apply the same pattern matching to see if this could be the intended file
            temp_check="$file"
            left_check=$(./12-5_leftmatch.sh "$lpattern" "$temp_check" --calc 2>/dev/null)
            if [ $? -eq 0 ]; then
                right_check=$(./12-4_rightmatch.sh "$left_check" "$rpattern" --calc 2>/dev/null)
                if [ $? -eq 0 ] && [ "$right_check" = "$final_result" ]; then
                    source_file="$file"
                    echo "Archivo encontrado: '$file' (produce el mismo resultado '$final_result')"
                    break
                fi
            fi
        fi
    done
fi

if [ -f "$source_file" ]; then
    if [ "$final_result" != "$source_file" ] && [ "$final_result" != "" ] && [ $patterns_matched -gt 0 ]; then
        if [ ! -e "$final_result" ]; then
            echo ""
            echo "Renombrando archivo..."
            mv "$source_file" "$final_result"
            if [ $? -eq 0 ]; then
                echo "✓ Archivo renombrado exitosamente de '$source_file' a '$final_result'"
            else
                echo "✗ Error al renombrar el archivo"
            fi
        else
            echo "✗ No se puede renombrar: '$final_result' ya existe"
        fi
    else
        if [ $patterns_matched -eq 0 ]; then
            echo "No se renombra: ningún patrón coincidió"
        else
            echo "No se requiere renombrar: el nombre no cambió"
        fi
    fi
elif [ -e "$original_value" ]; then
    echo "El elemento '$original_value' existe pero no es un archivo regular"
else
    echo "✗ No se encontró un archivo que coincida"
    echo "Archivos disponibles:"
    ls -la *.c 2>/dev/null || echo "No hay archivos .c en el directorio"
fi

