# Build the WallCal intro video from real 5K captures. Run with: python3 -I intro_video.py <shots_dir> <out_dir>
# Expects <out_dir> to hold the overlay PNGs (title, c1..c5, end) from video.sh.
import subprocess
import sys

SHOTS, OUT = sys.argv[1], sys.argv[2]
FPS = 30
SW, SH = 5120, 2880
XF = 0.7  # crossfade seconds


def rect(x, y, w):
    return (x, y, w, w * 9 / 16)


FULL = rect(0, 0, SW)


def ease(a, b):
    # Cosine ease between a and b over the scene; `on` is zoompan's output frame index.
    return f"({a}+({b}-({a}))*(1-cos(PI*on/(N-1)))/2)"


def scene(name, img, dur, start, end, overlay=None):
    n = int(dur * FPS)
    (x0, y0, w0, _), (x1, y1, w1, _) = start, end
    w = ease(w0, w1).replace("N", str(n))
    zp = (
        f"zoompan=z='{SW}/{w}':x='{ease(x0, x1).replace('N', str(n))}':y='{ease(y0, y1).replace('N', str(n))}'"
        f":d={n}:s=1920x1080:fps={FPS}"
    )
    cmd = ["ffmpeg", "-loglevel", "error", "-y", "-i", f"{SHOTS}/{img}"]
    if overlay:
        cmd += ["-loop", "1", "-t", str(dur), "-i", overlay]
        fc = (
            f"[0]{zp},format=yuv420p[v];"
            f"[1]format=rgba,fade=in:st=0.5:d=0.5:alpha=1,fade=out:st={dur - 0.9}:d=0.5:alpha=1[o];"
            f"[v][o]overlay=shortest=1,format=yuv420p"
        )
    else:
        fc = f"[0]{zp},format=yuv420p"
    cmd += ["-filter_complex", fc, "-t", str(dur), "-r", str(FPS), "-c:v", "libx264", "-crf", "14", "-preset", "fast", f"{OUT}/{name}.mp4"]
    subprocess.run(cmd, check=True)
    return name, dur


window = rect(200, 150, 4720)          # WallCal window with a little wallpaper around it
sidebar = rect(330, 240, 1800)         # sidebar top + start of the month grid
weekly_a = rect(320, 200, 3600)
weekly_b = rect(1300, 560, 3600)

scenes = [
    scene("s1", "backdrop.png", 3.6, FULL, rect(128, 72, SW - 256), "title.png"),
    scene("s2", "month-nativeGlass.png", 6.0, FULL, window, "c1.png"),
    scene("s3", "month-nativeGlass.png", 5.6, window, sidebar, "c2.png"),
    scene("s4", "weekly-nativeGlass.png", 6.0, weekly_a, weekly_b, "c3.png"),
    scene("s5a", "pattern-nativeGlass.png", 3.0, rect(2900, 1480, 2100), rect(3000, 1540, 2000), "c4a.png"),
    scene("s5b", "pattern-transparent.png", 3.0, rect(3000, 1540, 2000), rect(3080, 1580, 1920), "c4b.png"),
    scene("s5c", "pattern-blurred.png", 3.0, rect(3080, 1580, 1920), rect(3160, 1620, 1840), "c4c.png"),
    scene("s6", "month-nativeGlass.png", 5.2, window, FULL, "c5.png"),
    scene("s7", "backdrop.png", 4.6, rect(128, 72, SW - 256), FULL, "end.png"),
]

# Chain crossfades.
inputs, filters, offset, prev = [], [], 0.0, "0:v"
for i, (name, dur) in enumerate(scenes):
    inputs += ["-i", f"{OUT}/{name}.mp4"]
    if i == 0:
        offset = dur - XF
        continue
    label = f"x{i}"
    filters.append(f"[{prev}][{i}:v]xfade=transition=fade:duration={XF}:offset={offset:.3f}[{label}]")
    prev = label
    offset += dur - XF
filters.append(f"[{prev}]fade=in:st=0:d=0.4,format=yuv420p[out]")
fc = ";".join(filters)

base = ["ffmpeg", "-loglevel", "error", "-y", *inputs, "-filter_complex", fc, "-map", "[out]", "-r", str(FPS), "-an"]
subprocess.run(base + ["-c:v", "libx264", "-profile:v", "high", "-crf", "24", "-preset", "slow", "-movflags", "+faststart", "-pix_fmt", "yuv420p", f"{OUT}/wallcal-intro.mp4"], check=True)
subprocess.run(base + ["-c:v", "libvpx-vp9", "-crf", "36", "-b:v", "0", "-row-mt", "1", "-deadline", "good", "-cpu-used", "2", f"{OUT}/wallcal-intro.webm"], check=True)
print("total", round(offset + XF, 2), "s")
