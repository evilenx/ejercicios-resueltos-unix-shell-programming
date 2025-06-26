#!/usr/bin/awk -f
# Script AWK para procesar el archivo stock.lst
# Uso: awk -f stock_processor.awk stock.lst

BEGIN {
    print "=== PROCESAMIENTO DEL ARCHIVO STOCK.LST ==="
    print ""
}

# (a) Imprimir solo el código de los productos electrónicos
{
    if (NR == 1) {
        print "(a) Códigos de productos electrónicos:"
        print "------------------------------------"
    }
}

$5 == "electronics" && !printed_a {
    codes_electronics[NR] = $1
}

# (b) Imprimir la información de los productos cuyo precio está en el rango 5000-10,000
{
    if ($3 >= 5000 && $3 <= 10000) {
        range_products[NR] = $0
    }
}

# (c) Imprimir todos los productos excepto Jeans
{
    if ($2 != "Jeans") {
        no_jeans[NR] = $0
    }
}

# (d) Imprimir el tercer registro en el archivo
{
    if (NR == 3) {
        third_record = $0
    }
}

# (e) Para imprimir el producto cuyo código es 102
{
    if ($1 == 102) {
        code_102[NR] = $0
    }
}

# (f) Para imprimir los productos cuyos nombres comienzan con cualquier carácter entre A y D
{
    if ($2 ~ /^[A-D]/) {
        names_a_to_d[NR] = $0
    }
}

# (g) Imprimir todos los productos cuyo nombre tenga más de seis caracteres
{
    if (length($2) > 6) {
        long_names[NR] = $0
    }
}

# (h) Imprimir todos los productos cuya cantidad sea inferior a 10
{
    if ($4 < 10) {
        low_quantity[NR] = $0
    }
}

# (i) Imprimir todos los productos cuyo nombre es laptop o Laptop
{
    if (tolower($2) == "laptop") {
        laptop_products[NR] = $0
    }
}

# (j) Imprimir nombre y precio de productos garments con código < 103 y precio > 800
{
    if ($5 == "garments" && $1 < 103 && $3 > 800) {
        garments_filtered[NR] = $2 " " $3
    }
}

END {
    print ""
    
    # Mostrar resultados del inciso (a)
    print "(a) Códigos de productos electrónicos:"
    print "------------------------------------"
    for (i in codes_electronics) {
        print codes_electronics[i]
    }
    print ""
    
    # Mostrar resultados del inciso (b)
    print "(b) Productos con precio entre 5000-10,000:"
    print "------------------------------------------"
    for (i in range_products) {
        print range_products[i]
    }
    print ""
    
    # Mostrar resultados del inciso (c)
    print "(c) Todos los productos excepto Jeans:"
    print "------------------------------------"
    for (i in no_jeans) {
        print no_jeans[i]
    }
    print ""
    
    # Mostrar resultados del inciso (d)
    print "(d) Tercer registro del archivo:"
    print "------------------------------"
    if (third_record != "") {
        print third_record
    }
    print ""
    
    # Mostrar resultados del inciso (e)
    print "(e) Productos con código 102:"
    print "----------------------------"
    for (i in code_102) {
        print code_102[i]
    }
    print ""
    
    # Mostrar resultados del inciso (f)
    print "(f) Productos que comienzan de A a D:"
    print "-----------------------------------"
    for (i in names_a_to_d) {
        print names_a_to_d[i]
    }
    print ""
    
    # Mostrar resultados del inciso (g)
    print "(g) Productos con nombres de más de 6 caracteres:"
    print "-----------------------------------------------"
    for (i in long_names) {
        print long_names[i]
    }
    print ""
    
    # Mostrar resultados del inciso (h)
    print "(h) Productos con cantidad menor a 10:"
    print "------------------------------------"
    for (i in low_quantity) {
        print low_quantity[i]
    }
    print ""
    
    # Mostrar resultados del inciso (i)
    print "(i) Productos cuyo nombre es 'laptop' (case-insensitive):"
    print "-------------------------------------------------------"
    for (i in laptop_products) {
        print laptop_products[i]
    }
    print ""
    
    # Mostrar resultados del inciso (j)
    print "(j) Nombre y precio de garments (código < 103, precio > 800):"
    print "-----------------------------------------------------------"
    for (i in garments_filtered) {
        print garments_filtered[i]
    }
    print ""
    
    print "=== FIN DEL PROCESAMIENTO ==="
}
