#!/usr/bin/env python3
"""
Build script for github.com/jantman/openscad-workbench-design

Requires Python3 (tested with 3.8) and the ImageMagick libraries (libmagickwand-dev)

Dependencies (tested version):
Pillow (5.1.0)
Wand (0.6.3)

NOTE: This is REALLY ugly, and frankly I'm embarrassed at letting the world see
it. It has a bunch of Python antipatterns that make me cringe and make my skin
crawl. But, I really didn't want to spend days on this one script, that will
never get run again once I finish the plans for this workbench...
"""

import sys
import argparse
import logging

from wand.image import Image

FORMAT = "[%(asctime)s %(levelname)s] %(message)s"
logging.basicConfig(level=logging.WARNING, format=FORMAT)
logger = logging.getLogger()


class Component:

    def __init__(self):
        pass


out_width = 1024
out_height = 768

with Image(filename='/tmp/jantman/test_front.svg') as img:
    print(f'Size: {img.size}')
    print(f'Resolution: {img.resolution}')
    #i.save(filename='mona-lisa-{0}.png'.format(r))
    density = (out_width * out_height) / (img.size[0] * img.size[1]) \
        * img.resolution[0]
    img.resample(x_res=density, y_res=density)
    img.save(filename='/tmp/jantman/test_front_resampled.png')
    img.resize(out_width, out_height)
    img.save(filename='/tmp/jantman/test_front_resampled_resized.png')


class WorkbenchBuilder:

    def __init__(self):
        pass

    def run(self):
        pass


def parse_args(argv):
    p = argparse.ArgumentParser(
        description='Build output for openscad-workbench-design'
    )
    p.add_argument('-v', '--verbose', dest='verbose', action='store_true',
                   default=False, help='debug-level output.')
    args = p.parse_args(argv)
    return args


def set_log_info():
    """set logger level to INFO"""
    set_log_level_format(logging.INFO,
                         '%(asctime)s %(levelname)s:%(name)s:%(message)s')


def set_log_debug():
    """set logger level to DEBUG, and debug-level output format"""
    set_log_level_format(
        logging.DEBUG,
        "%(asctime)s [%(levelname)s %(filename)s:%(lineno)s - "
        "%(name)s.%(funcName)s() ] %(message)s"
    )


def set_log_level_format(level, format):
    """
    Set logger level and format.

    :param level: logging level; see the :py:mod:`logging` constants.
    :type level: int
    :param format: logging formatter format string
    :type format: str
    """
    formatter = logging.Formatter(fmt=format)
    logger.handlers[0].setFormatter(formatter)
    logger.setLevel(level)


if __name__ == "__main__":
    args = parse_args(sys.argv[1:])

    # set logging level
    if args.verbose > 1:
        set_log_debug()
    elif args.verbose == 1:
        set_log_info()
    WorkbenchBuilder().run()
