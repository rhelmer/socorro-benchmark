#!/usr/bin/python
#
# Quick hacky script to convert collector/processor benchmark
# CSVs into something easier to work with in a spreadsheet.
#
# Most important is to convert microsconds into milliseconds
# as an int.
#

import csv
import dateutil.parser

from optparse import OptionParser

def convert_processor():
    with open('processor_benchmark.csv') as f:
        reader = csv.reader(f, delimiter=',')
        for row in reader:
            date = row[0]
            funcname = row[1]
            ms = float(dateutil.parser.parse(row[2]).strftime('%f')) / 1000
            print '%s, %s, %s' % (date,funcname,ms)

def convert_collector():
    with open('collector_benchmark.csv') as f:
        reader = csv.reader(f, delimiter=',')
        for row in reader:
            date = row[0]
            ms = float(dateutil.parser.parse(row[1]).strftime('%f')) / 1000
            print '%s, %s' % (date,ms)

if __name__ == '__main__':
    parser = OptionParser()
    parser.add_option('-c', '--collector', action="store_true", dest='collector')
    parser.add_option('-p', '--processor', action="store_true", dest='processor')
    (options, args) = parser.parse_args()
    print options, args
    if options.collector:
        convert_collector()
    if options.processor:
        convert_processor()
