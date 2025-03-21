#!/bin/bash

# Configuration
LOG_FILE="$HOME/.internet_usage_log.json"

# Function to get current bytes received and sent for macOS
get_current_usage() {
  # Get primary active network interface (usually en0 for WiFi or en1 for Ethernet)
  # Using networksetup to get the active interface
  ACTIVE_SERVICE=$(networksetup -listnetworkserviceorder | grep -B 1 "$(route -n get default | grep interface | awk '{print $2}')" | head -n 1 | sed 's/^(.*) //')
  INTERFACE=$(networksetup -listallhardwareports | grep -A 1 "$ACTIVE_SERVICE" | grep Device | awk '{print $2}')
  
  # Use netstat with the identified interface to get bytes in and out
  NETWORK_STATS=$(netstat -I "$INTERFACE" -b)
  BYTES_IN=$(echo "$NETWORK_STATS" | tail -1 | awk '{print $7}')
  BYTES_OUT=$(echo "$NETWORK_STATS" | tail -1 | awk '{print $10}')
  
  echo "$BYTES_IN $BYTES_OUT"
}

# Create log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
  echo '{"entries":[]}' > "$LOG_FILE"
fi

# Get current timestamp
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Get current usage
read BYTES_IN BYTES_OUT <<< $(get_current_usage)

# Read previous data
PREV_BYTES_IN=0
PREV_BYTES_OUT=0
TOTAL_BYTES_IN=0
TOTAL_BYTES_OUT=0

# Parse the existing JSON file to get the latest entry
if [ -s "$LOG_FILE" ] && [ -x "$(command -v jq)" ]; then
  # Check if jq is installed
  # Extract the latest entry
  LATEST_ENTRY=$(cat "$LOG_FILE" | jq '.entries[-1]')
  
  if [ "$LATEST_ENTRY" != "null" ]; then
    PREV_BYTES_IN=$(echo "$LATEST_ENTRY" | jq '.current_received')
    PREV_BYTES_OUT=$(echo "$LATEST_ENTRY" | jq '.current_sent')
    TOTAL_BYTES_IN=$(echo "$LATEST_ENTRY" | jq '.total_received')
    TOTAL_BYTES_OUT=$(echo "$LATEST_ENTRY" | jq '.total_sent')
  fi
elif [ -s "$LOG_FILE" ]; then
  # If jq is not installed, inform the user
  echo "Error: jq is not installed. Please install it with 'brew install jq'."
  exit 1
fi

# Calculate differences
DIFF_BYTES_IN=$((BYTES_IN - PREV_BYTES_IN))
DIFF_BYTES_OUT=$((BYTES_OUT - PREV_BYTES_OUT))

# Handle system restart case (when current is less than previous)
if [ $DIFF_BYTES_IN -lt 0 ]; then
  DIFF_BYTES_IN=$BYTES_IN
fi

if [ $DIFF_BYTES_OUT -lt 0 ]; then
  DIFF_BYTES_OUT=$BYTES_OUT
fi

# Update totals
NEW_TOTAL_IN=$((TOTAL_BYTES_IN + DIFF_BYTES_IN))
NEW_TOTAL_OUT=$((TOTAL_BYTES_OUT + DIFF_BYTES_OUT))

# Create new entry
NEW_ENTRY=$(cat <<EOF
{
  "timestamp": "$TIMESTAMP",
  "current_received": $BYTES_IN,
  "current_sent": $BYTES_OUT,
  "diff_received": $DIFF_BYTES_IN,
  "diff_sent": $DIFF_BYTES_OUT,
  "total_received": $NEW_TOTAL_IN,
  "total_sent": $NEW_TOTAL_OUT
}
EOF
)

# Update the JSON file
TMP_FILE=$(mktemp)
jq ".entries += [$NEW_ENTRY]" "$LOG_FILE" > "$TMP_FILE"
mv "$TMP_FILE" "$LOG_FILE"

# Convert bytes to more readable format
format_bytes() {
  local bytes=$1
  if (( bytes < 1024 )); then
    echo "${bytes}B"
  elif (( bytes < 1048576 )); then
    echo "$(bc <<< "scale=2; $bytes/1024")KB"
  elif (( bytes < 1073741824 )); then
    echo "$(bc <<< "scale=2; $bytes/1048576")MB"
  else
    echo "$(bc <<< "scale=2; $bytes/1073741824")GB"
  fi
}

# Display usage information
echo "Internet Usage Report ($(date +"%Y-%m-%d %H:%M:%S"))"
echo "----------------------------------------------------"
# "Current session" means the total usage since last restart, as macOS clears
# internet usage after a restart, which is the reason I even made this script.
echo "Current session:"
echo "  Received: $(format_bytes $BYTES_IN)"
echo "  Sent:     $(format_bytes $BYTES_OUT)"
echo
# "Since last check" displays the usage since the last time the script was run.
echo "Since last check:"
echo "  Received: $(format_bytes $DIFF_BYTES_IN)"
echo "  Sent:     $(format_bytes $DIFF_BYTES_OUT)"
echo
# "Total usage" displays the total internet usage including previous sessions,
echo "Total usage:"
echo "  Received: $(format_bytes $NEW_TOTAL_IN)"
echo "  Sent:     $(format_bytes $NEW_TOTAL_OUT)"
echo
echo "Usage log saved to $LOG_FILE"
