#!/usr/bin/env bash
count=1

while true; do
	$PWD/example02.sh 1>/tmp/stdout 2>/tmp/stderr
	if [[ $? -ne 0 ]]; then
		break
	fi
	
	let count++
done

echo "standard output: $(cat /tmp/stdout)"
echo "standard error:  $(cat /tmp/stderr)"
echo "It takes $count times to trigger a failure run"
