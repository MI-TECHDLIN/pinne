"""Draws the hero image of the drawn reading app the capture scene shares
from.

Self-made abstract art (no photos, logos or third-party material). Output:
demo/assets/thumbs/*.png, committed because they are small and ours.
Needs Pillow.
"""

import pathlib

from PIL import Image, ImageDraw, ImageFilter

W, H = 800, 450
OUT = pathlib.Path(__file__).resolve().parents[1] / "assets" / "thumbs"


def gradient(top, bottom):
    img = Image.new("RGB", (W, H))
    px = img.load()
    for y in range(H):
        for x in range(W):
            t = (y / H) * 0.75 + (x / W) * 0.25
            px[x, y] = tuple(int(a + (b - a) * t) for a, b in zip(top, bottom))
    return img


def soft(img, draw_fn, blur=0):
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    draw_fn(ImageDraw.Draw(layer))
    if blur:
        layer = layer.filter(ImageFilter.GaussianBlur(blur))
    img.paste(layer, (0, 0), layer)


def onboarding():
    img = gradient((255, 214, 170), (246, 169, 221))
    soft(img, lambda d: d.ellipse((520, -120, 980, 340), fill=(255, 255, 255, 90)), 30)
    for i, (x, y) in enumerate([(150, 70), (330, 50), (510, 90)]):
        soft(img, lambda d, x=x, y=y: d.rounded_rectangle((x + 8, y + 14, x + 158, y + 334), 26, fill=(60, 20, 70, 60)), 12)
        def phone(d, x=x, y=y, i=i):
            d.rounded_rectangle((x, y, x + 150, y + 320), 24, fill=(255, 250, 246, 255))
            d.ellipse((x + 45, y + 60, x + 105, y + 120), fill=[(124, 92, 255, 255), (143, 232, 208, 255), (255, 194, 122, 255)][i])
            for k in range(3):
                d.rounded_rectangle((x + 22, y + 150 + k * 26, x + 128 - k * 22, y + 162 + k * 26), 6, fill=(40, 30, 60, 70))
            d.rounded_rectangle((x + 22, y + 262, x + 128, y + 292), 15, fill=(20, 16, 42, 230))
        soft(img, phone)
    return img


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for name, fn in [("onboarding", onboarding)]:
        fn().save(OUT / f"{name}.png", optimize=True)
        print("wrote", name)


if __name__ == "__main__":
    main()
