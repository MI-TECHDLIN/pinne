"""Writes a calm, self-generated music bed for the film (no samples, no
third-party material): a soft pad, a plucked arpeggio and a sub bass in
D major, synthesised here with numpy. Output is 48 kHz stereo WAV.

    python3 make_music.py OUT.wav SECONDS
"""

import sys
import wave

import numpy as np

RATE = 48000
BPM = 84
BEAT = 60 / BPM
BAR = 4 * BEAT

# D major: Dmaj9, Bm7, Gmaj7, A6sus, as MIDI notes (pad voicing).
CHORDS = [
    [50, 57, 62, 66, 69, 76],
    [47, 54, 62, 66, 69, 73],
    [43, 50, 59, 62, 66, 71],
    [45, 52, 59, 62, 64, 69],
]
ARP = [0, 2, 3, 4, 5, 4, 3, 2]


def hz(note):
    return 440.0 * 2 ** ((note - 69) / 12)


def tone(freq, seconds, harmonics=(1.0, 0.25, 0.08), detune=0.0):
    t = np.arange(int(seconds * RATE)) / RATE
    out = np.zeros_like(t)
    for k, amp in enumerate(harmonics, start=1):
        out += amp * np.sin(2 * np.pi * freq * k * (1 + detune) * t)
    return out


def envelope(n, attack, release):
    env = np.ones(n)
    a = min(n, int(attack * RATE))
    r = min(n - a, int(release * RATE))
    env[:a] = np.linspace(0, 1, a) ** 2
    if r:
        env[n - r:] = np.linspace(1, 0, r) ** 2
    return env


def main():
    out_path, seconds = sys.argv[1], float(sys.argv[2])
    n = int(seconds * RATE)
    left = np.zeros(n + RATE * 4)
    right = np.zeros_like(left)

    def add(signal, start, pan=0.0, gain=1.0):
        i = int(start * RATE)
        if i >= len(left):
            return
        j = min(len(left), i + len(signal))
        seg = signal[: j - i] * gain
        left[i:j] += seg * (1 - pan) / 2 ** 0.5
        right[i:j] += seg * (1 + pan) / 2 ** 0.5

    bars = int(seconds / BAR) + 2
    for b in range(bars):
        chord = CHORDS[(b // 2) % len(CHORDS)]
        start = b * BAR
        if b % 2 == 0:
            length = 2 * BAR + 0.6
            for i, note in enumerate(chord):
                for d, pan in ((-0.004, -0.5), (0.004, 0.5)):
                    pad = tone(hz(note), length, (1.0, 0.18, 0.05), d)
                    pad *= envelope(len(pad), 1.4, 1.6)
                    add(pad, start, pan, 0.028)
            bass = tone(hz(chord[0] - 12), 2 * BAR, (1.0, 0.1))
            bass *= envelope(len(bass), 0.3, 0.8)
            add(bass, start, 0.0, 0.10)
        # Plucks: eighth notes, two octaves up, after the intro bar.
        if b >= 1:
            for k in range(8):
                note = chord[ARP[k]] + 12
                when = start + k * BEAT / 2
                length = 1.2
                pluck = tone(hz(note), length, (1.0, 0.35, 0.12))
                t = np.arange(len(pluck)) / RATE
                pluck *= np.exp(-t * 4.5) * envelope(len(pluck), 0.004, 0.2)
                pan = -0.35 if k % 2 == 0 else 0.35
                add(pluck, when, pan, 0.055)
                add(pluck, when + 3 * BEAT / 4, -pan, 0.022)  # echo

    mix = np.stack([left[:n], right[:n]], axis=1)
    fade_in, fade_out = int(1.5 * RATE), int(3.0 * RATE)
    mix[:fade_in] *= np.linspace(0, 1, fade_in)[:, None]
    mix[-fade_out:] *= np.linspace(1, 0, fade_out)[:, None] ** 1.5
    mix /= np.max(np.abs(mix)) / 0.5  # peak at -6 dBFS
    pcm = (mix * 32767).astype(np.int16)
    with wave.open(out_path, "wb") as f:
        f.setnchannels(2)
        f.setsampwidth(2)
        f.setframerate(RATE)
        f.writeframes(pcm.tobytes())


if __name__ == "__main__":
    main()
