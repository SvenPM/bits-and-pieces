#!/bin/bash

## Nitrogenium is a wallpaper randomizer for Openbox based on Nitrogen
## this script was inspired by but is *NOT* based on Variety by Peter Levi

## requires: nitrogen, imagemagick, notify-send

# some settings
MINCOUNT=5              # don't make smaller than two
CONFIG=/home/$USER/.config

# get path of current wallpaper from bg-saved.cfg
CURRENT=`grep -Po "(?<=file=).*" "$CONFIG/nitrogen/bg-saved.cfg"`
#read the wallpaper directories from nitrogen.cfg
FILES=`grep -Po "(?<=dirs=).*" "$CONFIG/nitrogen/nitrogen.cfg" | sed "s/;/\/\* /g"`

# make sure there are enough wallpapers available, randomizing doesn't make a lot of sense with only a few wallies.
COUNT=`ls $FILES | grep -Eic ".*\.(png|jpe?g|bmp)"`
if [ $COUNT -ge $MINCOUNT ]; then
    # pick a random wallpaper from these directories and make sure it's different from the current wallpaper
    NEW=`ls $FILES | grep -Ei ".*\.(png|jpe?g|bmp)" | shuf -n 1`
    while [ "$NEW" = "$CURRENT" ]; do
        NEW=`ls $FILES | grep -Ei ".*\.(png|jpe?g|bmp)" | shuf -n 1`
    done
    
    # set the wallpaper with nitrogen 
    nitrogen --set-zoom $NEW && sed -i "s!^file=.*!file=$NEW!" $CONFIG/nitrogen/bg-saved.cfg
fi
