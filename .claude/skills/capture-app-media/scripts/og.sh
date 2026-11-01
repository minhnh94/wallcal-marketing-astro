#!/bin/zsh
# Render the 1200x630 social cards from shots/month.jpg. Headline is 3 parts: before, accent, after; \n breaks lines.
source ${0:a:h}/env.sh
render() { # out headA headEm headB tagline size [cjkFontPostScriptName]
  $BIN/og $ASSETS/app-icon.png $ASSETS/shots/month.jpg $WORK/og.png "$2" "$3" "$4" "$5" "$6" ${7:+"$7"} &&
  sips -z 630 1200 -s format jpeg -s formatOptions 82 $WORK/og.png --out $ASSETS/$1 >/dev/null
}
render og.jpg    'Your calendar,\n' 'right on' ' your\nwallpaper.' 'Free on the Mac App Store · Included with Setapp' 62
render og-de.jpg 'Dein Kalender,\n' 'direkt auf' ' dem\nHintergrundbild.' 'Kostenlos im Mac App Store · Inklusive mit Setapp' 54
render og-ja.jpg 'カレンダーを、\n' '壁紙の上に。' '' 'Mac App Storeで無料 · Setappでも利用可能' 72 HiraginoSans-W6
render og-zh.jpg '你的日历，\n' '就在壁纸上。' '' 'Mac App Store 免费下载 · Setapp 已收录' 76 PingFangSC-Semibold
