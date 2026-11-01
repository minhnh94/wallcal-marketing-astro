#!/bin/zsh
# Render overlays, the hero intro video and the add-on clips, then copy them into public/my-assets.
source ${0:a:h}/env.sh
V=$WORK/video; mkdir -p $V; cd $V; O=$BIN/overlay; ICON=$ASSETS/app-icon.png
$O card title.png $ICON "WallCal" "Your calendar, right on your wallpaper."
$O caption c1.png "Month view" "Your whole month, always on your desktop."
$O caption c2.png "Sidebar" "Today, a mini calendar and what’s next."
$O caption c3.png "Weekly agenda" "Or switch to a timeline of your week."
$O caption c4a.png "Appearance" "Native Glass"
$O caption c4b.png "Appearance" "Transparent"
$O caption c4c.png "Appearance" "Blurred"
$O caption c5.png "Always there" "No Dock icon. No window to open. Just your day."
$O card end.png $ICON "WallCal" "Free on the Mac App Store" "Also included with Setapp  ·  wallcal.app"
python3 -I $K/intro_video.py $SHOTS $V || exit 1
cp wallcal-intro.mp4 wallcal-intro.webm $ASSETS/video/
ffmpeg -loglevel error -y -ss 1.2 -i wallcal-intro.mp4 -frames:v 1 -q:v 3 $ASSETS/video/wallcal-intro-poster.jpg
python3 -I $K/addon_clips.py $SHOTS/addon $O $V/addon || exit 1
cd addon && cp *.mp4 *.webm $ASSETS/addon/ && for f in *.jpg; do cp $f $ASSETS/addon/${f%.jpg}-poster.jpg; done
