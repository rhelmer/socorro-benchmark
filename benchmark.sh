#!/bin/bash -e

if [ $# -ne 1 ]; then
    echo "Syntax: benchmark.sh <url>"
    exit 1
fi

URL=$1

ab -c 100 -n 1000000 -T 'multipart/form-data; boundary=socorro1234567' \
    -p form-post.txt -e apache_bench_percent.csv -g apache_bench.tsv $URL \
    > apache_bench.log 2>&1
