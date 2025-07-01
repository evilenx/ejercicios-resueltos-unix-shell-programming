# Add a -f option to waitfor to have it periodically check for the existence of
# a file (ordinary file or directory) instead of for a user logging on. So
# typing
#
#     example :
#     mon -f /usr/spool/uucppublic/steve/newmemo &
#
# should cause mon to periodically check for the existence of the indicated file
# and inform you when it does (by displaying a message or by mail if the -m
# option is also selected).



check_file=false
use_mail=false
interval=60
filename=""
user=""

while getopts "mt:f:" option; do
    case "$option" in
        f)
            check_file=true
            filename="$OPTARG"
            ;;
        m)
            use_mail=true
            ;;
        t)
            interval="$OPTARG"
            ;;
        \?)
            echo "Usage: waitfor [-m] [-f filename] [-t n] [user]"
            echo "  -m   notify by email"
            echo "  -f   check for file instead of user"
            echo "  -t   check every n seconds"
            exit 1
            ;;
    esac
done

if ! $check_file; then
    shift $((OPTIND - 1))
    if [ -z "$1" ]; then
        echo "Missing user name!"
        exit 2
    fi
    user="$1"
fi

if $check_file; then
    while [ ! -e "$filename" ]; do
        sleep "$interval"
    done
    message="File '$filename' exists"
else
    while ! who | awk '{print $1}' | grep -qx "$user"; do
        sleep "$interval"
    done
    tty=$(who | awk -v usr="$user" '$1 == usr { print $2; exit }')
    message="$user logged onto $tty"
fi

if $use_mail; then
    recipient=$(whoami)
    echo "$message" | mail "$recipient"
else
    echo "$message"
fi

