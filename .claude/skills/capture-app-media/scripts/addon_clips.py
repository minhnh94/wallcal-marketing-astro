# Looping before/after clips for the Expert add-on page. Run: python3 -I addon_clips.py <addon_shots> <overlay_bin> <out_dir>
import os
import subprocess
import sys

SHOTS, OVERLAY, OUT = sys.argv[1], sys.argv[2], sys.argv[3]
FPS, HOLD, XF = 30, 1.9, 0.6
os.makedirs(f"{OUT}/tmp", exist_ok=True)

WINDOW = (4480, 2520, 320, 180)
MAIN = (3700, 2081, 1040, 220)
TIMES = (2000, 1125, 380, 900)
HEADER = (2400, 1350, 380, 280)

clips = {
    "weekly-agenda": (WINDOW, "Main calendar", [("month", "Month"), ("weekly", "Weekly agenda")]),
    "time-range": (MAIN, "Visible hours", [("weekly", "7:00 – 21:00"), ("weekly-9-18", "9:00 – 18:00")]),
    "days-to-show": (MAIN, "Days to show", [("weekly", "7 days"), ("weekly-3days", "3 days")]),
    "calendar-filtering": (WINDOW, "Calendars", [("month", "All calendars"), ("month-work", "Work only")]),
    "view-toggle": (WINDOW, "Layout", [("month", "Both panels"), ("month-nosidebar", "Hide sidebar"), ("month-nomain", "Hide main calendar")]),
    "time-format": (TIMES, "Time format", [("weekly", "24-hour"), ("weekly-12h", "12-hour")]),
    "week-start": (HEADER, "Week starts on", [("month", "Monday"), ("month-sunday", "Sunday")]),
}


def run(cmd):
    subprocess.run(cmd, check=True)


for name, ((cw, ch, cx, cy), label, states) in clips.items():
    seq = states + [states[0]]  # end on the first state so the loop is seamless
    inputs, parts = [], []
    for i, (img, value) in enumerate(seq):
        ov = f"{OUT}/tmp/{name}-{i}.png"
        run([OVERLAY, "caption", ov, label, value])
        dur = HOLD + XF if i < len(seq) - 1 else XF
        inputs += ["-loop", "1", "-t", f"{dur}", "-i", f"{SHOTS}/{img}.png", "-loop", "1", "-t", f"{dur}", "-i", ov]
        parts.append(f"[{2 * i}]crop={cw}:{ch}:{cx}:{cy},scale=1920:1080,setsar=1[b{i}];[{2 * i + 1}]scale=3072:1728[o{i}];[b{i}][o{i}]overlay=x=-576:y=-648,fps={FPS},format=yuv420p[s{i}]")
    chain, prev, offset = [], "s0", HOLD
    for i in range(1, len(seq)):
        chain.append(f"[{prev}][s{i}]xfade=transition=fade:duration={XF}:offset={offset:.2f}[x{i}]")
        prev, offset = f"x{i}", offset + HOLD
    fc = ";".join(parts + chain) + f";[{prev}]scale=1280:720:flags=lanczos[out]"
    total = HOLD * len(states)
    base = ["ffmpeg", "-loglevel", "error", "-y", *inputs, "-filter_complex", fc, "-map", "[out]", "-t", f"{total:.2f}", "-an"]
    run(base + ["-c:v", "libx264", "-crf", "25", "-preset", "slow", "-pix_fmt", "yuv420p", "-movflags", "+faststart", f"{OUT}/{name}.mp4"])
    run(base + ["-c:v", "libvpx-vp9", "-crf", "38", "-b:v", "0", "-row-mt", "1", "-cpu-used", "2", f"{OUT}/{name}.webm"])
    run(["ffmpeg", "-loglevel", "error", "-y", "-i", f"{OUT}/{name}.mp4", "-frames:v", "1", "-q:v", "4", f"{OUT}/{name}.jpg"])
    print(name, f"{total:.1f}s")
