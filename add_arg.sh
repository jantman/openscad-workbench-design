#!/bin/bash
# USAGE: ./add_arg.sh function_or_module_name arg_name
sed -i -E "s/${1}\(([^\)]+)\)/${1}(\1,${2})/g" *.scad components/*.scad
