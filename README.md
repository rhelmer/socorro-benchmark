Intro
-----
This is a small repo to hold tools related to benchmarking Socorro.

Right now it uses the Apache Benchmark (ab), dstat, and
Socorro's built-in BenchmarkCrashStorage wrapper.

Set up test file
----------------

```
base64 crash.dump > dump.txt
vi form-post.txt # build multi-part form HTTP post
unix2dos form-post.txt # must have \r\n line endings
```

Benchmarking
------------
Run on dedicated node in remote cluster:

```
./benchmark.sh http://crash-reports.example.com/submit
```

If you want to collect data on overall system performance,
make sure ```dstat``` is installed and run on each machine:

```
dstat -t -c -n -N eth0,lo -m -s -d --output dstat.csv
```

Collect data
------------
Collect data from all nodes in remote cluster:

```
./collect.sh host1 host2 host3 [host...]
```

./output/$DATE/$HOST/ will contain CSV, TSV and collected raw data from:

* Apache
* Socorro
* dstat

