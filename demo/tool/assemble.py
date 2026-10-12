"""Joins the rendered scene segments with short crossfades, adds the
self-generated music bed, and writes the final MP4s.

    python3 assemble.py OUT_DIR

Reads OUT_DIR/segments/*.mp4 in name order and writes
OUT_DIR/pinne-demo.mp4 (with music) and OUT_DIR/pinne-demo-silent.mp4.
"""

import json
import os
import pathlib
import subprocess
import sys

FADE = 0.5
TOOL = pathlib.Path(__file__).resolve().parent


def duration(ffmpeg, path):
    probe = subprocess.run([ffmpeg, "-i", str(path)], capture_output=True, text=True).stderr
    stamp = probe.split("Duration: ")[1].split(",")[0]
    h, m, s = stamp.split(":")
    return int(h) * 3600 + int(m) * 60 + float(s)


def main():
    out = pathlib.Path(sys.argv[1])
    ffmpeg = os.environ.get("FFMPEG", "ffmpeg")
    segments = sorted((out / "segments").glob("*.mp4"))
    lengths = [duration(ffmpeg, s) for s in segments]
    total = sum(lengths) - FADE * (len(segments) - 1)

    inputs = []
    for s in segments:
        inputs += ["-i", str(s)]
    chain, last, offset = [], "[0:v]", 0.0
    for i in range(1, len(segments)):
        offset += lengths[i - 1] - FADE
        label = f"[v{i}]"
        chain.append(f"{last}[{i}:v]xfade=transition=fade:duration={FADE}:offset={offset:.3f}{label}")
        last = label
    chain.append(f"{last}fade=t=in:st=0:d=0.4,fade=t=out:st={total - 0.6:.3f}:d=0.6,format=yuv420p[v]")

    music = out / "music.wav"
    subprocess.run([sys.executable, "-I", str(TOOL / "make_music.py"), str(music), f"{total:.3f}"], check=True)
    video = ["-c:v", "libx264", "-preset", "slow", "-crf", "17", "-r", "30",
             "-pix_fmt", "yuv420p", "-movflags", "+faststart"]
    silent = out / "pinne-demo-silent.mp4"
    subprocess.run([ffmpeg, "-y", "-loglevel", "error", *inputs,
                    "-filter_complex", ";".join(chain), "-map", "[v]", *video, str(silent)], check=True)
    subprocess.run([ffmpeg, "-y", "-loglevel", "error", "-i", str(silent), "-i", str(music),
                    "-map", "0:v", "-map", "1:a", "-c:v", "copy", "-c:a", "aac", "-b:a", "192k",
                    "-shortest", str(out / "pinne-demo.mp4")], check=True)
    print(json.dumps({"segments": [s.name for s in segments], "seconds": round(total, 2)}))


if __name__ == "__main__":
    main()
