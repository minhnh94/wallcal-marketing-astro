#!/bin/zsh
# Hero video: re-encode the WallCal repo's promo renders (with sound) for the web, one per locale, plus a poster
# and a silent ~10 s autoplay loop of the whole story (hero_loop.py).
source ${0:a:h}/env.sh
R=${PROMO_RENDERS:-$HOME/Self-help/Swift/WallCal/build/videos/renders}
for l in en de ja zh-Hans; do
  s=${l%-Hans}; out=$ASSETS/video/promo-$s
  ffmpeg -loglevel error -y -i $R/$l/wallcal-promo-$l.mp4 -c:v libx264 -crf 24 -preset slow -pix_fmt yuv420p \
    -c:a aac -b:a 128k -movflags +faststart $out.mp4 || exit 1
  ffmpeg -loglevel error -y -ss 2.6 -i $out.mp4 -frames:v 1 -q:v 3 $out-poster.jpg    # calendar on the wallpaper, first caption
  python3 ${0:a:h}/hero_loop.py $R/$l/wallcal-promo-$l.mp4 $out-loop.mp4 || exit 1
done
