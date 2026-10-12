"""Joins the rendered scene segments with short crossfades and writes the
final MP4s.

    python3 assemble.py OUT_DIR [--voiceover FILE] [--bed]

Reads OUT_DIR/segments/*.mp4 in name order and writes
OUT_DIR/pinne-demo-silent.mp4 and OUT_DIR/pinne-demo.mp4.

Without a voiceover, pinne-demo.mp4 carries the self-generated music bed.
With --voiceover (or FILM_VOICEOVER set to a file), pinne-demo.mp4 carries
the recorded narration, loudness-normalised, with no music under it; --bed
adds the music bed far below the voice. If the narration runs longer than
the film, the closing card is held until it ends. The video is never cut
past 1:55.
"""

import argparse
import json
import os
import pathlib
import subprocess
import sys

FADE = 0.5
LIMIT = 115.0
TOOL = pathlib.Path(__file__).resolve().parent


def duration(ffmpeg, path):
    probe = subprocess.run([ffmpeg, "-i", str(path)], capture_output=True, text=True).stderr
    stamp = probe.split("Duration: ")[1].split(",")[0]
    h, m, s = stamp.split(":")
    return int(h) * 3600 + int(m) * 60 + float(s)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("out")
    parser.add_argument("--voiceover", default=os.environ.get("FILM_VOICEOVER") or None)
    parser.add_argument("--bed", action="store_true", help="quiet music bed under the voice")
    args = parser.parse_args()

    out = pathlib.Path(args.out)
    ffmpeg = os.environ.get("FFMPEG", "ffmpeg")
    segments = sorted((out / "segments").glob("*.mp4"))
    lengths = [duration(ffmpeg, s) for s in segments]
    total = sum(lengths) - FADE * (len(segments) - 1)

    voice = pathlib.Path(args.voiceover) if args.voiceover else None
    if voice is not None and not voice.is_file():
        sys.exit(f"voiceover not found: {voice}")
    hold = 0.0
    if voice is not None:
        hold = max(0.0, min(duration(ffmpeg, voice) + 0.8, LIMIT) - total)
    length = total + hold

    inputs = []
    for s in segments:
        inputs += ["-i", str(s)]
    chain, last, offset = [], "[0:v]", 0.0
    for i in range(1, len(segments)):
        offset += lengths[i - 1] - FADE
        label = f"[v{i}]"
        chain.append(f"{last}[{i}:v]xfade=transition=fade:duration={FADE}:offset={offset:.3f}{label}")
        last = label
    pad = f"tpad=stop_mode=clone:stop_duration={hold:.3f}," if hold > 0 else ""
    chain.append(f"{last}{pad}fade=t=in:st=0:d=0.4,fade=t=out:st={length - 0.6:.3f}:d=0.6,format=yuv420p[v]")

    video = ["-c:v", "libx264", "-preset", "slow", "-crf", "17", "-r", "30",
             "-pix_fmt", "yuv420p", "-movflags", "+faststart"]
    silent = out / "pinne-demo-silent.mp4"
    subprocess.run([ffmpeg, "-y", "-loglevel", "error", *inputs,
                    "-filter_complex", ";".join(chain), "-map", "[v]", *video, str(silent)], check=True)

    music = out / "music.wav"
    if voice is None or args.bed:
        subprocess.run([sys.executable, "-I", str(TOOL / "make_music.py"), str(music), f"{length:.3f}"],
                       check=True)
    final = out / "pinne-demo.mp4"
    audio = ["-c:a", "aac", "-b:a", "192k", "-ar", "48000"]
    if voice is None:
        subprocess.run([ffmpeg, "-y", "-loglevel", "error", "-i", str(silent), "-i", str(music),
                        "-map", "0:v", "-map", "1:a", "-c:v", "copy", *audio,
                        "-shortest", str(final)], check=True)
    else:
        narration = (f"[1:a]aresample=48000,aformat=channel_layouts=stereo,"
                     f"loudnorm=I=-16:TP=-1.5:LRA=11,apad,atrim=0:{length:.3f}")
        if args.bed:
            graph = (f"{narration}[vo];[2:a]volume=-26dB[bed];"
                     f"[vo][bed]amix=inputs=2:duration=first:normalize=0[a]")
            extra = ["-i", str(music)]
        else:
            graph = f"{narration}[a]"
            extra = []
        subprocess.run([ffmpeg, "-y", "-loglevel", "error", "-i", str(silent), "-i", str(voice), *extra,
                        "-filter_complex", graph, "-map", "0:v", "-map", "[a]",
                        "-c:v", "copy", *audio, str(final)], check=True)
    print(json.dumps({"segments": [s.name for s in segments], "seconds": round(length, 2),
                      "voiceover": str(voice) if voice else None}))


if __name__ == "__main__":
    main()
