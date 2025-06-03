#!/usr/bin/python

import time
import sys
import subprocess


wait_time = int(sys.argv[1]) if len(sys.argv) > 1 else "30"

while True:
    print("Treat timer is running...")
    time.sleep(wait_time)  # Wait for 60 seconds before the next iteration

    # send a message via notify-send
    subprocess.run(["notify-send", "rat food!"])

