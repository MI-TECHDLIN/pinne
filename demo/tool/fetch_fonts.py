"""Downloads the exact Outfit and Plus Jakarta Sans files the app's
google_fonts package would fetch at runtime, so the film renders with the
real fonts and no network access during the render.

Both families are SIL Open Font License 1.1 (fonts.google.com). The files go
to demo/.cache/fonts/ (git-ignored) and are never committed.
"""

import hashlib
import pathlib
import re
import sys
import urllib.request

FAMILIES = {"outfit": "part_o.dart", "plusJakartaSans": "part_p.dart"}


def google_fonts_parts() -> pathlib.Path:
    cache = pathlib.Path.home() / ".pub-cache" / "hosted" / "pub.dev"
    lock = (pathlib.Path(__file__).resolve().parents[2] / "pubspec.lock").read_text()
    version = re.search(r"google_fonts:\n(?:.*\n)*?\s+version: \"([^\"]+)\"", lock).group(1)
    return cache / f"google_fonts-{version}" / "lib" / "src" / "google_fonts_parts"


def hashes(source: str, method: str) -> list[tuple[str, int]]:
    start = source.index(f"static TextStyle {method}(")
    end = source.index("static TextStyle ", start + 10)
    body = source[start:end]
    return [(h, int(n)) for h, n in re.findall(r"GoogleFontsFile\(\s*'([0-9a-f]{64})',\s*(\d+)", body)]


def main() -> None:
    out = pathlib.Path(__file__).resolve().parents[1] / ".cache" / "fonts"
    out.mkdir(parents=True, exist_ok=True)
    parts = google_fonts_parts()
    for method, part in FAMILIES.items():
        for digest, length in hashes((parts / part).read_text(), method):
            target = out / f"{digest}.ttf"
            if target.exists():
                continue
            url = f"https://fonts.gstatic.com/s/a/{digest}.ttf"
            data = urllib.request.urlopen(url, timeout=60).read()
            if len(data) != length or hashlib.sha256(data).hexdigest() != digest:
                sys.exit(f"{url} did not match its expected hash")
            target.write_bytes(data)
            print("fetched", method, digest[:12])


if __name__ == "__main__":
    main()
