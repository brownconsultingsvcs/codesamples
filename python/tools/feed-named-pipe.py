#!/usr/bin/python
#
# feed-named-pipe - A simple utility to feed data from a file into a named pipe. Useful for
#                   testing other applications. Supports different sending speeds of data
#                   from the file
#
# Copyright (c) 2017 - Brown Consulting Services
#

import argparse
import os.path
import time
import random
import sys


def error_exit(message, return_code=1):
    """ Utility function to standardize exiting on error cases """
    print("ERROR: " + message)
    exit(return_code)


def write_to_pipe(pipe, data, flush_data, show_progress):
    """ Write the feed data to the named pipe with optional flushing and progress indicator

    :param pipe: Named pipe opened earlier
    :param data: Line of data from the feed
    :param flush_data: Boolean flag to flush data to pipe
    :param show_progress: Boolean flag to show progress indicator
    :return:
    """
    if show_progress:
        sys.stdout.write(".")
        sys.stdout.flush()

    pipe.write(data)
    if flush_data:
        pipe.flush()


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Feed the contents of a file into a named pipe')

    parser.add_argument('--mode', action='store', default='paced', choices=['paced','random','blast'],
                        help='Modes = paced (1 per interval), random (1 .. max interval), blast')

    parser.add_argument('--interval', action='store', type=int, default=1,
                        help='Time interval in seconds')

    parser.add_argument('--pipe', action='store', required=True, help='Path for named pipe to be created')

    parser.add_argument('--file', action='store', required=True, help='Source file to feed into named pipe')

    parser.add_argument("--noflush", action='store_true', default=False, help='Do not flush output to pipe')

    parser.add_argument("--progress", action='store_true', default=False, help='Show progress indicators as data sent')

    args = parser.parse_args()

    print("Mode="+args.mode)
    print("Interval="+str(args.interval))
    print("Pipe="+args.pipe)
    print("File="+args.file)

    if not os.path.exists(args.file):
        error_exit("Source file " + args.file + " does not exist!")

    datafile = open(args.file, "r")

    if not datafile:
        error_exit("ERROR: Unable to open " + args.file + " for reading.")

    if os.path.exists(args.pipe):
        os.remove(args.pipe)

    try:
        os.mkfifo(args.pipe)

    except OSError as ex:
        error_exit("ERROR: Unable to create named pipe " + args.pipe + " due to : " + ex.strerror)

    named_pipe = open(args.pipe, "w")

    if not named_pipe:
        os.remove(args.pipe)
        error_exit("ERROR: Unable to open " + args.pipe + " for writing.")

    for line in datafile:
        if args.mode == "blast":
            write_to_pipe(named_pipe, line, args.noflush, args.progress)
        elif args.mode == "paced":
            write_to_pipe(named_pipe, line, args.noflush, args.progress)
            time.sleep(args.interval)
        elif args.mode == "random":
            write_to_pipe(named_pipe, line, args.noflush, args.progress)
            time.sleep(random.randint(1, args.interval))

    datafile.close()

    named_pipe.close()

    os.remove(args.pipe)
