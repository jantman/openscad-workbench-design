#!/bin/bash

rm -f *.jpg

OUTPUTSIZE=3840,2160

openscad -o renders/default.png --autocenter --viewall --imgsize $OUTPUTSIZE --view axes,edges,scales --projection p --hardwarnings table.scad
convert renders/default.png -resize 960x540\> renders/default_sm.png
MARKDOWN="[![default](renders/default_sm.png)](renders/default.png)"

while read line
do
  name=$(echo "$line" | awk -F \| '{print $1}')
  camera=$(echo "$line" | awk -F \| '{print $2}')
  cameraArg=$(echo "$camera" | sed -e 's/\[//g' -e 's/\]/,/g' -e 's/ //g' )
  openscad -o renders/${name}.png --camera $cameraArg --imgsize $OUTPUTSIZE --view axes,edges,scales --projection p --hardwarnings table.scad
  convert renders/${name}.png -resize 960x540\> renders/${name}_sm.png
  MARKDOWN="${MARKDOWN}"$'\n'$'\n'"[![${name}](renders/${name}_sm.png)](renders/${name}.png)"
done <<EOF
front_left|[ 47.60, 17.73, 33.19 ] [ 72.50, 0.00, 343.00 ] 260.08
left_oblique|[ 47.60, 17.73, 33.19 ] [ 85.10, 0.00, 285.60 ] 260.08
left|[ 47.60, 17.73, 33.19 ] [ 92.10, 0.00, 268.80 ] 260.08
back_lower|[ 47.60, 17.73, 33.19 ] [ 109.60, 0.00, 211.40 ] 260.08
front_lower|[ 48.00, 18.00, 36.25 ] [ 121.50, 0.00, 42.50 ] 321.83
right_rear_lower|[ 48.00, 18.00, 36.25 ] [ 105.40, 0.00, 134.90 ] 321.83
EOF

echo "$MARKDOWN"
