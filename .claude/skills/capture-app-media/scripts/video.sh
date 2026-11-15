#!/bin/zsh
# Render the Expert add-on clips, then copy them into public/my-assets/addon.
source ${0:a:h}/env.sh
V=$WORK/video; mkdir -p $V; cd $V; O=$BIN/overlay
python3 -I $K/addon_clips.py $SHOTS/addon $O $V/addon || exit 1
cd addon && cp *.mp4 *.webm $ASSETS/addon/ && for f in *.jpg; do cp $f $ASSETS/addon/${f%.jpg}-poster.jpg; done
