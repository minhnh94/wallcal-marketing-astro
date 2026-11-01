#!/bin/zsh
# Undo the session: delete demo calendars, stop helpers, relaunch WallCal with no overrides.
source ${0:a:h}/env.sh
democal delete $WORK/state.json
pkill -x WallCal; pkill -x bgwin; sleep 1
open -n $APP --args -isFirstTimeLaunch '<false/>'; sleep 4; pkill -x WallCal
democal list | grep -c '^event-cal'
