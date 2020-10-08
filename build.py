#!/usr/bin/env python3
"""
Build script for github.com/jantman/openscad-workbench-design

Requires Python3 (tested with 3.8) and the ImageMagick libraries (libmagickwand-dev)

Dependencies (tested version):
svglib (1.0.1)
reportlab (3.5.53)
Pillow (5.1.0)
Wand (0.6.3)

NOTE: This is REALLY ugly, and frankly I'm embarrassed at letting the world see
it. It has a bunch of Python antipatterns that make me cringe and make my skin
crawl. But, I really didn't want to spend days on this one script, that will
never get run again once I finish the plans for this workbench...
"""

from svglib.svglib import svg2rlg
from reportlab.graphics import renderPM

#drawing = svg2rlg('/tmp/jantman/test_front.svg')
#renderPM.drawToFile(drawing, "/tmp/jantman/test_front.png", fmt="PNG", dpi=1200)

from wand.image import Image

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
