"""Cut out a character locally with rembg and save a trimmed RGBA WebP under 250 KB.

Usage: python -I cutout.py <src image> <dst.webp>
REMBG_MODEL picks the rembg model (default isnet-general-use, used for the
master). The mood stills use REMBG_MODEL=silueta with HOLE_KEY=1: on this 8 GB
codespace ISNet was killed by the memory guard while other jobs ran, and
silueta (about 0.6 GB peak) fills the swirl's open centre with background.
HOLE_KEY multiplies the silueta mask by a luminance key against the plain
dark violet background, which clears the centre and the floor, and keeps any
bright pixel (sparkles, moon) that silueta dropped.
HOLE_KEY_LO and HOLE_KEY_HI tune the preserved-bright-pixel ramp (defaults
60 and 100). The hero and remaining pieces use 90 and 140 because their
background halos otherwise leave more visible violet remnants.
BiRefNet (REMBG_MODEL=birefnet-general-lite) peaked at about 3.7 GB RSS and was killed.
"""
import io
import os
import sys

import numpy as np
import onnxruntime as ort
from PIL import Image, ImageFilter
from rembg import new_session, remove


def ramp(lum, lo, hi):
    return np.clip((lum - lo) / (hi - lo), 0, 1)


src, dst = sys.argv[1], sys.argv[2]
cap = 250 * 1024
opts = ort.SessionOptions()
opts.enable_cpu_mem_arena = False
opts.enable_mem_pattern = False
opts.intra_op_num_threads = int(os.environ.get("REMBG_THREADS", "1"))
opts.inter_op_num_threads = 1
session = new_session(os.environ.get("REMBG_MODEL", "isnet-general-use"), sess_opts=opts)
im = Image.open(src).convert("RGB")
if os.environ.get("HOLE_KEY") == "1":
    mask = np.asarray(remove(im, session=session, only_mask=True, post_process_mask=True)) / 255
    lum = np.asarray(im).astype(np.float32) @ np.array([0.299, 0.587, 0.114], np.float32)
    key_lo = float(os.environ.get("HOLE_KEY_LO", "60"))
    key_hi = float(os.environ.get("HOLE_KEY_HI", "100"))
    alpha = np.maximum(mask * ramp(lum, 44, 64), ramp(lum, key_lo, key_hi))
    matte = Image.fromarray((alpha * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(0.6))
    out = im.convert("RGBA")
    out.putalpha(matte)
else:
    out = remove(im, session=session, post_process_mask=True)
out = out.crop(out.getbbox())
pad = 24
canvas = Image.new("RGBA", (out.width + 2 * pad, out.height + 2 * pad), (0, 0, 0, 0))
canvas.paste(out, (pad, pad))
for q in (90, 85, 80, 75, 70, 60):
    buf = io.BytesIO()
    canvas.save(buf, "WEBP", quality=q, alpha_quality=90, method=6)
    if buf.tell() <= cap:
        break
with open(dst, "wb") as f:
    f.write(buf.getvalue())
print(dst, canvas.size, f"q={q}", f"{buf.tell() / 1024:.0f} KB")
