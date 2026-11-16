#!/bin/zsh
# Crop raw 5K captures into the site's stills. Crop = w:h:x:y in capture pixels.
source ${0:a:h}/env.sh
j() { ffmpeg -loglevel error -y -i "$SHOTS/$1" -vf "crop=$2,scale=$3" -q:v 3 "$ASSETS/shots/$4"; }
j month-nativeGlass.png 3296:2320:1442:270 1800:-2 month.jpg     # main panel with a margin
j month-nativeGlass.png 990:1485:419:605 680:-2 sidebar.jpg      # month name to event list, 2:3
j weekly-nativeGlass.png 1902:2320:1442:270 920:-2 weekly.jpg     # times + Sun..Wed
for a in nativeGlass transparent blurred; do j pattern-$a.png 1600:1200:3480:1500 1200:-2 appearance-$a.jpg; done
# Quick-edit panel beside "Coffee with Maya" on Nov 26 (captured by hand, see SKILL.md); 16:10
[[ -f $SHOTS/add-edit.png ]] && j add-edit.png 2728:1705:1960:944 1600:-2 add-edit.jpg
