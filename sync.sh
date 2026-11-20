#!/bin/sh
set -e
cd "$(dirname "$0")"

git pull --ff-only --no-rebase
git add -- index.html

if git diff --cached --quiet -- index.html; then
    echo "No changes to commit."
    exit 0
fi

git commit -m "update reading list"
git push
echo "Reading list pushed."
