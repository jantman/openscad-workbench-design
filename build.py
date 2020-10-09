#!/usr/bin/env python3
"""
Build script for github.com/jantman/openscad-workbench-design

Requires Python3 (tested with 3.8) and the ImageMagick libraries (libmagickwand-dev)

Dependencies (tested version):
Pillow (7.2.0)
Wand (0.6.3)

NOTE: This is REALLY ugly, and frankly I'm embarrassed at letting the world see
it. It has a bunch of Python antipatterns that make me cringe and make my skin
crawl. But, I really didn't want to spend days on this one script, that will
never get run again once I finish the plans for this workbench...
"""

import sys
import os
import argparse
import logging
from glob import glob
from textwrap import dedent
from typing import List, Optional
import subprocess
import re

from lxml import etree
from wand.image import Image as WandImage
from PIL import Image, ImageDraw

FORMAT = "[%(asctime)s %(levelname)s] %(message)s"
logging.basicConfig(level=logging.WARNING, format=FORMAT)
logger = logging.getLogger()

#: Top directory for project
TOPDIR: str = os.path.dirname(os.path.abspath(__file__))

#: Directory for the individual component files
COMPONENT_DIR: str = os.path.join(TOPDIR, 'individual_components')

#: Intermediate (per-view) image width
INTER_IMG_WIDTH: int = 1024

#: Intermediate (per-view) image height
INTER_IMG_HEIGHT: int = 768


def run_command(cmd: List[str], shell: bool = False):
    logger.debug(
        'Executing: %s with cwd=%s shell=%s', ' '.join(cmd), TOPDIR, shell
    )
    p = subprocess.run(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=False,
        cwd=TOPDIR, shell=shell
    )
    if p.returncode != 0:
        logger.error(
            'ERORR: Process "%s" exited %d:\n%s', ' '.join(cmd),
            p.returncode, p.stdout.decode()
        )
        raise SystemExit(p.returncode)
    logger.debug(
        'Process "%s" exited %d:\n%s', ' '.join(cmd), p.returncode,
        p.stdout.decode()
    )


class Component:

    def __init__(self, fpath: str, module_name: str):
        self.fpath: str = fpath
        self.module_name: str = module_name
        self.scadpath = os.path.join(
            'individual_components', f'{self.module_name}.scad'
        )
        logger.info('Component: %s (in %s)', self.module_name, self.fpath)

    def build(self):
        self._build_svgs()

    def _build_svgs(self):
        logger.debug('Create new empty image')
        img = Image.new(
            size=(INTER_IMG_WIDTH*2, INTER_IMG_HEIGHT*3), mode='RGB',
            color=(255, 255, 255)
        )
        x = 0
        y = 0
        for view in ['top', 'bottom', 'left', 'right', 'back', 'front']:
            logger.debug('Building view: %s', view)
            svgpath = self._build_one_svg(view)
            logger.debug('SVG path: %s', svgpath)
            pngpath = self._svg_to_png(view, svgpath)
            logger.debug('PNG path: %s', pngpath)
            logger.debug('Add %s view to combined image', view)
            part = Image.open(pngpath)
            img.paste(part, (x, y))
            part = None
            if x == 0:
                x = INTER_IMG_WIDTH
            else:
                x = 0
                y += INTER_IMG_HEIGHT
        fpath = os.path.join(
            COMPONENT_DIR, f'{self.module_name}.png'
        )
        logger.debug('Writing combined image to: %s', fpath)
        with open(fpath, 'wb') as fh:
            img.save(fh)
        logger.info('Wrote combined image to: %s', fpath)

    def _svg_to_png(self, view: str, svgpath: str) -> str:
        self._resize_svg(svgpath)
        pngpath = os.path.join(
            COMPONENT_DIR, f'{self.module_name}_{view}.png'
        )
        logger.debug('Loading image: %s', svgpath)
        with WandImage(filename=svgpath) as img:
            width, height = img.size
            resolution = min(img.resolution)
            logger.debug(
                'Image is %s x %s at resolution %s', width, height, resolution
            )
            logger.debug('Writing to: %s', pngpath)
            img.save(filename=pngpath)
        return pngpath

    def _resize_svg(self, svgpath: str):
        """
        Based on code from: https://github.com/Zverik/svg-resize
        Resize SVG and add frame for printing in a given format.
        Written by Ilya Zverev, licensed WTFPL.
        """
        logger.debug('Resizing SVG at: %s', svgpath)
        tree = etree.parse(svgpath, parser=etree.XMLParser(huge_tree=True))
        svg = tree.getroot()
        if 'width' not in svg.keys() or 'height' not in svg.keys():
            raise Exception(
                'SVG header must contain width and height attributes')
        viewbox = re.split('[ ,\t]+', svg.get('viewBox', '').strip())
        if len(viewbox) == 4:
            for i in [0, 1, 2, 3]:
                viewbox[i] = self._parse_length(viewbox[i])
            if viewbox[2] * viewbox[3] <= 0.0:
                viewbox = None
        twidth, theight = self._png_size(
            self._parse_length(svg.get('width')),
            self._parse_length(svg.get('height'))
        )
        logger.debug('Resizing to: %s x %s', twidth, theight)
        # set svg width and height, update viewport for margin
        svg.set('width', '{}px'.format(twidth))
        svg.set('height', '{}px'.format(theight))
        offsetx = 0
        offsety = 0
        margin = 0
        if twidth / theight > viewbox[2] / viewbox[3]:
            # target page is wider than source image
            page_width = viewbox[3] / theight * twidth
            offsetx = (page_width - viewbox[2]) / 2
            page_height = viewbox[3]
        else:
            page_width = viewbox[2]
            page_height = viewbox[2] / twidth * theight
            offsety = (page_height - viewbox[3]) / 2
        vb_margin = page_width / twidth * margin
        svg.set('viewBox', '{} {} {} {}'.format(
            viewbox[0] - vb_margin - offsetx,
            viewbox[1] - vb_margin - offsety,
            page_width + vb_margin * 2,
            page_height + vb_margin * 2))
        tree.write(svgpath)

    def _parse_length(self, value, def_units='px'):
        """
        Based on code from: https://github.com/Zverik/svg-resize
        Resize SVG and add frame for printing in a given format.
        Written by Ilya Zverev, licensed WTFPL.
        """
        if not value:
            return 0.0
        parts = re.match(r'^\s*(-?\d+(?:\.\d+)?)\s*(px|in|cm|mm|pt|pc|%)?',
                         value)
        if not parts:
            raise Exception('Unknown length format: "{}"'.format(value))
        num = float(parts.group(1))
        units = parts.group(2) or def_units
        if units == 'px':
            return num
        elif units == 'pt':
            return num * 1.25
        elif units == 'pc':
            return num * 15.0
        elif units == 'in':
            return num * 90.0
        elif units == 'mm':
            return num * 3.543307
        elif units == 'cm':
            return num * 35.43307
        elif units == '%':
            return -num / 100.0
        else:
            raise Exception('Unknown length units: {}'.format(units))

    def _png_size(self, width: int, height: int) -> List[int]:
        if width > height:
            mult = INTER_IMG_WIDTH / width
        else:
            mult = INTER_IMG_HEIGHT / height
        return [int(width * mult), int(height * mult)]

    def _build_one_svg(self, view: str) -> str:
        if os.path.exists(self.scadpath):
            logger.debug('%s already exists; not writing', self.scadpath)
        else:
            logger.debug(
                'Writing SCAD file for view %s to: %s', view, self.scadpath
            )
            with open(self.scadpath, 'w') as fh:
                fh.write(self.scad_file(view))
            logger.info('Wrote SCAD file to: %s', self.scadpath)
        svgpath = os.path.join(
            COMPONENT_DIR, f'{self.module_name}_{view}.svg'
        )
        if os.path.exists(svgpath):
            logger.debug('Already exists: %s', svgpath)
            return svgpath
        logger.info('Writing %s view SVG', view)
        cmd = ['openscad', '-o', svgpath, self.scadpath]
        run_command(cmd)
        return svgpath

    def scad_file(self, view_mode):
        return f'use <../components/{self.module_name}.scad>\n' \
               'use <../modules/rotated_view.scad>\n\n' \
               f'rotated_view("{view_mode}") {{\n' \
               f'    {self.module_name}();\n' \
               '}\n\n'


class WorkbenchBuilder:

    def __init__(self):
        pass

    def run(self):
        logger.info('Building components...')
        self.build_components()
        logger.info('Done building components')

    def build_components(self):
        if not os.path.exists(COMPONENT_DIR):
            logger.info('Creating directory: %s', COMPONENT_DIR)
            os.makedirs(COMPONENT_DIR)
        logger.debug('Finding components')
        for fpath in glob(os.path.join(TOPDIR, 'components', '*.scad')):
            component = os.path.basename(fpath).replace('.scad', '')
            if component in ['pegboard', 'shelf_support']:
                logger.debug('Skipping component %s in %s', component, fpath)
                continue
            logger.debug('Found component %s in %s', component, fpath)
            if component != 'hutch_shelf_support':
                continue
            Component(fpath, component).build()


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
    if args.verbose:
        set_log_debug()
    else:
        set_log_info()
    WorkbenchBuilder().run()
