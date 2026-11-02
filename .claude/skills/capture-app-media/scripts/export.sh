#!/bin/zsh
# Crop raw 5K captures into the site's stills. Crop = w:h:x:y in capture pixels.
source ${0:a:h}/env.sh
j() { ffmpeg -loglevel error -y -i "$SHOTS/$1" -vf "crop=$2,scale=$3" -q:v 3 "$ASSETS/shots/$4"; }
j month-nativeGlass.png 3700:2320:1040:270 1800:-2 month.jpg
j month-nativeGlass.png 990:1485:424:620 680:-2 sidebar.jpg
j weekly-nativeGlass.png 1840:2300:1040:270 920:-2 weekly.jpg
j weekly-nativeGlass.png 3060:2295:1040:270 1600:-2 weekly-wide.jpg
for a in nativeGlass transparent blurred; do j pattern-$a.png 1600:1200:3480:1500 1200:-2 appearance-$a.jpg; done
