---
name: capture-app-media
description: Recapture WallCal product media for this landing page — screenshots, hero intro video, Expert add-on clips, OG cards — from the real macOS app with demo calendar data over a branded backdrop. Use when the app UI changed, when asked to retake screenshots/videos/GIFs, or to regenerate social preview images.
---

# Capture WallCal media

Real captures of the running app, never mockups. Personal calendars stay hidden; a branded window replaces the user's wallpaper.

## Pieces (`scripts/`)

| File | Role |
|---|---|
| `env.sh` | Paths and window geometry. `WORK` (default `<repo>/.capture`, gitignored), `APP`, `SCREEN`. |
| `build-tools.sh` | Compiles the Swift helpers into `$WORK/bin` and wraps `democal` as an ad-hoc-signed `DemoCal.app`. `BUILD_APP=1` also builds WallCal (scheme `WallCal-setapp`, Debug) into `$WORK/dd`. |
| `democal.swift` | EventKit tool with modes `list`, `setup <state.json>` (creates the Work/Personal/Fitness calendars and fills the current month), `create`, `reminders`, `delete`. |
| `bgwin.swift` | Full-screen gradient window at desktop level −1, standing in for the wallpaper. The `pattern` arg adds rings, stripes and dots so the glass, transparent and blurred appearances look clearly different. |
| `sck.swift` | ScreenCaptureKit. `sck shot out.png` captures only the WallCal and bgwin windows at 2× (5120×2880 on a 2560×1440 display). `sck rec out.mov secs` records. |
| `launch.sh` | Relaunches WallCal showing only the demo calendars, with setting overrides as arguments. |
| `capture.sh` | Captures every state the site uses: month, weekly, nine add-on states, three pattern appearances, and the empty backdrop. |
| `export.sh` | Crops the captures into `public/my-assets/shots/*.jpg`. |
| `video.sh` | Renders caption overlays, `intro_video.py` (hero, ~35s) and `addon_clips.py` (7 looping clips), then copies MP4, WebM and posters into `public/my-assets/{video,addon}`. |
| `og.sh` / `og.swift` | Renders the 1200×630 social cards for en/de/ja/zh. |
| `restore.sh` | Deletes the demo calendars, stops the helpers and relaunches WallCal with no overrides. |

## Run

```bash
S=.claude/skills/capture-app-media/scripts
$S/build-tools.sh                          # add BUILD_APP=1 to compile the current WallCal source, or set APP=/path/WallCal.app
source $S/env.sh
democal list > $WORK/list.out              # BEFORE setup: these are the user's calendars that launch.sh hides
democal setup $WORK/state.json             # creates demo calendars + events, writes their ids
$S/capture.sh && $S/export.sh && $S/video.sh && $S/og.sh
$S/restore.sh
```

Then look at every output before committing: read the JPGs, and pull a few frames from each video with `ffmpeg -vf select=…,tile`.

## Gotchas (all hit in practice)

- **Ask first.** This drives the user's real desktop and calendar database. Get their go-ahead. The first `DemoCal.app` run triggers the macOS Calendars/Reminders permission prompts, and so does every `build-tools.sh` run, because re-signing the bundle resets its access. A `democal` call that seems to hang is waiting on those prompts: approve them yourself with computer use instead of handing them back to the user. Calendar access from a bare CLI binary is refused, which is why the bundle and `open` exist.
- **Personal data.** Never capture before the real calendars are hidden. Delete any capture that shows real events, names or the user's wallpaper (it may be copyrighted art).
- **Reminders.** The "On My Mac" source rejects reminder lists ("That account does not support reminders"). `democal reminders` therefore creates its "Errands" list in the default reminders account (usually iCloud), which syncs to the user's devices until `restore.sh` deletes it. Ask before running it. Without it, the sidebar's event list shows no reminders.
- **Overrides.** `-key value` arguments land in the argument domain as strings. Wrap typed values in plist XML (`'<true/>'`, `'<integer>7</integer>'`). Window frame overrides are ignored; place the window with `-designatedWindowScreen "<string>{json}</string>"` (see `WIN` in `env.sh`).
- **Settings keys.** `calendarViewMode` monthly|weekly, `backgroundAppearance` nativeGlass|transparent|blurred, `isWeekViewNext7Days`, `agendaViewStartTime`/`EndTime`, `numberOfDaysInWeekView`, `newWeekStartsOn` (1 = Sun, 2 = Mon), `IsTimeFormat24Hour`, `isHidingTodolistView`, `isHidingCalendarView`, `CalendarDisplayState`/`ReminderDisplayState` (dict of id → bool). Check the app's Defaults keys if a shot looks unchanged.
- **bgwin.**
  - Start it with `nohup … & disown`. A child process left on the shell hangs the Bash tool.
  - The first capture after a restart can come out black. `capture.sh` takes a throwaway `_warm.png` first.
  - `sck` matches windows by owning app name ("WallCal", "bgwin"), not window title.
- **Crops.** The crop values in `export.sh`, `intro_video.py` and `addon_clips.py` assume the `WIN` frame on a 2560×1440@2× main display. On another display, or if the app layout changes, re-derive them from a downscaled preview of the raw PNGs. As of Nov 2026 the sidebar sits inside the main capture, left of the month grid, and the month/weekly crops are stale (only `sidebar.jpg` was re-derived). `sidebar.jpg` is 2:3 to match its bento card: it runs from the month name through the mini calendar into the event list, leaving out the big date header, because the whole sidebar is about 1:2.2.
- **Text size.** The app scales text with window size (relative to 1100×700, clamped 1–2.5×, times `calendarTextSize`). Small windows give tiny text on the site, so keep the large `WIN`.
- **Encoders.** Local ffmpeg has `libx264` and `libvpx-vp9` but no `libwebp`, so the site uses MP4 + WebM `<video>` instead of GIF/WebP.
- **Localized media.** Captures are English UI. For a localized set, add (untested) `-AppleLanguages '(de)'` (or ja, zh-Hans) to the launch args, write to a per-locale folder, and give the overlay captions in `video.sh` / `addon_clips.py` translated text.
- **Restore.** Note the user's WallCal window frame before you start, and relaunch with that `-designatedWindowScreen` at the end. Confirm the calendar and reminder lists match the pre-setup `list.out` (diff the sorted `-cal` lines of a fresh `democal list`). Also tell the user that DemoCal still has Calendars/Reminders access in System Settings; they remove it themselves.
