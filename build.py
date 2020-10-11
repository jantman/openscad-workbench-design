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
from typing import List, Optional, Tuple
import subprocess
import re
import json
from datetime import datetime

from lxml import etree
from wand.image import Image as WandImage
from PIL import Image, ImageDraw, ImageFont

FORMAT = "[%(asctime)s %(levelname)s] %(message)s"
logging.basicConfig(level=logging.WARNING, format=FORMAT)
logger = logging.getLogger()

#: Top directory for project
TOPDIR: str = os.path.dirname(os.path.abspath(__file__))

#: Directory for the individual component files
COMPONENT_DIR: str = os.path.join(TOPDIR, 'individual_components')

#: Cache of the BoM
BOM_CACHE: str = os.path.join(COMPONENT_DIR, 'bom.json')

#: Final built BoM
BOM_FILE: str = os.path.join(TOPDIR, 'BOM.txt')

#: Font size to use on images
FONT_SIZE: int = 120

#: Font to use on images
FONT: ImageFont = ImageFont.truetype('modules/DejaVuSans.ttf', size=FONT_SIZE)

#: Height of an example string in the chosen font
FONT_HEIGHT: int = FONT.getsize('Some Example text 123')[1]

#: Font size to use in the footer
FOOTER_FONT_SIZE: int = 72

#: Font to use in the footer
FOOTER_FONT: ImageFont = ImageFont.truetype(
    'modules/DejaVuSans.ttf', size=FOOTER_FONT_SIZE
)

#: Height of an example string in the chosen footer font
FOOTER_FONT_HEIGHT: int = FOOTER_FONT.getsize('Some Example text 123')[1]


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
    return p.stdout.decode()


def git_version():
    ver = subprocess.run(
        ['git', 'rev-parse', '--short', 'HEAD'], stdout=subprocess.PIPE,
        cwd=TOPDIR
    ).stdout.decode().strip()
    dirtyA = subprocess.run(
        ['git', 'diff', '--no-ext-diff', '--quiet', '--exit-code'],
        cwd=TOPDIR, check=False
    )
    dirtyB = subprocess.run(
        ['git', 'diff-index', '--cached', '--quiet', 'HEAD', '--'],
        cwd=TOPDIR, check=False
    )
    if dirtyA.returncode != 0 or dirtyB.returncode != 0:
        ver += ' (dirty)'
    return ver


class Component:
    """
    Note: The dimensions here are intended for 8.5x11" paper (US Letter)
    on a 600dpi printer that can print to 8.33x10.83 inches, or a full
    image size of 4998 x 6498 pixels.
    """

    #: Target final image width. This is based on printing at 600dpi on a
    #: printer that prints 8.33 inches wide on 8.5x11 (US Letter) paper.
    PAGE_WIDTH: int = 4998

    #: Target final image height. This is based on printing at 600dpi on a
    #: printer that prints 10.83 inches high on 8.5x11 (US Letter) paper.
    PAGE_HEIGHT: int = 6498

    #: Height of the footer at the bottom of the page
    FOOTER_HEIGHT: int = FOOTER_FONT_HEIGHT * 2

    #: Width of the per-image box
    IMG_BOX_WIDTH: int = int((PAGE_WIDTH - 4) / 2)

    #: Height of the per-image box
    IMG_BOX_HEIGHT: int = int((PAGE_HEIGHT - FOOTER_HEIGHT - 8) / 3)

    #: Estimated height of the per-view text at the top of each image
    IMG_TITLE_HEIGHT: int = int(FONT_HEIGHT * 1.5)

    #: X/height padding inside per-view boxes
    IMG_X_PADDING: int = int(IMG_BOX_WIDTH / 4)

    #: Y/width padding inside per-view boxes
    IMG_Y_PADDING: int = int((IMG_BOX_HEIGHT - IMG_TITLE_HEIGHT) / 4)

    #: Intermediate (per-view) image width
    INTER_IMG_WIDTH: int = int(IMG_BOX_WIDTH / 2)

    #: Intermediate (per-view) image height
    INTER_IMG_HEIGHT: int = int((IMG_BOX_HEIGHT - IMG_TITLE_HEIGHT) / 2)

    def __init__(
        self, fpath: str, module_name: str, bom_quantity: int,
        bom_extra_info: Optional[str], do_cleanup: bool = True
    ):
        self.fpath: str = fpath
        self.module_name: str = module_name
        self.bom_quantity: int = bom_quantity
        self.bom_extra_info: Optional[str] = bom_extra_info
        self._do_cleanup = do_cleanup
        logger.info(
            'Component: %s (in %s); cleanup=%s', self.module_name, self.fpath,
            self._do_cleanup
        )
        logger.info(
            'Dimensions: PAGE_WIDTH=%s PAGE_HEIGHT=%s FOOTER_HEIGHT=%s '
            'IMG_BOX_WIDTH=%s IMG_BOX_HEIGHT=%s INTER_IMG_WIDTH=%s '
            'INTER_IMG_HEIGHT=%s IMG_X_PADDING=%s IMG_Y_PADDING=%s '
            'IMG_TITLE_HEIGHT=%s',
            self.PAGE_WIDTH, self.PAGE_HEIGHT, self.FOOTER_HEIGHT,
            self.IMG_BOX_WIDTH, self.IMG_BOX_HEIGHT, self.INTER_IMG_WIDTH,
            self.INTER_IMG_HEIGHT, self.IMG_X_PADDING, self.IMG_Y_PADDING,
            self.IMG_TITLE_HEIGHT
        )

    def build(self):
        self._build_svgs()

    def _build_svgs(self):
        fpath = os.path.join(
            COMPONENT_DIR, f'{self.module_name}.png'
        )
        if os.path.exists(fpath):
            logger.info('Already exists: %s', fpath)
            return
        logger.debug('Create new empty image')
        overall_x = self.IMG_BOX_WIDTH * 2
        overall_y = (self.IMG_BOX_HEIGHT * 3) + self.FOOTER_HEIGHT
        img = Image.new(
            size=(overall_x, overall_y), mode='RGB', color=(255, 255, 255)
        )
        y = 0
        for view_pair in [
            ['top', 'bottom'], ['left', 'right'], ['back', 'front']
        ]:
            view = view_pair[0]
            logger.debug('Building view: %s', view)
            svgpath = self._build_one_svg(view)
            logger.debug('SVG path: %s', svgpath)
            pngpath = self._add_view_to_image(img, svgpath, view, 0, y)
            if self._do_cleanup:
                logger.debug('Cleanup: %s', svgpath)
                os.unlink(svgpath)
                logger.debug('Cleanup: %s', pngpath)
                os.unlink(pngpath)
            view = view_pair[1]
            logger.debug('Building view: %s', view)
            svgpath = self._build_one_svg(view)
            logger.debug('SVG path: %s', svgpath)
            pngpath = self._add_view_to_image(
                img, svgpath, view, self.IMG_BOX_WIDTH+1, y
            )
            y += self.IMG_BOX_HEIGHT
            if self._do_cleanup:
                logger.debug('Cleanup: %s', svgpath)
                os.unlink(svgpath)
                logger.debug('Cleanup: %s', pngpath)
                os.unlink(pngpath)
        self._add_footer_to_image(img, 0, y, overall_x)
        logger.debug('Writing combined image to: %s', fpath)
        with open(fpath, 'wb') as fh:
            img.save(fh)
        logger.info('Wrote combined image to: %s', fpath)

    def _add_footer_to_image(self, img: Image, x: int, y: int, width: int):
        logger.debug(
            'Using footer font with size %s; example text height: %s',
            FONT_SIZE, FONT_HEIGHT
        )
        draw: ImageDraw = ImageDraw.Draw(img)
        box_coords = [(x, y), (width, y + self.FOOTER_HEIGHT)]
        logger.debug('Drawing rectangle: %s', box_coords)
        draw.rectangle(box_coords, outline="black", width=4)
        left_text = f'{self.module_name} > QTY: {self.bom_quantity} <'
        if self.bom_extra_info is not None:
            left_text += f' ({self.bom_extra_info})'
        left_text_size = FOOTER_FONT.getsize(left_text)
        left_text_coords = (
            10,
            y + ((self.FOOTER_HEIGHT / 2) - (left_text_size[1] / 2))
        )
        logger.debug('Drawing left footer text at: %s', left_text_coords)
        draw.text(left_text_coords, left_text, (0, 0, 0), font=FOOTER_FONT)
        right_text = datetime.now().strftime(
            '%Y-%m-%d %H:%M:%S'
        ) + '  ' + git_version()
        right_text_size = FOOTER_FONT.getsize(right_text)
        right_text_coords = (
            width - right_text_size[0] - 10,
            y + ((self.FOOTER_HEIGHT / 2) - (right_text_size[1] / 2))
        )
        logger.debug('Drawing right footer text at: %s', right_text_coords)
        draw.text(right_text_coords, right_text, (0, 0, 0), font=FOOTER_FONT)

    def _add_view_to_image(
        self, img: Image, svgpath: str, view: str, x: int, y: int
    ) -> str:
        pngpath, width, height = self._svg_to_png(view, svgpath)
        draw: ImageDraw = ImageDraw.Draw(img)
        box_coords = [
            (x, y),
            (x + self.IMG_BOX_WIDTH - 2, y + self.IMG_BOX_HEIGHT)
        ]
        logger.debug('Drawing rectangle: %s', box_coords)
        draw.rectangle(box_coords, outline="black")
        text_size = FONT.getsize(view)
        text_coords = (
            x + ((self.IMG_BOX_WIDTH / 2) - (text_size[0] / 2)),
            y + (text_size[1] / 2)
        )
        logger.debug('Drawing text at: %s', text_coords)
        draw.text(text_coords, view, (0, 0, 0), font=FONT)
        logger.debug('PNG path: %s', pngpath)
        part = Image.open(pngpath)
        logger.debug('Add %s view to combined image', view)
        img.paste(
            part, self._center_image_in_box(
                x + self.IMG_X_PADDING,
                y + self.IMG_Y_PADDING + self.IMG_TITLE_HEIGHT,
                width, height
            )
        )
        return pngpath

    def _center_image_in_box(
        self, x: int, y: int, width: int, height: int
    ) -> Tuple[int, int]:
        if width == self.INTER_IMG_WIDTH:
            finalx = x
        else:
            finalx = x + ((self.INTER_IMG_WIDTH - width) / 2)
        if height == self.INTER_IMG_HEIGHT:
            finaly = y
        else:
            finaly = y + ((self.INTER_IMG_HEIGHT - height) / 2)
        finalx = int(finalx)
        finaly = int(finaly)
        logger.debug(
            'Centering %s x %s image in box with top-left at (%s, %s). '
            'Image top left: (%s, %s)', width, height, x, y, finalx, finaly
        )
        return finalx, finaly

    def _svg_to_png(self, view: str, svgpath: str) -> Tuple[str, int, int]:
        pngpath = os.path.join(
            COMPONENT_DIR, f'{self.module_name}_{view}.png'
        )
        if os.path.exists(pngpath):
            logger.debug('Already exists: %s', pngpath)
            with WandImage(filename=svgpath) as img:
                width, height = img.size
            return pngpath, width, height
        self._resize_svg(svgpath)
        logger.debug('Loading image: %s', svgpath)
        with WandImage(filename=svgpath) as img:
            width, height = img.size
            resolution = min(img.resolution)
            logger.debug(
                'Image is %s x %s at resolution %s', width, height, resolution
            )
            logger.debug('Writing to: %s', pngpath)
            img.save(filename=pngpath)
        return pngpath, width, height

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
            mult = self.INTER_IMG_WIDTH / width
        else:
            mult = self.INTER_IMG_HEIGHT / height
        return [int(width * mult), int(height * mult)]

    def _build_one_svg(self, view: str) -> str:
        scadpath = os.path.join(
            'individual_components', f'{self.module_name}_{view}.scad'
        )
        if os.path.exists(scadpath):
            logger.debug('%s already exists; not writing', scadpath)
        else:
            logger.debug(
                'Writing SCAD file for view %s to: %s', view, scadpath
            )
            with open(scadpath, 'w') as fh:
                fh.write(self.scad_file(view))
            logger.info('Wrote SCAD file to: %s', scadpath)
        svgpath = os.path.join(
            COMPONENT_DIR, f'{self.module_name}_{view}.svg'
        )
        if os.path.exists(svgpath):
            logger.debug('Already exists: %s', svgpath)
            return svgpath
        logger.info('Writing %s view SVG', view)
        cmd = ['openscad', '-o', svgpath, scadpath]
        run_command(cmd)
        if self._do_cleanup:
            logger.debug('Cleanup: %s', scadpath)
            os.unlink(scadpath)
        return svgpath

    def scad_file(self, view_mode):
        return f'use <../components/{self.module_name}.scad>\n' \
               'use <../modules/rotated_view.scad>\n\n' \
               f'rotated_view("{view_mode}") {{\n' \
               f'    {self.module_name}();\n' \
               '}\n\n'


class WorkbenchBuilder:

    def __init__(self, do_cleanup=True):
        self.do_cleanup = do_cleanup
        if not os.path.exists(COMPONENT_DIR):
            logger.info('Creating directory: %s', COMPONENT_DIR)
            os.makedirs(COMPONENT_DIR)

    def run(self, component=None, run_build_sh=True):
        logger.debug(
            'Using font with size %s; example text height: %s', FONT_SIZE,
            FONT_HEIGHT
        )
        # yeah, this is a total cop-out...
        if run_build_sh:
            logger.info('Executing build.sh')
            run_command(['bash', 'build.sh'])
        if os.path.exists(BOM_CACHE):
            logger.debug('Loading BoM from cache: %s', BOM_CACHE)
            with open(BOM_CACHE, 'r') as fh:
                bom: dict = json.load(fh)
        else:
            logger.info('Getting BOM from openscad...')
            bom: dict = self._get_bom()
        logger.info('Building components...')
        self.build_components(bom, only_component=component)
        logger.info('Done building components')

    def _get_bom(self) -> dict:
        line_re = re.compile(
            r'^ECHO: "BOM ITEM: ([^\s]+)\s?(.*)?"$'
        )
        result = {}
        cmd = ['openscad', '-o', 'foo.stl', 'table.scad']
        lines = run_command(cmd).split('\n')
        os.unlink('foo.stl')
        for line in lines:
            line = line.strip()
            m = line_re.match(line)
            if not m:
                continue
            modname, extra = m.groups()
            if extra == '':
                extra = None
            if modname not in result:
                result[modname] = {'count': 0, 'extra': extra}
            result[modname]['count'] += 1
        logger.debug('BoM items: %s', result)
        logger.debug('Writing %s', BOM_CACHE)
        with open(BOM_CACHE, 'w') as fh:
            fh.write(json.dumps(dict(result), sort_keys=True, indent=4))
        logger.debug('Writing %s', BOM_FILE)
        with open(BOM_FILE, 'w') as fh:
            for k in sorted(result.keys()):
                fh.write(f'{result[k]["count"]}x {k}')
                if result[k]['extra'] is not None:
                    fh.write(' (' + result[k]['extra'] + ')')
                fh.write('\n')
        return dict(result)

    def build_components(self, bom: dict, only_component: Optional[str]):
        logger.debug('Finding components')
        for fpath in sorted(glob(os.path.join(TOPDIR, 'components', '*.scad'))):
            component = os.path.basename(fpath).replace('.scad', '')
            if only_component is not None and only_component != component:
                logger.warning(
                    'Run with arguments to only build "%s"; skipping "%s"',
                    only_component, component
                )
                continue
            if component in ['pegboard', 'shelf_support', 'printer']:
                logger.debug('Skipping component %s in %s', component, fpath)
                continue
            logger.debug('Found component %s in %s', component, fpath)
            qty = bom[component]['count']
            extra_info = bom[component]['extra']
            Component(
                fpath, component, qty, extra_info, do_cleanup=self.do_cleanup
            ).build()


def parse_args(argv):
    p = argparse.ArgumentParser(
        description='Build output for openscad-workbench-design'
    )
    p.add_argument('-v', '--verbose', dest='verbose', action='store_true',
                   default=False, help='debug-level output.')
    p.add_argument(
        '-C', '--no-cleanup', dest='cleanup', action='store_false',
        default=True,
        help='Do not clean up intermediate files. Also do not regenerate them '
             'unless manually removed.'
    )
    p.add_argument(
        '-c', '--component', dest='component', action='store', type=str,
        help='Build only this one component'
    )
    p.add_argument(
        '-B', '--skip-main-build', dest='run_build_sh', action='store_false',
        default=True, help='execute build.sh (main build)'
    )
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
    WorkbenchBuilder(do_cleanup=args.cleanup).run(
        component=args.component, run_build_sh=args.run_build_sh
    )
