#!/bin/bash

# Function to display the help section
show_help() {
    echo "Usage: stopwatch.sh [--start hh:mm:ss] [--help]"
    echo ""
    echo "Options:"
    echo "  --start hh:mm:ss    Start the timer from a specified time (format: hh:mm:ss)"
    echo "  --help              Display this help message and exit"
    exit 0
}

# Initialize the start time variables (default is 00:00:00)
start_hours=0
start_minutes=0
start_seconds=0

# Parse optional arguments
while [[ "$#" -gt 0 ]]; do  # While there are arguments passed to the script
    case $1 in
        --start)  # If the argument is --start, handle the start time
            start_time_str=$2
            IFS=':' read -r start_hours start_minutes start_seconds <<< "$start_time_str"
            shift 2
            ;;
        --help)  # If the argument is --help, display the help section
            show_help
            ;;
        *)
            echo "Unknown parameter passed: $1"
            exit 1
            ;;
    esac
done

# Convert the start time (in HH:MM:SS) to total milliseconds
start_time_in_seconds=$(( (start_hours * 3600) + (start_minutes * 60) + start_seconds ))
start_time_in_millis=$((start_time_in_seconds * 1000))

# Get the current time in milliseconds
current_time=$(date +%s%3N)

# Calculate the "fake" start time as if we started at --start
fake_start_time=$((current_time - start_time_in_millis))

# Colors for the terminal output
RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"
YELLOW="\033[33m"
RESET="\033[0m"

# Infinite loop for the stopwatch
while true; do
    # Get the current time in milliseconds
    current_time=$(date +%s%3N)
    
    # Calculate the elapsed time from the fake start
    elapsed_time=$((current_time - fake_start_time))
    
    # Convert elapsed milliseconds to hours, minutes, seconds, and milliseconds
    hours=$((elapsed_time / 3600000))
    minutes=$(((elapsed_time % 3600000) / 60000))
    seconds=$(((elapsed_time % 60000) / 1000))
    millis=$((elapsed_time % 1000))
    
    # Clear the previous line and print in a colored format (HH:MM:SS:MS)
    printf "\r${BLUE}%02d${RESET}:${GREEN}%02d${RESET}:${YELLOW}%02d${RESET}:${RED}%03d${RESET}" $hours $minutes $seconds $millis

    # Update the timer every 10ms
    sleep 0.01
done

