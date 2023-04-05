#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This script is a simple wrapper which prefixes each i3status line with custom
# information. It is a python reimplementation of:
# http://code.stapelberg.de/git/i3status/tree/contrib/wrapper.pl
#
# To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section. Then, in your ~/.i3/config, use: status_command i3status | ~/i3status/contrib/wrapper.py In the 'bar' section.
#
# In its current version it will display the cpu frequency governor, but you
# are free to change it to display whatever you like, see the comment in the
# source code below.
#
# © 2012 Valentin Haenel <valentin.haenel@gmx.de>
#
# This program is free software. It comes without any warranty, to the extent
# permitted by applicable law. You can redistribute it and/or modify it under
# the terms of the Do What The Fuck You Want To Public License (WTFPL), Version
# 2, as published by Sam Hocevar. See http://sam.zoy.org/wtfpl/COPYING for more
# details.

import sys
import json
import subprocess


def get_kubectx():
    status = subprocess.check_output(["kubectx", "-c"])
    return status.decode("utf-8").strip()


def get_kubens():
    status = subprocess.check_output(["kubens", "-c"])
    return status.decode("utf-8").strip()


def get_dockerctx():
    status = subprocess.check_output(["docker", "context", "show"])
    return status.decode("utf-8").strip()


def print_line(message):
    """Non-buffered printing to stdout."""
    sys.stdout.write(message + "\n")
    sys.stdout.flush()


def read_line():
    """Interrupted respecting reader for stdin."""
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()


if __name__ == "__main__":
    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    while True:
        line, prefix = read_line(), ""
        # ignore comma at start of lines
        if line.startswith(","):
            line, prefix = line[1:], ","

        j = json.loads(line)
        # insert information into the start of the json, but could be anywhere
        j.insert(
            0, {"full_text": f" {get_kubens()}.{get_kubectx()} ", "name": "kubectx"}
        )
        j.insert(0, {"full_text": f" {get_dockerctx()} ", "name": "dockerctx"})
        # and echo back new encoded json
        print_line(prefix + json.dumps(j))
