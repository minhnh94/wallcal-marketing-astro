#!/bin/zsh
# Compile helpers into $WORK/bin, wrap democal as DemoCal.app (EventKit needs a bundle with usage strings),
# record the main display name, and optionally build WallCal (BUILD_APP=1).
source ${0:a:h}/env.sh
for t in sck bgwin overlay og; do swiftc -O $K/$t.swift -o $BIN/$t || exit 1; done
A=$BIN/DemoCal.app; rm -rf $A; mkdir -p $A/Contents/MacOS
cp $K/DemoCal-Info.plist $A/Contents/Info.plist
swiftc -O $K/democal.swift -o $A/Contents/MacOS/DemoCal && codesign -s - --force $A
swift -e 'import AppKit; print(NSScreen.main!.localizedName)' > $WORK/screen.txt
if [[ -n $BUILD_APP ]]; then
  xcodebuild -project ${WALLCAL_SRC:-$HOME/Self-help/Swift/WallCal}/WallCal.xcodeproj -scheme WallCal-setapp -configuration Debug \
    -derivedDataPath $WORK/dd -destination 'platform=macOS' build 2>&1 | grep -E 'error:|BUILD (SUCCEEDED|FAILED)'
fi
echo "tools in $BIN, screen: $(cat $WORK/screen.txt), app: $APP"
