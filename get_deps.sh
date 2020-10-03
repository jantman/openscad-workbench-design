#!/usr/bin/env bash

set -o errexit
set -o xtrace

[[ -e control_box_fixed.stl ]] || curl -L -o control_box_fixed.stl https://github.com/jantman/3d-printed-things/raw/master/my-cr10s/output/control_box_fixed.stl
[[ -e printer_fixed_shell.stl ]] || curl -L -o printer_fixed_shell.stl https://github.com/jantman/3d-printed-things/raw/master/my-cr10s/output/printer_fixed_shell.stl
