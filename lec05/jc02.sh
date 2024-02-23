#!/usr/bin/env bash

pidwait() {
	
	while [ -z "$(kill -0 $1 2>&1)" ]
	do
		sleep 1
	done

	ls $PWD

}
