#!/usr/bin/env bash
# Run this ON a "LANCE pixel" day (your calendar will remind you).
# Makes N commits dated today and pushes them so today's square fills in
# on your GitHub contribution graph. Part of spelling LANCE across the year.
set -euo pipefail

N="${1:-6}"                 # number of commits (default 6); high vs empty days = dark square
BRANCH="main"              # contribution graph counts default-branch commits
LOG="contributions.log"    # the file we append to

cd "$(dirname "$0")"
git checkout "$BRANCH" >/dev/null 2>&1 || true

TODAY="$(date +%Y-%m-%d)"
STAMP="${TODAY}T12:00:00"

for i in $(seq 1 "$N"); do
  echo "LANCE pixel $TODAY commit $i :: pull pull pull" >> "$LOG"
  git add "$LOG"
  GIT_AUTHOR_DATE="$STAMP" GIT_COMMITTER_DATE="$STAMP" \
    git -c commit.gpgsign=false commit -q -m "LANCE: $TODAY ($i/$N)"
done

git push origin "$BRANCH"
echo "Filled pixel for $TODAY with $N commits."
