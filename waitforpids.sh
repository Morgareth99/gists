#! /bin/bash

echo "--- Execution started at: $(date)"

items="1 2 3 4 5 6"
pids=""

for item in $items; do
    echo "Starting item: $item"
    sleep $item &
    pids+="$! "
done

for pid in $pids; do
    wait $pid
    if [ $? -eq 0 ]; then
        echo "SUCCESS - PID $pid exited with a status of $?"
    else
        echo "FAILED - PID $pid exited with a status of $?"
    fi
done

echo "--- Execution finished at: ($(date))"

