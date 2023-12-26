path=/home/lenovo/Desktop/CPU_Scheduling_with_bash-master/ready_queue.txt

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

sorted_lines=$(sort -t',' -k2 -n $path)

declare -a command_queue

while IFS="," read -r command time_arrival
do
    current_time=$(date "+%s")

    new_time_arrival=$(($current_time + $time_arrival))
    echo "Current Time: $(convert_sec_to_real_time $current_time)" 
    echo "Thời gian đến: $(convert_sec_to_real_time $new_time_arrival)" 

    command_queue+=("$command,$new_time_arrival")

    if [ -z "$running_command" ]; then
        running_command="${command_queue[0]}"
        unset 'command_queue[0]'

        IFS=',' read -r queued_command queued_arrival_time <<< "$running_command"
        
        sleep $((queued_arrival_time - current_time))

        echo "Bắt đầu lệnh: $queued_command"
        $queued_command

        time_end=$(date "+%s")
        echo "Thời điểm kết thúc: $(convert_sec_to_real_time $time_end)"
        echo "Thời gian hoàn thành của $queued_command: $(turnaround_time $time_end $queued_arrival_time)"
        echo "Thời gian chờ của $queued_command: $(waiting_time $time_end $queued_arrival_time)"
        echo "------------------------------------"

        unset running_command
    fi
done <<< "$sorted_lines"