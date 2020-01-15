#!/bin/bash

main() {
	(
		flock -n 200
		echo "flock return code: $? - sleeping for 10sec..."
		sleep 10
	) 200>foolock
}

main


