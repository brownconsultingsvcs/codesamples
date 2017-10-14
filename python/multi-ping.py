#!/usr/bin/python
#
# multi-ping - A script which will perform pings to multiple hosts and collect
#              the average ping time
#
# Copyright (c) 2017 - Brown Consulting Services
#
import os
import time
import sys
import re
import argparse
import subprocess

# Number of times to ping each host
PING_COUNT = 3

# Ping wait time
PING_WAIT = 1


if __name__ == '__main__':

    """ Parse command line arguments"""

    parse_args = argparse.ArgumentParser(description='Multi-Site Ping')
        
    parse_args.add_argument("host", nargs=1,
                        help='Host to ping')

    parse_args.add_argument("addl_hosts", nargs='*',
                        help='Additional hosts to ping')

    cli_args = parse_args.parse_args()

    host_list = [cli_args.host[0]]

    for more_hosts in cli_args.addl_hosts:
        host_list.append(more_hosts)

    """ For each host in list, perform ping and use regex to extract average"""
    for host in host_list:
        ping_cmd = "/bin/ping -W %d -c %d %s" % (PING_WAIT, PING_COUNT, host)
        host_min, host_avg, host_max = None, None, None
        host_error = None

        try:
            response = subprocess.check_output(ping_cmd, stderr=subprocess.STDOUT, shell=True)
            match = re.search("rtt min/avg/max/mdev = ([\d.]+)/([\d.]+)/([\d.]+)", response, re.MULTILINE)

            if match:
                host_min = match.group(1)
                host_avg = match.group(2)
                host_max = match.group(3)

        except subprocess.CalledProcessError as e:
            host_error = e.output

        except OSError as e:
            host_error = e.strerror

        if host_avg:
            print("Host: %s - Avg Time: %s" % (host, host_avg))
        elif host_error:
            print("Host: %s - Error: %s" % (host,host_error))