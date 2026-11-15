#!/usr/bin/env python3
"""Hero loop: the promo's story in ~10 s, silent, for the landing page hero.

hero_loop.py <promo render.mp4> <out.mp4>

Keeps every caption beat except the glass/clear/blurred one, and drops the WallCal title card and the end card (the
page already shows the name and the store buttons). Finds each caption in the render (white text in the caption band),
shows it for about 1.3 s, and runs the moves between captions at 3-4x. 1280x720, no audio.
"""
import re
import subprocess
import sys

FPS = 30
# The WallCal title card sits between the reveal shot (3 s) and the next beat (storyboard.ts REVEAL = 2 s). Both ends
# are the same still calendar, so jumping across it doesn't show.
TITLE = (2.95, 4.9)


def caption_runs(src):
    """(start, end) of each caption: frames where the caption band has white text."""
    out = subprocess.run(
        ['ffmpeg', '-loglevel', 'error', '-i', src, '-vf',
         "crop=1400:90:100:860,format=gray,lut=y='if(gt(val,235),255,0)',signalstats,"
         'metadata=print:key=lavfi.signalstats.YAVG:file=-', '-f', 'null', '-'],
        capture_output=True, text=True, check=True).stdout
    ts = [float(x) for x in re.findall(r'pts_time:([\d.]+)', out)]
    ys = [float(x) for x in re.findall(r'YAVG=([\d.]+)', out)]
    runs, cur = [], None
    for t, y in zip(ts, ys):
        if y > 1.2:
            cur = [cur[0] if cur else t, t]
        elif cur:
            runs.append(tuple(cur))
            cur = None
    if cur:
        runs.append(tuple(cur))
    return [r for r in runs if r[1] - r[0] > 0.3]


def schedule(src):
    """(source from, source to, seconds on screen) for each piece, in order."""
    runs = caption_runs(src)
    if len(runs) != 8:
        sys.exit(f'{src}: expected 8 captions (hook, wall, away, views, sidebar, anywhere, custom, glass), '
                 f'found {len(runs)}: {runs}')
    hook, wall, away, views, sidebar, anywhere, custom, _glass = runs
    return [
        (0.15, hook[1], 1.20),            # "Plans buried under windows?"
        (hook[1], wall[0], 0.35),         # the windows clear
        (wall[0], TITLE[0], 1.30),        # "Your calendar. Living on your wallpaper." (a still shot)
        (TITLE[1], away[0], 0.15),        # past the title card; the windows come back
        (away[0], away[1], 1.30),         # "Out of your way. Never out of mind."
        (away[1], views[0], 0.15),
        (views[0], views[1], 1.30),       # "Month to week. Zoom out. Go deep."
        (views[1], sidebar[0], 0.15),
        (sidebar[0], sidebar[1], 1.30),   # "Tap a date. Scroll the slate. Check it off."
        (sidebar[1], anywhere[0], 0.15),
        (anywhere[0], anywhere[1], 1.35), # "Add it here. Edit there. Anywhere."
        (anywhere[1], custom[0], 0.12),
        (custom[0], custom[1], 1.25),     # "Size it. Slice it. Make it yours." Then it loops.
    ]


def build(src, dst):
    segs = schedule(src)
    parts, frames = [f'[0:v]split={len(segs)}' + ''.join(f'[s{i}]' for i in range(len(segs)))], []
    for i, (a, b, on_screen) in enumerate(segs):
        n = round(on_screen * FPS)
        frames.append(n)
        speed = (b - a) / (n / FPS)
        parts.append(f'[s{i}]trim=start={a:.3f}:end={b:.3f},setpts=(PTS-STARTPTS)/{speed:.4f},fps={FPS},'
                     f'trim=end_frame={n},setpts=PTS-STARTPTS[v{i}]')
    parts.append(''.join(f'[v{i}]' for i in range(len(segs))) +
                 f'concat=n={len(segs)}:v=1:a=0,scale=1280:-2,format=yuv420p[out]')
    subprocess.run(['ffmpeg', '-loglevel', 'error', '-y', '-i', src, '-filter_complex', ';'.join(parts), '-map', '[out]',
                    '-an', '-c:v', 'libx264', '-crf', '26', '-preset', 'slow', '-movflags', '+faststart', dst], check=True)
    print(f'{dst}: {sum(frames) / FPS:.2f} s')


if __name__ == '__main__':
    build(sys.argv[1], sys.argv[2])
