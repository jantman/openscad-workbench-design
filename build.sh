#!/bin/bash

set -o errexit

. get_deps.sh

OUTPUTSIZE=3840,2160
MARKDOWN=""

rm -f renders/*.png

declare -A VIEWS
VIEWS[assembled]="-D'show_surfaces=true' -D'show_printer=true' -D'show_printer_control=true' -D'show_mfc_printer=true' -D'show_shelf_supports=true'"
VIEWS[framing]="-D'show_surfaces=false' -D'show_printer=false' -D'show_printer_control=false' -D'show_mfc_printer=false' -D'show_shelf_supports=false'"
VIEWS[exploded]="-D'show_surfaces=false' -D'show_exploded=true' -D'show_printer=false' -D'show_printer_control=false' -D'show_mfc_printer=false' -D'show_shelf_supports=false'"

for prefix in "${!VIEWS[@]}"; do
  /bin/sh -c "openscad -o renders/${prefix}_default.png ${VIEWS[$prefix]} --autocenter --viewall --imgsize $OUTPUTSIZE --view axes,edges,scales --projection p --hardwarnings table.scad"
  convert renders/${prefix}_default.png -resize 960x540\> renders/${prefix}_default_sm.png
  MARKDOWN="${MARKDOWN}"$'\n'$'\n'"[![${prefix}_default](renders/${prefix}_default_sm.png)](renders/${prefix}_default.png)"
  while read line
  do
    name=$(echo "$line" | awk -F \| '{print $1}')
    camera=$(echo "$line" | awk -F \| '{print $2}')
    cameraArg=$(echo "$camera" | sed -e 's/\[//g' -e 's/\]/,/g' -e 's/ //g' )
    /bin/sh -c "openscad -o renders/${prefix}_${name}.png ${VIEWS[$prefix]} --camera $cameraArg --imgsize $OUTPUTSIZE --view axes,edges,scales --projection p --hardwarnings table.scad"
    convert renders/${prefix}_${name}.png -resize 960x540\> renders/${prefix}_${name}_sm.png
    MARKDOWN="${MARKDOWN}"$'\n'$'\n'"[![${prefix}_${name}](renders/${prefix}_${name}_sm.png)](renders/${prefix}_${name}.png)"
  done <<EOF
front_left|[ 89.48, 32.46, 37.45 ] [ 65.50, 0.00, 340.90 ] 367.72
left_oblique|[ 89.50, 34.73, 42.12 ] [ 88.60, 0.00, 294.00 ] 330.95
left|[ 89.50, 34.73, 42.12 ] [ 93.50, 0.00, 273.70 ] 330.95
back_lower|[ 82.93, 40.29, 48.99 ] [ 115.20, 0.00, 216.30 ] 330.95
front_lower|[ 89.48, 32.46, 37.45 ] [ 115.90, 0.00, 39.70 ] 367.72
right_rear_lower|[ 93.09, 37.13, 57.98 ] [ 105.40, 0.00, 142.60 ] 330.95
EOF
done

MARKDOWN="${MARKDOWN}"$'\n'$'\n'"[![${prefix}_default](renders/${prefix}_default_sm.png)](renders/${prefix}_default.png)"
MARKDOWN="${MARKDOWN}"$'\n'$'\n'"### Shelf Supports"

# shelf supports
while read line
do
  prefix="shelf_support"
  name=$(echo "$line" | awk -F \| '{print $1}')
  camera=$(echo "$line" | awk -F \| '{print $2}')
  projection=$(echo "$line" | awk -F \| '{print $3}')
  cameraArg=$(echo "$camera" | sed -e 's/\[//g' -e 's/\]/,/g' -e 's/ //g' )
  /bin/sh -c "openscad -o renders/${prefix}_${name}.png --camera $cameraArg --imgsize $OUTPUTSIZE --view axes,edges,scales --projection $projection --hardwarnings individual_components/shelf_support.scad"
  convert renders/${prefix}_${name}.png -resize 960x540\> renders/${prefix}_${name}_sm.png
  MARKDOWN="${MARKDOWN}"$'\n'$'\n'"[![${prefix}_${name}](renders/${prefix}_${name}_sm.png)](renders/${prefix}_${name}.png)"
done <<EOF
right|140.21,-1.44,137.46,66.90,0.00,35.50,911.80|p
front|140.21,-1.44,137.46,90.70,0.00,359.80,911.80|p
back|140.21,-1.44,137.46,90.70,0.00,178.50,911.80|p
edge|140.21,-1.44,137.46,90.00,0.00,270.20,911.80|o
EOF

openscad -o /tmp/foo.stl table.scad 2>&1 | grep 'BOM ITEM' | sort | uniq -c | sort -n > BOM.txt
