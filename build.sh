#!/bin/bash

OUTPUTSIZE=3840,2160

openscad -o default.png --autocenter --viewall --imgsize $OUTPUTSIZE --render --view axes,edges,scales --projection p --hardwarnings table.scad

while read line
do
  name=$(echo "$line" | awk -F \| '{print $1}')
  camera=$(echo "$line" | awk -F \| '{print $2}')
  cameraArg=$(echo "$camera" | sed -e 's/\[//g' -e 's/\]/,/g' -e 's/ //g' )
  openscad -o ${name}.png --camera $cameraArg --imgsize $OUTPUTSIZE --render --view axes,edges,scales --projection p --hardwarnings table.scad
done <<EOF
one|[ 48.00, 18.00, 36.00 ] [ 63.40, 0.00, 35.50 ] 321.09
two|[ 47.60, 17.73, 33.19 ] [ 72.50, 0.00, 343.00 ] 260.08
three|[ 47.60, 17.73, 33.19 ] [ 85.10, 0.00, 285.60 ] 260.08
four|[ 47.60, 17.73, 33.19 ] [ 92.10, 0.00, 268.80 ] 260.08
five|[ 47.60, 17.73, 33.19 ] [ 109.60, 0.00, 211.40 ] 260.08
EOF
