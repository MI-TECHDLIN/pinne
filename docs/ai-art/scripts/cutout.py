"""Cut out a character locally with rembg and save a trimmed RGBA WebP under 250 KB.

Usage: python -I cutout.py <src image> <dst.webp>
Default model is isnet-general-use. Set REMBG_MODEL=birefnet-general-lite to try
BiRefNet; on an 8 GB codespace it peaked at about 3.7 GB RSS and was killed.
"""
import io
import os
import sys

import onnxruntime as ort
from PIL import Image
from rembg import new_session, remove

src, dst = sys.argv[1], sys.argv[2]
cap = 250 * 1024
opts = ort.SessionOptions()
opts.enable_cpu_mem_arena = False
opts.enable_mem_pattern = False
opts.intra_op_num_threads = 2
opts.inter_op_num_threads = 1
session = new_session(os.environ.get("REMBG_MODEL", "isnet-general-use"), sess_opts=opts)
im = Image.open(src).convert("RGB")
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
