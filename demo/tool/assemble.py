"""Joins the rendered scene segments with short crossfades and writes the
final MP4s.

    python3 assemble.py OUT_DIR [--voiceover FILE] [--cues T,T,...] [--no-bed]

Reads OUT_DIR/segments/*.mp4 (one per scene in SCENES, each filmed with
spare footage past its last essential moment) and OUT_DIR/coords/*.json
(each app scene's real length, cursor steps and callouts, written by the
film), and writes OUT_DIR/pinne-demo.mp4, cut.json and
cursor-coordinates.md.

Without a voiceover every scene keeps its filmed length and the film
carries the music bed alone.

With --voiceover (or FILM_VOICEOVER set to a file), the narration of
demo/narration.txt is cut at the pauses between its paragraphs into the
blocks listed in SCENES, and each block starts at its own moment in its
scene, so lines land on what they describe. A scene runs as long as its
footage or its narration needs, whichever is longer: it is trimmed into its
spare footage or held on its last frame. pinne-demo.mp4 then carries the
narration over the music, ducked under the voice (--no-bed: no music), and
pinne-demo-silent.mp4 the same cut with the music only. Both carry soft
clicks where the cursor clicks. --cues gives the voiceover times (seconds)
where the blocks after the first begin (see BLOCKS), if the detected ones
are wrong. The film never reaches 2:00: a narration too long for that is
sped up by up to 1.2x.
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
# The closing card holds this long after the last words.
CLOSE_HOLD = 2.5
# The most a long narration is sped up to fit.
MAX_TEMPO = 1.2
# Loudness: the finished mix, the music alone, and the music before it is
# ducked under the voice (LUFS).
TARGET = -16.0
SILENT_TARGET = -18.0
BED = -25.0
TOOL = pathlib.Path(__file__).resolve().parent
NARRATION = TOOL.parent / "narration.txt"

# Scene, its length if the film wrote no coords for it, and its narration
# blocks: (first paragraph, seconds into the scene it starts). A block runs
# on to the next block's first paragraph.
SCENES = [
    # The hook's last line waits for the "Why not just use bookmarks?" card.
    ("01_hook", 21.5, [(0, 0.3), (2, 15.4)]),
    ("02_capture", 21.0, [(3, 0.5)]),
    ("03_organize", 15.0, [(4, 1.8)]),
    ("04_search", 9.0, [(5, 1.0)]),
    ("05_today", 8.5, [(6, 0.3)]),
    ("06_planner", 9.0, [(7, 0.3)]),
    ("07_progress", 14.0, [(8, 0.3)]),
    ("08_serverpod", 16.6, [(9, 0.3)]),
    ("09_close", 7.0, [(10, 0.3)]),
]
BLOCKS = [(i, para, at) for i, (_, _, blocks) in enumerate(SCENES) for para, at in blocks]


def run(args, **kw):
    return subprocess.run(args, check=True, **kw)


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


def loudness(ffmpeg, path):
    """Integrated loudness, loudness range and true peak of a file."""
    log = subprocess.run([ffmpeg, "-hide_banner", "-i", str(path), "-af",
                          "ebur128=peak=true", "-f", "null", "-"],
                         capture_output=True, text=True).stderr
    summary = log[log.rindex("Summary:"):]
    return {
        "lufs": float(re.search(r"I:\s+(-?[\d.]+) LUFS", summary).group(1)),
        "lra": float(re.search(r"LRA:\s+(-?[\d.]+) LU", summary).group(1)),
        "true_peak_dbfs": float(re.search(r"Peak:\s+(-?[\d.inf]+) dBFS", summary).group(1)),
    }


def paragraph_weights():
    """Rough speaking time of each narration paragraph, in arbitrary units."""
    text = NARRATION.read_text()
    weights = []
    for para in [p for p in text.split("\n\n") if p.strip()]:
        pauses = sum(float(x) for x in re.findall(r'break time="([\d.]+)s"', para))
        words = len(re.sub(r"<[^>]+>", " ", para).split())
        weights.append(words / 2.6 + pauses + 0.4)
    return weights


def block_cues(ffmpeg, voice, length):
    """Where each block after the first begins in the voiceover: at the
    pause nearest the point the paragraph lengths predict, preferring the
    longest pause."""
    weights = paragraph_weights()
    total = sum(weights)
    quiet = silences(ffmpeg, voice)
    cues, before = [], 0.0
    for _, para, _ in BLOCKS[1:]:
        expected = sum(weights[:para]) / total * length
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


def plan(cores, cues, spoken):
    """Scene slots (from one scene starting to fade in until the next does)
    and where each voice block starts in the film."""
    n = len(SCENES)
    if cues is None:
        return [c - FADE for c in cores[:-1]], cores[-1], []
    starts = [0.0, *cues]
    ends = [*cues, spoken]
    lengths = [b - a for a, b in zip(starts, ends)]
    # Blocks inside one scene must not run into each other.
    for k in range(1, len(BLOCKS)):
        (i, _, at), (j, _, at2) = BLOCKS[k - 1], BLOCKS[k]
        if i == j and at + lengths[k - 1] > at2 + 0.05:
            sys.exit(f"block {k - 1} of {SCENES[i][0]} runs {at + lengths[k - 1]:.2f} s, past {at2} s")
    slots = []
    for i in range(n - 1):
        last = max(k for k, b in enumerate(BLOCKS) if b[0] == i)
        nxt = min(k for k, b in enumerate(BLOCKS) if b[0] == i + 1)
        need = BLOCKS[last][2] + lengths[last] - BLOCKS[nxt][2]
        slots.append(max(need, cores[i] - FADE))
    last_block = BLOCKS[-1]
    final = max(last_block[2] + lengths[-1] + CLOSE_HOLD, cores[-1])
    over = sum(slots) + final - LIMIT
    if over > 0:
        sys.exit(f"film would run {sum(slots) + final:.1f} s; the limit is {LIMIT} s")
    scene_at = [sum(slots[:i]) for i in range(n)]
    voice_at = [scene_at[i] + at for i, _, at in BLOCKS]
    return slots, final, list(zip(voice_at, starts, ends))


def coords(out):
    found = {}
    for name, *_ in SCENES:
        path = out / "coords" / f"{name}.json"
        if path.is_file():
            found[name] = json.loads(path.read_text())
    return found


def coordinate_table(scenes, scene_at):
    rows = ["# Cursor coordinates", "",
            "Every step the cursor takes in the film, measured from the widget tree",
            "at the moment it happened (`demo/film/tour.dart`). Film time is when it",
            "happens in pinne-demo.mp4; scene time is from the scene's own start.",
            "App rect is the target's x, y, width, height in the app's logical",
            "pixels (a 412 x 892 screen). Zoom is the camera's magnification over",
            "the full-height screen (never past 2.0). Cursor is the click or",
            "landing point on the 1920 x 1080 canvas; the render fails if it is not",
            "inside the target or the callout covers it.", ""]
    for (name, *_), at in zip(SCENES, scene_at):
        data = scenes.get(name)
        if not data or not data["steps"]:
            continue
        rows += [f"## {name}", "",
                 "| Film (s) | Scene (s) | Action | Target | App rect (x, y, w, h) | Zoom | Cursor (x, y) | Callout |",
                 "| --- | --- | --- | --- | --- | --- | --- | --- |"]
        for s in data["steps"]:
            rect = ", ".join(f"{v:g}" for v in s["app_rect"])
            cursor = ", ".join(f"{v:g}" for v in s["cursor"]) if s["cursor"] else "-"
            action = s["kind"] + (f" by {s['drag'][1]:g} px" if s.get("drag") else "")
            callout = s["callout"] or "-"
            target = s["target"].replace("|", "\\|")
            rows.append(f"| {at + s['t']:.2f} | {s['t']:.2f} | {action} | {target} | {rect} | "
                        f"{s['zoom']:g}x | {cursor} | {callout} |")
        rows.append("")
    return "\n".join(rows) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("out")
    parser.add_argument("--voiceover", default=os.environ.get("FILM_VOICEOVER") or None)
    parser.add_argument("--cues", help="comma-separated voiceover times where the blocks after the first begin")
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
    scenes = coords(out)
    cores = [scenes[name]["seconds"] if name in scenes else planned for name, planned, _ in SCENES]

    voice = pathlib.Path(args.voiceover) if args.voiceover else None
    recording, tempo, cues, spoken = voice, 1.0, None, 0.0
    if voice is not None:
        if not voice.is_file():
            sys.exit(f"voiceover not found: {voice}")
        spoken = duration(ffmpeg, voice)
        room = LIMIT - CLOSE_HOLD - 1.5
        if spoken > room and not args.cues:
            # A slow read is sped up a little, as ElevenLabs' Speed would.
            tempo = spoken / room
            if tempo > MAX_TEMPO:
                sys.exit(f"voiceover runs {spoken:.1f} s; even at {MAX_TEMPO}x it would not fit in {LIMIT} s")
            faster = out / "voiceover-fitted.wav"
            run([ffmpeg, "-y", "-loglevel", "error", "-i", str(voice),
                 "-af", f"atempo={tempo:.4f}", str(faster)])
            print(f"voiceover sped up {tempo:.3f}x to fit", file=sys.stderr)
            voice, spoken = faster, duration(ffmpeg, faster)
        cues = ([float(c) for c in args.cues.split(",")] if args.cues
                else block_cues(ffmpeg, voice, spoken))
        if len(cues) != len(BLOCKS) - 1 or cues != sorted(cues):
            sys.exit(f"need {len(BLOCKS) - 1} increasing cues, got {cues}")
    slots, last, placed = plan(cores, cues, spoken)
    used = [s + FADE for s in slots] + [last]
    length = sum(slots) + last
    scene_at = [sum(slots[:i]) for i in range(len(SCENES))]

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
    run([ffmpeg, "-y", "-loglevel", "error", *inputs,
         "-filter_complex", ";".join(chain), "-map", "[v]", *video, str(picture)])

    # Music, lifted for the Serverpod scene and resolving as the close
    # begins, and the cursor's clicks.
    names = [name for name, *_ in SCENES]
    music, click_track = out / "music.wav", out / "clicks.wav"
    clicks = sorted(scene_at[names.index(name)] + s["t"] + 0.02
                    for name, data in scenes.items() for s in data["steps"] if s["kind"] == "click")
    run([sys.executable, "-I", str(TOOL / "make_music.py"), str(music), f"{length:.3f}",
         "--lift", f"{scene_at[names.index('08_serverpod')] + 0.3:.3f}",
         "--resolve", f"{scene_at[names.index('09_close')] + 0.25:.3f}",
         "--clicks", str(click_track), "--at", ",".join(f"{c:.3f}" for c in clicks)])
    bed_gain = BED - loudness(ffmpeg, music)["lufs"]

    def render_audio(graph, extra, target):
        run([ffmpeg, "-y", "-loglevel", "error", *extra, "-filter_complex", graph,
             "-map", "[a]", "-ar", "48000", "-c:a", "pcm_s24le", "-t", f"{length:.3f}", str(target)])

    def finish(mix, lufs, target):
        """Two-pass loudness normalisation to [lufs], then mux."""
        first = subprocess.run([ffmpeg, "-hide_banner", "-i", str(mix), "-af",
                                f"loudnorm=I={lufs}:TP=-1.5:LRA=11:print_format=json",
                                "-f", "null", "-"], capture_output=True, text=True).stderr
        m = json.loads(first[first.rindex("{"):first.rindex("}") + 1])
        norm = (f"loudnorm=I={lufs}:TP=-1.5:LRA=11:measured_I={m['input_i']}:"
                f"measured_TP={m['input_tp']}:measured_LRA={m['input_lra']}:"
                f"measured_thresh={m['input_thresh']}:offset={m['target_offset']}:linear=true,"
                f"afade=t=out:st={length - 1.2:.3f}:d=1.2")
        run([ffmpeg, "-y", "-loglevel", "error", "-i", str(picture), "-i", str(mix),
             "-af", norm, "-map", "0:v", "-map", "1:a", "-c:v", "copy",
             "-c:a", "aac", "-b:a", "192k", "-ar", "48000", "-t", f"{length:.3f}", str(target)])

    final = out / "pinne-demo.mp4"
    silent = out / "pinne-demo-silent.mp4"
    mix = out / "mix.wav"
    music_only = (f"[0:a]volume={bed_gain:.2f}dB[m];[1:a]anull[c];"
                  "[m][c]amix=inputs=2:duration=first:normalize=0[a]")
    report_audio = {}
    if voice is None:
        render_audio(music_only, ["-i", str(music), "-i", str(click_track)], mix)
        finish(mix, TARGET, final)
        silent.unlink(missing_ok=True)
    else:
        # Each block of the narration, placed where its moment begins.
        parts = []
        for k, (at, a, b) in enumerate(placed):
            delay = int(at * 1000)
            parts.append(f"[vo{k}]atrim={a:.3f}:{b:.3f},asetpts=PTS-STARTPTS,"
                         f"adelay={delay}|{delay}[p{k}]")
        split = "".join(f"[vo{k}]" for k in range(len(placed)))
        narration = (f"[0:a]aresample=48000,aformat=channel_layouts=stereo,"
                     f"loudnorm=I={TARGET}:TP=-1.5:LRA=11,asplit={len(placed)}{split};"
                     + ";".join(parts) + ";"
                     + "".join(f"[p{k}]" for k in range(len(placed)))
                     + f"amix=inputs={len(placed)}:normalize=0,apad,atrim=0:{length:.3f}")
        sources = ["-i", str(voice), "-i", str(music), "-i", str(click_track)]
        if args.no_bed:
            render_audio(f"{narration},asplit[vo][x];[x]anullsink;[2:a]anull[c];"
                         "[vo][c]amix=inputs=2:duration=first:normalize=0[a]", sources, mix)
        else:
            # The bed sits well under the voice and dips further while it
            # speaks, so every word is clear; it is heard in the pauses.
            render_audio(f"{narration},asplit[vo][key];[1:a]volume={bed_gain:.2f}dB[m];"
                         "[m][key]sidechaincompress=threshold=0.02:ratio=6:attack=20:release=550:makeup=1[bed];"
                         "[2:a]anull[c];"
                         "[vo][bed][c]amix=inputs=3:duration=first:normalize=0[a]", sources, mix)
        finish(mix, TARGET, final)
        render_audio(music_only, ["-i", str(music), "-i", str(click_track)], mix)
        finish(mix, SILENT_TARGET, silent)
        report_audio["silent"] = loudness(ffmpeg, silent)
    report_audio["final"] = loudness(ffmpeg, final)
    for f in (picture, mix, out / "voiceover-fitted.wav"):
        f.unlink(missing_ok=True)

    (out / "cursor-coordinates.md").write_text(coordinate_table(scenes, scene_at))
    report = {"seconds": round(length, 2), "voiceover": str(recording) if recording else None,
              "voice_tempo": round(tempo, 3),
              "voice_cues": cues,
              "voice_blocks": [{"scene": SCENES[i][0], "paragraph": para,
                                "voice_from": round(a, 2), "voice_to": round(b, 2),
                                "film_at": round(at, 2)}
                               for (i, para, _), (at, a, b) in zip(BLOCKS, placed)],
              "scenes": [{"scene": name, "starts": round(at, 2), "seconds": round(u, 2)}
                         for (name, *_), at, u in zip(SCENES, scene_at, used)],
              "clicks": [round(c, 2) for c in clicks],
              "loudness": report_audio}
    (out / "cut.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
