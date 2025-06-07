if [ $# -ne 1 ]; then
    echo 'error: must have exactly 1 argument' >&2
    exit 1
fi

user_info=$(who | grep -w "$1")
if [ -z "$user_info" ]; then
    echo 'error: argument had no matches' >&2
    exit 1
elif [ $(echo "$user_info" | wc -l) -ge 2 ]; then
    echo 'error: argument matches more than 1 name' >&2
    exit 1
fi

log_time=$(echo "$user_info" | awk '{print $4}')
log_hr=${log_time%%:*}  
log_min=${log_time##*:} 

log_hr=$((10#$log_hr))
log_min=$((10#$log_min))

curr_time=$(date +%H:%M)
curr_hr=${curr_time%%:*}
curr_min=${curr_time##*:}

diff_hr=$((curr_hr - log_hr))
diff_min=$((curr_min - log_min))

if [ $diff_min -lt 0 ]; then
    diff_hr=$((diff_hr - 1))
    diff_min=$((diff_min + 60))
fi

if [ $diff_hr -lt 0 ]; then
    diff_hr=$((diff_hr + 24))
fi

printf "The amount of time since login is: %d hours and %d minutes\n" \
    $diff_hr \
    $diff_min
