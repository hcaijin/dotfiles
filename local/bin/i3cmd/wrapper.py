#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This script is a simple wrapper which prefixes each i3status line with custom
# information. It is a python reimplementation of:
# http://code.stapelberg.de/git/i3status/tree/contrib/wrapper.pl
#
# To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section.
# Then, in your ~/.i3/config, use:
#     status_command i3status | ~/i3status/contrib/wrapper.py
# In the 'bar' section.
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

import os
import re
import sys
import json

def netspeed():
    try:
        rx = tx = 0
        netdir = "/sys/class/net"
        rxfile = netdir + "/{}/statistics/rx_bytes"
        txfile = netdir + "/{}/statistics/tx_bytes"
        with os.scandir(netdir) as files:
            for entry in files:
                if entry.is_file() and re.search('^(eth|wlan|enp|wlp)', entry.name):
                    with open(rxfile.format(entry.name)) as rx:
                        tmp_rx = rx.read()
                    with open(txfile.format(entry.name)) as tx:
                        tmp_tx = tx.read()
                    rx = rx + tmp_rx
                    tx = tx + tmp_tx
        return "%s ↓ %s ↑" % (rx, tx)
    except Exception as e:
        print("Get netspeed error:%", e)
        return "Error."

def weather():
    try:
        return os.popen('weather').read()
    except Exception as e:
        print("Get weather error:%", e)
        return "Error."

def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()

def read_line():
    """ Interrupted respecting reader for stdin. """
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

if __name__ == '__main__':
    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    i = 0
    while True:
        line, prefix = read_line(), ''
        # ignore comma at start of lines
        if line.startswith(','):
            line, prefix = line[1:], ','

        j = json.loads(line)
        # Test i++
        #  i += 1
        #  j.insert(0, {'full_text' : '%s' % i, 'name' : 'test'})
        # insert information into the start of the json, but could be anywhere
        # CHANGE THIS LINE TO INSERT SOMETHING ELSE
        j.insert(5, {'full_text' : '%s' % weather(), 'name' : 'weather'})
        j.insert(3, {'full_text' : ' %s' % netspeed(), 'name' : 'netspeed'})
        # and echo back new encoded json
        print_line(prefix+json.dumps(j))
