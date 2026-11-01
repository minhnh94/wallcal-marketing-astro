#!/bin/zsh
# Capture every state the site uses into $SHOTS (5120x2880 PNGs, WallCal + backdrop only).
source ${0:a:h}/env.sh
bg() { pkill -x bgwin; sleep 0.5; (cd $BIN && nohup ./bgwin "$@" >/dev/null 2>&1 </dev/null & disown); sleep 2; $BIN/sck shot $SHOTS/_warm.png >/dev/null; }
shot() { local out=$1; shift; $K/launch.sh "${base[@]}" "$@" && $BIN/sck shot $out; }
base=(-backgroundAppearance nativeGlass -designatedWindowScreen "$WIN" -newWeekStartsOn '<integer>2</integer>' -IsTimeFormat24Hour '<true/>')
wk=(-calendarViewMode weekly -isWeekViewNext7Days '<true/>' -agendaViewStartTime '<integer>7</integer>' -agendaViewEndTime '<integer>21</integer>' -numberOfDaysInWeekView '<integer>7</integer>')

bg
pkill -x WallCal; sleep 1; $BIN/sck shot $SHOTS/backdrop.png       # empty backdrop for the video title/end cards
shot $SHOTS/month-nativeGlass.png -calendarViewMode monthly
shot $SHOTS/weekly-nativeGlass.png "${wk[@]}"

A=$SHOTS/addon                                                       # Expert add-on before/after states
shot $A/month.png -calendarViewMode monthly
shot $A/weekly.png "${wk[@]}"
shot $A/weekly-9-18.png "${wk[@]}" -agendaViewStartTime '<integer>9</integer>' -agendaViewEndTime '<integer>18</integer>'
shot $A/weekly-3days.png "${wk[@]}" -numberOfDaysInWeekView '<integer>3</integer>'
shot $A/weekly-12h.png "${wk[@]}" -IsTimeFormat24Hour '<false/>'
ONLY_FIRST=1 shot $A/month-work.png -calendarViewMode monthly
shot $A/month-nosidebar.png -calendarViewMode monthly -isHidingTodolistView '<true/>'
shot $A/month-nomain.png -calendarViewMode monthly -isHidingCalendarView '<true/>'
shot $A/month-sunday.png -calendarViewMode monthly -newWeekStartsOn '<integer>1</integer>'

bg pattern                                                           # busy backdrop so the 3 appearances differ visibly
for a in nativeGlass transparent blurred; do shot $SHOTS/pattern-$a.png -calendarViewMode monthly -backgroundAppearance $a; done
