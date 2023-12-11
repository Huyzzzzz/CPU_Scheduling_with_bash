time_start=$(date +%s)
echo $time_start
for i in {1..5}
do
    sleep 1
done
time_end=$(date +%s)
total_time=$(($time_end - $time_start))
echo $time_end
echo "Total time: $total_time seconds"

convert_time()
{
    ((h=${total_time}/3600))
    ((m=(${total_time}%3600)/60))
    ((s=${total_time}%60))
    echo "$h:$m:$s"
}

convert_time
