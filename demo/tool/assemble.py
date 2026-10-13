"""Joins the rendered scene segments with short crossfades and writes the
final MP4s.

    python3 assemble.py OUT_DIR [--voiceover FILE] [--cues T,T,...] [--no-bed]

Reads OUT_DIR/segments/*.mp4 (one per scene in SCENES, each filmed with
spare footage past its planned end) and writes OUT_DIR/pinne-demo.mp4.

Without a voiceover every scene keeps its planned length and the film
carries the self-generated music bed.

With --voiceover (or FILM_VOICEOVER set to a file), the narration of
demo/narration.txt is cut into its scene paragraphs at the pauses between
them, and each scene runs as long as its paragraph: it is trimmed into its
spare footage or held on its last frame, never shorter than the part that
must be seen. Each paragraph starts as its scene fades in. pinne-demo.mp4
then carries the narration, loudness-normalised, over the music ducked low
under it (--no-bed: no music), and pinne-demo-silent.mp4 the same cut with
the music only. --cues gives the voiceover times (seconds) where scenes 2
to 9 begin, if the detected ones are wrong. The film never reaches 2:00: a
narration too long for that is sped up by up to 1.2x first.
"""

import argparse
import json
import os
import pathlib
import re
import subprocess
import sys

FADE = 0.5
LIMIT = 119.0
# Seconds after a scene starts fading in before its narration begins.
LEAD = 0.3
# The closing card holds this long after the last words.
CLOSE_HOLD = 2.5
# The most a long narration is sped up to fit.
MAX_TEMPO = 1.2
TOOL = pathlib.Path(__file__).resolve().parent
NARRATION = TOOL.parent / "narration.txt"

# Scene, planned length, the shortest it may run (its last moment that must
# be seen), and the narration paragraphs it carries (0-based).
SCENES = [
    ("01_hook", 16.0, 14.8, [0, 1, 2]),
    ("02_capture", 13.0, 11.5, [3]),
    ("03_organize", 13.5, 10.5, [4]),
    ("04_search", 10.0, 7.5, [5]),
    ("05_today", 12.0, 9.5, [6]),
    ("06_planner", 10.0, 9.4, [7]),
    ("07_progress", 13.0, 12.0, [8]),
    ("08_serverpod", 15.0, 13.5, [9]),
    ("09_close", 7.0, 4.5, [10]),
]


def duration(ffmpeg, path):
    probe = subprocess.run([ffmpeg, "-i", str(path)], capture_output=True, text=True).stderr
    stamp = probe.split("Duration: ")[1].split(",")[0]
    h, m, s = stamp.split(":")
    return int(h) * 3600 + int(m) * 60 + float(s)


def silences(ffmpeg, path):
    log = subprocess.run([ffmpeg, "-i", str(path), "-af", "silencedetect=noise=-40dB:d=0.2",
                          "-f", "null", "-"], capture_output=True, text=True).stderr
    starts = [float(x) for x in re.findall(r"silence_start: ([\d.]+)", log)]
    ends = [float(x) for x in re.findall(r"silence_end: ([\d.]+)", log)]
    return list(zip(starts, ends))


def paragraph_weights():
    """Rough speaking time of each narration paragraph, in arbitrary units."""
    text = NARRATION.read_text()
    weights = []
    for para in [p for p in text.split("\n\n") if p.strip()]:
        pauses = sum(float(x) for x in re.findall(r'break time="([\d.]+)s"', para))
        words = len(re.sub(r"<[^>]+>", " ", para).split())
        weights.append(words / 2.6 + pauses + 0.4)
    return weights


def scene_cues(ffmpeg, voice, length):
    """Where scenes 2..9 begin in the voiceover: at the pause nearest the
    point the paragraph lengths predict, preferring the longest pause."""
    weights = paragraph_weights()
    total = sum(weights)
    quiet = silences(ffmpeg, voice)
    cues, before = [], 0.0
    for _, _, _, paras in SCENES[1:]:
        expected = sum(weights[: paras[0]]) / total * length
        window = max(3.0, 0.06 * length)
        near = [(s, e) for s, e in quiet if abs((s + e) / 2 - expected) <= window and e - 0.12 > before + 1]
        if near:
            s, e = max(near, key=lambda q: (round(q[1] - q[0], 1), -abs((q[0] + q[1]) / 2 - expected)))
            cue = e - 0.12
        else:
            cue = max(expected, before + 1)
        cues.append(round(cue, 3))
        before = cue
    return cues


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("out")
    parser.add_argument("--voiceover", default=os.environ.get("FILM_VOICEOVER") or None)
    parser.add_argument("--cues", help="comma-separated voiceover times where scenes 2-9 begin")
    parser.add_argument("--no-bed", action="store_true", help="no music under the voice")
    parser.add_argument("--bed", action="store_true", help=argparse.SUPPRESS)  # the default now
    args = parser.parse_args()

    out = pathlib.Path(args.out)
    ffmpeg = os.environ.get("FFMPEG", "ffmpeg")
    segments = [out / "segments" / f"{name}.mp4" for name, *_ in SCENES]
    missing = [s.name for s in segments if not s.is_file()]
    if missing:
        sys.exit(f"missing segments: {', '.join(missing)}")
    rendered = [duration(ffmpeg, s) for s in segments]

    voice = pathlib.Path(args.voiceover) if args.voiceover else None
    recording, tempo = voice, 1.0
    if voice is not None and not voice.is_file():
        sys.exit(f"voiceover not found: {voice}")

    # slots[i]: from scene i starting to fade in until scene i+1 does.
    if voice is None:
        cues = None
        slots = [planned - FADE for _, planned, _, _ in SCENES[:-1]]
        last = SCENES[-1][1]
    else:
        spoken = duration(ffmpeg, voice)
        room = LIMIT - CLOSE_HOLD - 1.5
        if spoken > room and not args.cues:
            # A slow read is sped up a little, as ElevenLabs' Speed would.
            tempo = spoken / room
            if tempo > MAX_TEMPO:
                sys.exit(f"voiceover runs {spoken:.1f} s; even at {MAX_TEMPO}x it would not fit in {LIMIT} s")
            faster = out / "voiceover-fitted.wav"
            subprocess.run([ffmpeg, "-y", "-loglevel", "error", "-i", str(voice),
                            "-af", f"atempo={tempo:.4f}", str(faster)], check=True)
            print(f"voiceover sped up {tempo:.3f}x to fit", file=sys.stderr)
            voice, spoken = faster, duration(ffmpeg, faster)
        cues = ([float(c) for c in args.cues.split(",")] if args.cues
                else scene_cues(ffmpeg, voice, spoken))
        if len(cues) != len(SCENES) - 1 or cues != sorted(cues):
            sys.exit(f"need {len(SCENES) - 1} increasing cues, got {cues}")
        starts = [0.0, *cues]
        paragraph = [b - a for a, b in zip(starts, starts[1:])]
        slots = [max(p, core - FADE) for p, (_, _, core, _) in zip(paragraph, SCENES)]
        last = max(spoken - starts[-1] + LEAD + CLOSE_HOLD, SCENES[-1][2])
        over = sum(slots) + last - LIMIT
        if over > 0:
            # Give back held time first, then the closing hold.
            held = [s - p for s, p in zip(slots, paragraph)]
            for i in sorted(range(len(slots)), key=lambda i: -held[i]):
                take = min(max(held[i], 0), over)
                slots[i] -= take
                over -= take
            last = max(last - over, SCENES[-1][2])
    used = [s + FADE for s in slots] + [last]
    length = sum(slots) + last
    if length >= LIMIT + 0.01:
        sys.exit(f"film would run {length:.1f} s; the limit is {LIMIT} s")

    inputs, chain = [], []
    for i, (seg, want, have) in enumerate(zip(segments, used, rendered)):
        inputs += ["-i", str(seg)]
        pad = f"tpad=stop_mode=clone:stop_duration={want - have + 0.1:.3f}," if want > have - 0.02 else ""
        chain.append(f"[{i}:v]{pad}trim=0:{want:.3f},setpts=PTS-STARTPTS,fps=30[s{i}]")
    last_label, offset = "[s0]", 0.0
    for i in range(1, len(segments)):
        offset += slots[i - 1]
        chain.append(f"{last_label}[s{i}]xfade=transition=fade:duration={FADE}:offset={offset:.3f}[v{i}]")
        last_label = f"[v{i}]"
    chain.append(f"{last_label}fade=t=in:st=0:d=0.4,fade=t=out:st={length - 0.6:.3f}:d=0.6,format=yuv420p[v]")

    picture = out / "picture.mp4"
    video = ["-c:v", "libx264", "-preset", "slow", "-crf", "17", "-r", "30",
             "-pix_fmt", "yuv420p", "-movflags", "+faststart"]
    subprocess.run([ffmpeg, "-y", "-loglevel", "error", *inputs,
                    "-filter_complex", ";".join(chain), "-map", "[v]", *video, str(picture)], check=True)

    music = out / "music.wav"
    subprocess.run([sys.executable, "-I", str(TOOL / "make_music.py"), str(music), f"{length:.3f}"], check=True)
    audio = ["-c:a", "aac", "-b:a", "192k", "-ar", "48000"]

    def mux(graph, extra, target):
        subprocess.run([ffmpeg, "-y", "-loglevel", "error", "-i", str(picture), *extra,
                        "-filter_complex", graph, "-map", "0:v", "-map", "[a]",
                        "-c:v", "copy", *audio, "-t", f"{length:.3f}", str(target)], check=True)

    final = out / "pinne-demo.mp4"
    silent = out / "pinne-demo-silent.mp4"
    if voice is None:
        mux("[1:a]anull[a]", ["-i", str(music)], final)
        silent.unlink(missing_ok=True)
    else:
        # Each scene's paragraph, placed where its scene fades in.
        starts = [0.0, *cues, spoken]
        scene_at = [sum(slots[:i]) for i in range(len(SCENES))]
        parts = []
        for i in range(len(SCENES)):
            delay = int((scene_at[i] + LEAD) * 1000)
            parts.append(f"[vo{i}]atrim={starts[i]:.3f}:{starts[i + 1]:.3f},asetpts=PTS-STARTPTS,"
                         f"adelay={delay}|{delay}[p{i}]")
        split = "".join(f"[vo{i}]" for i in range(len(SCENES)))
        narration = (f"[1:a]aresample=48000,aformat=channel_layouts=stereo,"
                     f"loudnorm=I=-16:TP=-1.5:LRA=11,asplit={len(SCENES)}{split};"
                     + ";".join(parts) + ";"
                     + "".join(f"[p{i}]" for i in range(len(SCENES)))
                     + f"amix=inputs={len(SCENES)}:normalize=0,apad,atrim=0:{length:.3f}")
        if args.no_bed:
            mux(f"{narration}[a]", ["-i", str(voice)], final)
        else:
            mux(f"{narration},asplit[vo][key];[2:a]volume=-9dB[m];"
                "[m][key]sidechaincompress=threshold=0.03:ratio=10:attack=15:release=450[bed];"
                "[vo][bed]amix=inputs=2:duration=first:normalize=0[a]",
                ["-i", str(voice), "-i", str(music)], final)
        mux("[1:a]anull[a]", ["-i", str(music)], silent)
    picture.unlink()
    (out / "voiceover-fitted.wav").unlink(missing_ok=True)
    report = {"seconds": round(length, 2), "voiceover": str(recording) if recording else None,
              "voice_tempo": round(tempo, 3),
              "voice_cues": cues,
              "scenes": [{"scene": name, "starts": round(sum(slots[:i]), 2), "seconds": round(u, 2)}
                         for i, ((name, *_), u) in enumerate(zip(SCENES, used))]}
    (out / "cut.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report))


if __name__ == "__main__":
    main()
