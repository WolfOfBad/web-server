#!bin/bash

LOG_SOURCE="/var/log/nginx/all.log"

LOG_DIR="/var/log/nginx/custom"
LOG_FILE_1="$LOG_DIR/custom-all.log"
LOG_FILE_2="$LOG_DIR/cleanup.log"
LOG_FILE_3="$LOG_DIR/5xx.log"
LOG_FILE_4="$LOG_DIR/4xx.log"

MAX_SIZE=300000

cleanup_file1() {
	local record_count=$(wc -l < "$LOG_FILE_1")
	echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleared $LOG_FILE_1, removed $record_count records" >> "$LOG_FILE2"
	> "$LOG_FILE_1"
}

write_log() {
	while read -r line
	do
		local status=$(echo "$line" | awk '{print $8}')

		parsed=$(echo "$line" | sed -E -e 's/\"([^\"]*)\"\s*\"([^\"]*)\"\s*\"([^\"]*)\"\s*\"([^\"]*)\"\s*\"([^\"]*)\"\s*\"([^\"]*)\"\s*\"([^\"]*)\"\s*\"([^\"]*)\"\s*\"([^\"]*)\"/IP Address: \1 | User: \2 | Time: \3 | Request: \4 | Status: \5 | Bytes Sent: \6 | Referer: \7 | User-Agent: \8 | X-Forwarded-For: \9 |/' -e 's/"([^"]*)"\s*"([^"]*)"\s*"([^"]*)"\s*"([^"]*)"\s*"([^"]*)"\s*"([^"]*)"\s*"([^"]*)"\s*"([^"]*)"\s*"([^"]*)"/Request Time: \1 | Upstream Response Time: \2 | Pipe: \3 | Host: \4 | Server Name: \5 | Request Method: \6 | URI: \7 | Arguments: \8 | Cookies: \9 |/' -e 's/"([^"]*)"\s*"([^"]*)"\s*"([^"]*)"\s*"([^"]*)"\s*"([^"]*)"/Accept: \1 | Accept Encoding: \2 | Accept Language: \3 | Sent Content Type: \4 | Sent Cache Control: \5/')

		echo "$parsed" >> "$LOG_FILE_1"

		if [[ $status =~ 4[0-9]{2} ]]
		then
			echo "$parsed" >> "$LOG_FILE_4"
		elif [[ $status =~ 5[0-9]{2} ]]
		then
			echo "$parsed" >> "$LOG_FILE_3"
		fi
	done <<< "$1"
}

while true
do

	if [ -f "$LOG_FILE_1" ] && [ $(stat -c%s "$LOG_FILE_1") -gt $MAX_SIZE ]
	then
		cleanup_file
	fi

	new_logs=$(timeout 5 tail -n0 -F "$LOG_SOURCE")

	if [ ! -z "$new_logs" ]
	then
		write_log "$new_logs"
	fi

done
