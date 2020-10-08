#!/bin/bash

set -o xtrace

#openscad -o /tmp/jantman/test_o_camera.png --camera 19.85,0.15,-1.80,46.60,0.00,1.90,69.66 --autocenter --viewall --imgsize 3840,2160 --view edges --projection o individual_components/hutch_shelf_support.scad
#openscad -o /tmp/jantman/test_p_camera.png --camera 19.85,0.15,-1.80,46.60,0.00,1.90,69.66 --autocenter --viewall --imgsize 3840,2160 --view edges --projection p individual_components/hutch_shelf_support.scad

#openscad -o /tmp/jantman/test_o_camera.png --camera 19.85,0.15,-1.80,46.60,0.00,1.90,69.66 --autocenter --viewall --imgsize 3840,2160 --view edges --projection o individual_components/shelf_support.scad
#openscad -o /tmp/jantman/test_p_camera.png --camera 19.85,0.15,-1.80,46.60,0.00,1.90,69.66 --autocenter --viewall --imgsize 3840,2160 --view edges --projection p individual_components/shelf_support.scad

[[ -e /tmp/jantman/test_o_camera.png ]] || openscad -o /tmp/jantman/test_o_camera.png --camera 19.85,0.00,0.00,0.00,0.00,0.00,69.66 --autocenter --viewall --imgsize 3840,2160 --view edges --projection o individual_components/shelf_support.scad
[[ -e /tmp/jantman/test_p_camera.png ]] || openscad -o /tmp/jantman/test_p_camera.png --camera 19.85,0.00,0.00,0.00,0.00,0.00,69.66 --autocenter --viewall --imgsize 3840,2160 --view edges --projection p individual_components/shelf_support.scad

[[ -e /tmp/jantman/test_p_cameraRot1.png ]] || openscad -o /tmp/jantman/test_p_cameraRot1.png --camera 19.85,0.00,0.00,0.00,0.00,90.00,69.66 --autocenter --viewall --imgsize 3840,2160 --view edges --projection p individual_components/shelf_support.scad
[[ -e /tmp/jantman/test_p_cameraRot2.png ]] || openscad -o /tmp/jantman/test_p_cameraRot2.png --camera 19.85,0.00,0.00,0.00,90.00,0.00,69.66 --autocenter --viewall --imgsize 3840,2160 --view edges --projection p individual_components/shelf_support.scad
[[ -e /tmp/jantman/test_p_cameraRot3.png ]] || openscad -o /tmp/jantman/test_p_cameraRot3.png --camera 19.85,0.00,0.00,90.00,0.00,0.00,69.66 --autocenter --viewall --imgsize 3840,2160 --view edges --projection p individual_components/shelf_support.scad

for i in front back top bottom left right; do
  [[ -e /tmp/jantman/test_${i}.svg ]] || /bin/sh -c "openscad -o /tmp/jantman/test_${i}.svg -D'view_mode=\"${i}\"' --projection o individual_components/hutch_shelf_support.scad"
done
