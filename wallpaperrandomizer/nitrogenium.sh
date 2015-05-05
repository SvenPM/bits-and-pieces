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

    # create thumbnail for notification bubble
    convert "$NEW" -thumbnail 50x50^ -gravity Center -crop 50x50-0-0 "$CONFIG/openbox/thumb.png"
    # extract filename from path for notification bubble
    NAME=`echo $NEW | grep -Pio "[^/]*(?=\.(png|jpe?g|bmp))" | cut -c1-100`
    # set the wallpaper with nitrogen and notify user
    nitrogen --set-zoom $NEW && { notify-send -t 5000 -i "$CONFIG/openbox/thumb.png" "Nitrogenium" "Changed wallaper to \"$NAME\""; sed -i "s!^file=.*!file=$NEW!" $CONFIG/nitrogen/bg-saved.cfg; }

    # remove thumbnail
    rm -f "$CONFIG/openbox/thumb.png"
else
    # notify user that there are not enough wallpapers available
    notify-send -t 1000 -i error  "Nitrogenium" "Not enough wallpapers for random changing"
fi
