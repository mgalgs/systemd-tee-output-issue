#!/bin/bash

LOGFILE=/tmp/testtee.log
echo > "$LOGFILE"
echo "i like pie" | tee -a "$LOGFILE"

i=2
while :; do
    echo "i shall eat $i slices of pizza" | tee -a "$LOGFILE"
    echo "i shall eat $i slices of pie"
    ((i++))
    sleep 1
done
