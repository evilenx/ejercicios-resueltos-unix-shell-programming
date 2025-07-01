
# Modify the waitfor program to also print the tty number that the user logs on
# to. That is, the output should say
#
#     sandy logged onto tty13
#
# if sandy logs on to tty13.

# The waitfor program on page 182-183


mailopt=false
interval=60

# Procesar las opciones de línea de comandos
while [[ $# -gt 0 ]]; do
    case "$1" in
        -m)
            mailopt=true
            shift
            ;;
        -t)
            if [[ -n "$2" && "$2" =~ ^[0-9]+$ ]]; then
                interval=$2
                shift 2
            else
                echo "Error: -t requiere un número como argumento"
                exit 1
            fi
            ;;
        -*)
            echo "Uso: waitfor [-m] [-t n] user"
            echo " -m para ser notificado por correo"
            echo " -t para verificar cada n segundos"
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

# Verificar que se especificó el nombre del usuario
if [[ $# -lt 1 ]]; then
    echo "Falta el nombre de usuario"
    exit 2
fi

user="$1"

# Esperar hasta que el usuario inicie sesión
until who | awk '{print $1}' | grep -qx "$user"; do
    sleep "$interval"
done

# Usuario ha iniciado sesión, obtener su TTY
tty=$(who | awk -v usr="$user" '$1 == usr { print $2; exit }')

# Notificar según corresponda
if [[ "$mailopt" = false ]]; then
    echo "$user logged onto $tty"
else
    runner=$(whoami)
    echo "$user logged onto $tty" | mail "$runner"
fi


