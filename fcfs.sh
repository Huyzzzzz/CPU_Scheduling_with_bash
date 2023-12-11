path=/home/huy/user/CPU_Scheduling_With_Bash/ready_queue.txt
# Read file line by line

waiting_time() {
    time_start=$1
    time_arrival=$2
    ((waiting_time=time_start - time_arrival))
    convert_sec_to_amount_of_time $waiting_time
}

turnaround_time() {
    time_end=$1
    time_arrival=$2
    ((turnaround_time=time_end - time_arrival))
    convert_sec_to_amount_of_time $turnaround_time
}

convert_sec_to_amount_of_time()
{
    ((h=$1/3600))
    ((m=($1%3600)/60))
    ((s=$1%60))
    if [ $h -lt 10 ]; then
        h="0$h"
    fi
    if [ $m -lt 10 ]; then
        m="0$m"
    fi
    if [ $s -lt 10 ]; then
        s="0$s"
    fi
    echo "$h:$m:$s"
}


convert_sec_to_real_time()
{
    seconds_since_start_of_day=$(($1 - $(date -d "$(date -d @$1 +"%Y%m%d 00:00:00")" +%s)))
    ((h=seconds_since_start_of_day/3600))
    ((m=(seconds_since_start_of_day%3600)/60))
    ((s=seconds_since_start_of_day%60))
    if [ $h -lt 10 ]; then
        h="0$h"
    fi
    if [ $m -lt 10 ]; then
        m="0$m"
    fi
    if [ $s -lt 10 ]; then
        s="0$s"
    fi
    echo "$h:$m:$s"
}

while IFS="," read -r command time_arrival
    do
        # Do thời gian để  ở dạng giây tính theo thời gian thực nên cần 1 bước chuyển đổi về giờ
        echo "Arrival time: $(convert_sec_to_real_time $time_arrival)" 
        time_start=$(date "+%s")
        echo "Time start: $(convert_sec_to_real_time $time_start)"
        echo "Waiting time of "$command": $(waiting_time $time_start $time_arrival)"
        echo "Start command: $command"
        # Thực hiện lệnh
        $command

        # Hiển thị ra thời gian kết thúc
        time_end=$(date "+%s")
        echo "Time end: $(convert_sec_to_real_time $time_end)"
        echo "Turn around time of "$command": $(turnaround_time $time_end $time_arrival)"
        echo "------------------------------------"
    done < $path