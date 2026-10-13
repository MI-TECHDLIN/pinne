"""Render docs/readme/banner.png (1280x640, also the GitHub social preview).

Run from the repo root:  python3 docs/readme/make_banner.py
Needs Pillow. Uses only files in this repo: the Ribbon Spirit cutout, the
bundled Outfit and Plus Jakarta Sans fonts and three existing test-rendered screenshots whose text is all real
fonts (no blank placeholder labels).
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parents[2]
W, H = 1280, 640
OUT = ROOT / "docs/readme/banner.png"

OUTFIT = ROOT / "pinne_flutter/assets/fonts/outfit/Outfit-VariableFont_wght.ttf"
JAKARTA = ROOT / "pinne_flutter/assets/fonts/plus_jakarta_sans/PlusJakartaSans-VariableFont_wght.ttf"
SPIRIT = ROOT / "pinne_flutter/assets/art/cutout/ribbon_spirit_happy.webp"
SHOTS = [
    ROOT / "docs/onboarding/02-we-bring-it-back.png",
    ROOT / "docs/ui-fidelity/after-collections.png",
    ROOT / "docs/onboarding/03-make-time-progress.png",
]


def font(path, size, weight):
    f = ImageFont.truetype(str(path), size)
    f.set_variation_by_axes([weight])
    return f


def gradient():
    top, bottom = (58, 30, 118), (11, 8, 24)
    img = Image.new("RGB", (W, H))
    px = img.load()
    for y in range(H):
        for x in range(W):
            t = min(1.0, max(0.0, (y / H) * 0.8 + (x / W) * 0.25))
            px[x, y] = tuple(int(top[i] + (bottom[i] - top[i]) * t) for i in range(3))
    return img


def glow(base, center, radius, color, alpha):
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    cx, cy = center
    d.ellipse([cx - radius, cy - radius, cx + radius, cy + radius], fill=color + (alpha,))
    layer = layer.filter(ImageFilter.GaussianBlur(radius / 2))
    base.alpha_composite(layer)


def phone(shot, width, angle):
    im = Image.open(shot).convert("RGBA")
    h = round(im.height * width / im.width)
    im = im.resize((width, h), Image.LANCZOS)
    r = 28
    mask = Image.new("L", im.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, im.width - 1, im.height - 1], r, fill=255)
    im.putalpha(mask)
    pad = 6
    framed = Image.new("RGBA", (im.width + pad * 2, im.height + pad * 2), (0, 0, 0, 0))
    ImageDraw.Draw(framed).rounded_rectangle(
        [0, 0, framed.width - 1, framed.height - 1], r + pad, fill=(236, 230, 255, 255))
    framed.alpha_composite(im, (pad, pad))
    shadow = Image.new("RGBA", (framed.width + 80, framed.height + 80), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        [40, 52, 40 + framed.width, 52 + framed.height], r + pad, fill=(0, 0, 0, 150))
    shadow = shadow.filter(ImageFilter.GaussianBlur(18))
    shadow.alpha_composite(framed, (40, 40))
    return shadow.rotate(angle, resample=Image.BICUBIC, expand=True)


def main():
    img = gradient().convert("RGBA")
    glow(img, (250, 560), 260, (124, 92, 255), 110)
    glow(img, (1000, 120), 280, (178, 140, 255), 90)

    d = ImageDraw.Draw(img)
    d.text((72, 150), "Pinne", font=font(OUTFIT, 128, 700), fill=(255, 255, 255))
    d.text((76, 300), "Save it. Come back to it.", font=font(OUTFIT, 44, 400), fill=(214, 200, 255))
    body = font(JAKARTA, 24, 500)
    d.text((76, 380), "Everything you share and mean to revisit,\nwith the reason you saved it.",
           font=body, fill=(176, 168, 206), spacing=8)
    chip = font(JAKARTA, 22, 700)
    x = 76
    for label in ("Flutter", "Serverpod 4", "Offline first"):
        w = d.textlength(label, font=chip)
        d.rounded_rectangle([x, 506, x + w + 36, 552], 23, fill=(124, 92, 255))
        d.text((x + 18, 515), label, font=chip, fill=(255, 255, 255))
        x += w + 52

    spirit = Image.open(SPIRIT).convert("RGBA")
    spirit.thumbnail((200, 215), Image.LANCZOS)
    img.alpha_composite(spirit, (590, 380))

    placements = [(SHOTS[0], 190, -7, 800, 150), (SHOTS[1], 210, 0, 930, 60), (SHOTS[2], 190, 7, 1085, 170)]
    for shot, width, angle, px, py in placements:
        p = phone(shot, width, angle)
        img.alpha_composite(p, (px - p.width // 2 + 70, py))

    img.convert("RGB").save(OUT, optimize=True)
    print(OUT, OUT.stat().st_size // 1024, "KB")


if __name__ == "__main__":
    main()
