path="./processes.txt"
output_file="./ready_queue.txt"

convert_sec_to_real_time() {
    seconds_since_start_of_day=$(($1 - $(date -d "$(date -d @$1 +"%Y%m%d 00:00:00")" +%s)))
    ((h=seconds_since_start_of_day/3600))
    ((m=(seconds_since_start_of_day%3600)/60))
    ((s=seconds_since_start_of_day%60))
    printf "%02d:%02d:%02d\n" $h $m $s
}

sorted_lines=$(sort -t',' -k2 -n "$path")
root_time=$(date "+%s")

current_time=$(date "+%s")
echo "Thời gian bắt đầu chương trình: $(convert_sec_to_real_time $current_time)"

while IFS="," read -r command second_time_arrival
do
    real_time_arrival=$(($root_time + $second_time_arrival))

    if [ "$current_time" -lt "$real_time_arrival" ]; then
        printf "%s,%s\n" "$command" "$real_time_arrival" >> "$output_file"
        echo "Đã ghi "$command" vào file "$output_file" tại thời điểm "$(convert_sec_to_real_time $real_time_arrival)""
    fi
done <<< "$sorted_lines"
