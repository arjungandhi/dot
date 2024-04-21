#!/usr/bin/bash

# ---------------------------------- Symlinks ----------------------------------

# get directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# make sure the directory exists
mkdir -p ~/.config/picom

# create symlinks
ln -sf $DIR/picom.conf ~/.config/picom/picom.conf
