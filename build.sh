#!/bin/bash

rm -f renders/*.jpg

OUTPUTSIZE=3840,2160
MARKDOWN=""

declare -A VIEWS
VIEWS[assembled]="-D'show_surfaces=true'"
VIEWS[framing]="-D'show_surfaces=false'"
VIEWS[exploded]="-D'show_exploded=true'"

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
front_left|[ 47.60, 17.73, 33.19 ] [ 72.50, 0.00, 343.00 ] 260.08
left_oblique|[ 47.60, 17.73, 33.19 ] [ 85.10, 0.00, 285.60 ] 260.08
left|[ 47.60, 17.73, 33.19 ] [ 92.10, 0.00, 268.80 ] 260.08
back_lower|[ 47.60, 17.73, 33.19 ] [ 109.60, 0.00, 211.40 ] 260.08
front_lower|[ 48.00, 18.00, 36.25 ] [ 121.50, 0.00, 42.50 ] 321.83
right_rear_lower|[ 48.00, 18.00, 36.25 ] [ 105.40, 0.00, 134.90 ] 321.83
EOF
done

echo "$MARKDOWN"
