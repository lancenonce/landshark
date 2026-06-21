#!/usr/bin/env bash
# Grow the 6 "headliner" languages so GitHub names them in the language bar
# and the grey "Other" slice shrinks. Run periodically (e.g. weekly). Each run
# appends a chunk of commented shark-filler to each headliner file, increasing
# its byte share. Linguist ranks by bytes, so these climb above the long tail.
set -euo pipefail
cd "$(dirname "$0")"

CHUNK_KB="${1:-4}"   # KB to add to EACH headliner per run (default 4)

# The 6 colors GitHub currently names. file : line-comment-prefix
declare -a H=(
  "landshark.html|<!--|-->"   # HTML  (block comment)
  "landshark.js|//"           # JavaScript
  "landshark.pl|#"            # Perl
  "landshark.hs|--"           # Haskell
  "landshark.ex|#"            # Elixir
  "landshark.sh|#"            # Shell
)

bytes=$((CHUNK_KB*1024))
for entry in "${H[@]}"; do
  IFS='|' read -r file open close <<<"$entry"
  [ -f "$file" ] || { echo "skip missing $file"; continue; }
  added=0
  {
    while [ "$added" -lt "$bytes" ]; do
      if [ -n "${close:-}" ]; then
        line="$open LANDSHARK BANDSHARK HANDSHARK MANDELBROT rainbow $RANDOM $close"
      else
        line="$open LANDSHARK BANDSHARK HANDSHARK MANDELBROT rainbow $RANDOM"
      fi
      echo "$line"
      added=$((added + ${#line} + 1))
    done
  } >> "$file"
  echo "grew $file by ~${CHUNK_KB}KB"
done

git add "${H[@]/|*/}" 2>/dev/null || git add landshark.html landshark.js landshark.pl landshark.hs landshark.ex landshark.sh
git -c commit.gpgsign=false commit -q -m "Grow rainbow headliners (+${CHUNK_KB}KB each)"
echo "Committed. Push when ready: git push origin main"
echo "Repeat weekly; headliners climb, grey 'Other' shrinks."
