#!/bin/bash

set -o errexit
cd "$( dirname "${BASH_SOURCE[0]}" )"

for i in *.scad; do
  name=$(echo "$i" | sed 's/.scad//')
  openscad -o ${name}.stl $i
done
rm -f pegboard.stl
