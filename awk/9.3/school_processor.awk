#!/usr/bin/awk -f 
# Script AWK para procesar el archivo data.lst (datos escolares)
# Estructura: Nombre Apellido Dirección Stream Materia1 Materia2
# Uso: awk -f school_processor.awk data.lst

BEGIN {
    print "=== PROCESAMIENTO DEL ARCHIVO DATA.LST (SCHOOL DATA) ==="
    print ""
    
    # Variables para el inciso (a) - rango de líneas
    # En un caso real, estos valores se podrían pasar como parámetros
    # Ejemplo: awk -v start_line=2 -v end_line=4 -f school_processor.awk data.lst
    if (start_line == "") start_line = 2  # línea de inicio por defecto
    if (end_line == "") end_line = 4      # línea final por defecto
}

# Procesar cada línea del archivo
{
    # Almacenar todos los registros para diferentes procesamientos
    all_records[NR] = $0
    
    # (a) Registros en rango especificado
    if (NR >= start_line && NR <= end_line) {
        range_records[NR] = $0
    }
    
    # (b) Registros que contienen "Vaishali Nagar"
    if ($0 ~ /Vaishali Nagar/) {
        vaishali_records[NR] = $0
    }
    
    # (c) Reemplazar "science" con "commerce"
    modified_line = $0
    gsub(/science/, "commerce", modified_line)
    replaced_records[NR] = modified_line
    
    # (d) Calcular total de las dos materias (asumiendo que son los últimos dos campos)
    if (NF >= 2) {
        subject1 = $(NF-1)  # Penúltimo campo
        subject2 = $NF      # Último campo
        total = subject1 + subject2
        records_with_total[NR] = $0 " Total:" total
    }
    
    # (e) Registros con apellido 'Sharma' (asumiendo que el apellido es el segundo campo)
    if ($2 == "Sharma") {
        sharma_records[NR] = $0
    }
}

END {
    print ""
    
    # Mostrar resultados del inciso (a)
    print "(a) Registros en el rango especificado (líneas " start_line "-" end_line "):"
    print "================================================================"
    for (i in range_records) {
        print "Línea " i ": " range_records[i]
    }
    print ""
    print "NOTA: Para cambiar el rango, use: awk -v start_line=X -v end_line=Y -f school_processor.awk data.lst"
    print ""
    
    # Mostrar resultados del inciso (b)
    print "(b) Registros que contienen 'Vaishali Nagar':"
    print "============================================"
    for (i in vaishali_records) {
        print vaishali_records[i]
    }
    print ""
    
    # Mostrar resultados del inciso (c)
    print "(c) Registros con 'science' reemplazado por 'commerce':"
    print "====================================================="
    for (i = 1; i <= NR; i++) {
        if (i in replaced_records) {
            print replaced_records[i]
        }
    }
    print ""
    
    # Mostrar resultados del inciso (d)
    print "(d) Contenido completo con total de materias:"
    print "==========================================="
    for (i = 1; i <= NR; i++) {
        if (i in records_with_total) {
            print records_with_total[i]
        }
    }
    print ""
    
    # Mostrar resultados del inciso (e)
    print "(e) Registros con apellido 'Sharma':"
    print "===================================="
    for (i in sharma_records) {
        print sharma_records[i]
    }
    print ""
    
    print "=== ESTADÍSTICAS GENERALES ==="
    print "Total de registros procesados: " NR
    print "Registros con 'Vaishali Nagar': " length(vaishali_records)
    print "Registros con apellido 'Sharma': " length(sharma_records)
    print ""
    print "=== FIN DEL PROCESAMIENTO ==="
}
