#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Syntax: collect.sh host1 host2 host3 [host...]"
    exit 1
fi

DATE=$(date +%Y%m%d%H%M%S)
OUTPUT_DIR="./output/${DATE}"

for host in $*; do
    echo "Attempting to collect raw data from ${host}..."
    output_dir=$OUTPUT_DIR/$host
    mkdir -p $output_dir
    ssh root@$host "cat /proc/cpuinfo" > $output_dir/cpuinfo.txt \
        2> $output_dir/ssh.log
    ssh root@$host "cat /proc/meminfo" > $output_dir/meminfo.txt \
        2>> $output_dir/ssh.log
    ssh root@$host "cat /proc/diskstats" > $output_dir/diskstats.txt \
        2>> $output_dir/ssh.log
    ssh root@$host "cat /etc/system-release" > $output_dir/system-release.txt \
        2>> $output_dir/ssh.log
    scp -C root@$host:apache_bench_percent.csv \
        $output_dir/apache_bench_percent.csv \
        > $output_dir/scp.log 2>&1
    scp -C root@$host:apache_bench.tsv $output_dir/apache_bench.tsv \
        >> $output_dir/scp.log 2>&1
    scp -C root@$host:apache_bench.log $output_dir/apache_bench.log \
        >> $output_dir/scp.log 2>&1
    scp -C root@$host:dstat.csv $output_dir/dstat.csv \
        >> $output_dir/scp.log 2>&1
    scp -C root@$host:/var/log/httpd/error_log \
        $output_dir/socorro-collector.log \
        >> $output_dir/scp.log 2>&1
    scp -C root@$host:/var/log/socorro/socorro-processor.log \
        $output_dir/socorro-processor.log \
        >> $output_dir/scp.log 2>&1

    echo "Post-processing Socorro benchmark data for ${host}..."
    grep ' Benchmark ' $output_dir/socorro-collector.log \
        2> $output_dir/collector_benchmark.log \
        | awk '{print $1,$2,$3,$4,$5", "$NF}' \
        | tr -d '[]' \
        1> $output_dir/collector_benchmark.csv

    grep ' Benchmark ' $output_dir/socorro-processor.log \
        2> $output_dir/collector_benchmark.log \
        | awk '{print $1,$2", "$(NF-1)", "$NF}' \
        1> $output_dir/processor_benchmark.csv
done
