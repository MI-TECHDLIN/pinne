#!/usr/bin/env bash
# Renders the Pinne demo film from the real app code in this checkout.
#
#   demo/tool/render.sh                 every scene, then the final MP4
#   demo/tool/render.sh --preview       PNG stills every 0.5 s, no video
#   demo/tool/render.sh 05_today        one scene (a test-name regex)
#
# Output goes to $FILM_OUT (default demo/out, git-ignored).
set -euo pipefail

demo="$(cd "$(dirname "$0")/.." && pwd)"
repo="$(dirname "$demo")"
out="${FILM_OUT:-$demo/out}"
preview=false
if [[ ${1:-} == --preview ]]; then preview=true; shift; fi
scene="${1:-}"

ffmpeg="${FFMPEG:-$(command -v ffmpeg || python3 -c 'import imageio_ffmpeg as f; print(f.get_ffmpeg_exe())')}"
mkdir -p "$out"
python3 -I "$demo/tool/fetch_fonts.py"
engine="$("$demo/tool/film_engine.sh")"

cd "$repo/pinne_flutter"
flutter test \
  --local-engine-src-path="$engine" --local-engine=host_debug --local-engine-host=host_debug \
  --concurrency=1 --reporter=expanded \
  --dart-define=FILM_ROOT="$demo" \
  --dart-define=FILM_APP="$repo/pinne_flutter" \
  --dart-define=FILM_OUT="$out" \
  --dart-define=FILM_FFMPEG="$ffmpeg" \
  --dart-define=FILM_PREVIEW="$preview" \
  ${scene:+--name "$scene"} \
  ../demo/film/film_test.dart

if [[ $preview == false && -z $scene ]]; then
  FFMPEG="$ffmpeg" python3 -I "$demo/tool/assemble.py" "$out"
fi
