#!/bin/zsh
# launch.sh [-key value ...]: relaunch WallCal showing only the demo calendars, plus any setting overrides.
# Overrides go through NSArgumentDomain; typed values must be plist XML: '<true/>', '<integer>7</integer>', '<string>…</string>'.
# ONLY_FIRST=1 shows just the first demo calendar ("Work").
source ${0:a:h}/env.sh
ids() { python3 -I -c "import json,sys;print(' '.join(json.load(open(sys.argv[1]))[sys.argv[2]]))" $WORK/state.json $1; }
cal="<dict>"; for id in $(awk '$1=="event-cal"{print $2}' $WORK/list.out); do cal+="<key>$id</key><false/>"; done
i=0; for id in $(ids events); do i=$((i+1)); [[ -n $ONLY_FIRST && $i -gt 1 ]] && v='<false/>' || v='<true/>'; cal+="<key>$id</key>$v"; done; cal+="</dict>"
rem="<dict>"; for id in $(awk '$1=="reminder-cal"{print $2}' $WORK/list.out); do rem+="<key>$id</key><false/>"; done
for id in $(ids reminders); do rem+="<key>$id</key><true/>"; done; rem+="</dict>"
pkill -x WallCal; sleep 1
open -n $APP --args -isFirstTimeLaunch '<false/>' -CalendarDisplayState "$cal" -ReminderDisplayState "$rem" "$@"
sleep 4
