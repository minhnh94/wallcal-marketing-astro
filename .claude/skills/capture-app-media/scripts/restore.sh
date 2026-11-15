#!/bin/zsh
# Undo the session: delete demo calendars, stop helpers, put back the settings saved before capturing.
source ${0:a:h}/env.sh
democal delete $WORK/state.json
pkill -x $PROC; pkill -x bgwin; sleep 1
# The Debug build shares its settings with an installed Setapp WallCal (same bundle id)
[[ -f $WORK/prefs-backup.plist ]] && defaults import app.minhnh.WallCal-setapp $WORK/prefs-backup.plist
democal list | grep -c '^event-cal'
