#!/bin/bash

echo "Stressing cpu for 2 mins"
stress 
    --cpu 2
    --timeout 120s
    --verbose