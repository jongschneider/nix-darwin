#!/bin/bash
if [ -f /tmp/sox_keepalive.pid ]; then
    # Stop if running
    kill $(cat /tmp/sox_keepalive.pid) 2>/dev/null
    rm /tmp/sox_keepalive.pid
    echo "Microphone keepalive stopped"
else
    # Start if not running - just sample the mic briefly every few seconds
    (while true; do 
        rec -t coreaudio "AirPods Pro" -n trim 0 0.01 > /dev/null 2>&1
        sleep 3
    done) &
    echo $! > /tmp/sox_keepalive.pid
    echo "Microphone keepalive started"
fi

