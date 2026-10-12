"""Draws the sample link-preview thumbnails the film's demo items point to.

Self-made abstract art (no photos, logos or third-party material). Output:
demo/assets/thumbs/*.png, committed because they are small and ours.
Needs Pillow.
"""

import math
import pathlib
import random

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


def knife():
    img = gradient((36, 64, 52), (16, 30, 26))
    soft(img, lambda d: d.ellipse((-100, 200, 500, 700), fill=(143, 232, 208, 50)), 40)
    soft(img, lambda d: d.rounded_rectangle((110, 120, 690, 380), 40, fill=(196, 150, 104, 255)))
    soft(img, lambda d: d.rounded_rectangle((110, 120, 690, 380), 40, outline=(150, 108, 70, 255), width=6))
    rnd = random.Random(7)
    for i in range(9):
        cx, cy = 230 + i * 30, 250 + rnd.randint(-10, 10)
        soft(img, lambda d, cx=cx, cy=cy: d.ellipse((cx - 22, cy - 22, cx + 22, cy + 22), fill=(255, 140, 90, 255), outline=(255, 214, 170, 255), width=5))
    def blade(d):
        d.polygon([(470, 180), (660, 160), (680, 190), (480, 215)], fill=(222, 228, 236, 255))
        d.rounded_rectangle((380, 186, 480, 214), 10, fill=(40, 32, 30, 255))
    soft(img, blade)
    return img


def pasta():
    img = gradient((255, 194, 122), (214, 92, 70))
    soft(img, lambda d: d.ellipse((180, 40, 620, 480), fill=(255, 248, 238, 255)), 0)
    soft(img, lambda d: d.ellipse((230, 90, 570, 430), fill=(250, 220, 160, 255)))
    rnd = random.Random(3)
    def strands(d):
        for _ in range(40):
            a = rnd.uniform(0, math.tau)
            r = rnd.uniform(20, 140)
            x, y = 400 + r * math.cos(a), 260 + r * math.sin(a)
            d.arc((x - 50, y - 30, x + 50, y + 30), rnd.randint(0, 180), rnd.randint(180, 360), fill=(236, 190, 110, 255), width=6)
        for _ in range(9):
            a = rnd.uniform(0, math.tau)
            r = rnd.uniform(10, 110)
            x, y = 400 + r * math.cos(a), 260 + r * math.sin(a)
            d.ellipse((x - 20, y - 20, x + 20, y + 20), fill=(220, 60, 50, 255))
        for _ in range(7):
            a = rnd.uniform(0, math.tau)
            r = rnd.uniform(10, 120)
            x, y = 400 + r * math.cos(a), 260 + r * math.sin(a)
            d.ellipse((x - 9, y - 5, x + 9, y + 5), fill=(80, 160, 90, 255))
    soft(img, strands)
    return img


def navbar():
    img = gradient((169, 196, 255), (124, 92, 255))
    soft(img, lambda d: d.ellipse((-150, -200, 400, 300), fill=(255, 255, 255, 70)), 40)
    soft(img, lambda d: d.rounded_rectangle((150, 290, 650, 370), 40, fill=(20, 16, 42, 110)), 14)
    def bar(d):
        d.rounded_rectangle((140, 270, 660, 350), 40, fill=(20, 16, 42, 235))
        d.rounded_rectangle((152, 282, 330, 338), 28, fill=(185, 167, 255, 255))
        for i in range(4):
            cx = 380 + i * 72
            d.ellipse((cx - 13, 297, cx + 13, 323), outline=(245, 242, 255, 200), width=4)
    soft(img, bar)
    for i in range(3):
        soft(img, lambda d, i=i: d.rounded_rectangle((180 + i * 150, 90, 300 + i * 150, 220), 22, fill=(255, 255, 255, 120 + i * 30)))
    return img


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for name, fn in [("onboarding", onboarding), ("knife", knife), ("pasta", pasta), ("navbar", navbar)]:
        fn().save(OUT / f"{name}.png", optimize=True)
        print("wrote", name)


if __name__ == "__main__":
    main()
