# Shared settings, sourced by the other scripts.
K=${0:a:h}                                  # this scripts/ dir
REPO=${K:h:h:h:h}                           # landing repo root
WORK=${WORK:-$REPO/.capture}                # gitignored scratch: binaries, raw shots, renders
BIN=$WORK/bin; SHOTS=$WORK/shots; mkdir -p $BIN $SHOTS/addon
ASSETS=$REPO/public/my-assets
APP=${APP:-$WORK/dd/Build/Products/Debug/WallCal-setapp.app}
# The Debug build's process name; an installed Setapp WallCal runs as "WallCal" and is left alone
PROC=${APP:t:r}
SCREEN=${SCREEN:-$(cat $WORK/screen.txt 2>/dev/null)}
# WallCal window in points on the main display. Crops in export.sh assume this on a 2560x1440@2x display.
# designatedWindowScreen only applies on monitor changes; at launch the frame autosave key places the window. Pass both.
FRAME_KEY="NSWindow Frame CalendarWindow"; FRAME="200 150 2160 1150 0 0 2560 1410 "
WIN="<string>{\"screenName\":\"$SCREEN\",\"x\":200,\"y\":150,\"width\":2160,\"height\":1150}</string>"
democal() { : > $WORK/democal.out; : > $WORK/democal.err; open -W -n --stdout $WORK/democal.out --stderr $WORK/democal.err $BIN/DemoCal.app --args "$@"; cat $WORK/democal.out $WORK/democal.err; }
