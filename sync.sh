#!/bin/sh
set -e
cd "$(dirname "$0")"

# 本机刚导出的 index.html 是唯一要保留的本地内容
keep=$(mktemp "${TMPDIR:-/tmp}/reading-list.XXXXXX")
trap 'rm -f "$keep"' EXIT
cp index.html "$keep"

git fetch --prune origin

# 保护：除 index.html 外有未提交改动就中止，避免被 reset 冲掉
others=$(git status --porcelain --untracked-files=no -- . ':!index.html')
if [ -n "$others" ]; then
    echo "sync.sh: 除 index.html 外还有未提交改动，请先处理：" >&2
    printf '%s\n' "$others" >&2
    exit 1
fi

# 保护：本机有未推送的非 update 提交就中止，避免被 reset 冲掉
stray=$(git log --format=%s origin/main..HEAD | grep -vx 'update reading list') || true
if [ -n "$stray" ]; then
    echo "sync.sh: 本机有未推送的其它提交，请先处理：" >&2
    printf '%s\n' "$stray" >&2
    exit 1
fi

# 对齐远端，再放回本次导出
git reset --hard origin/main
cp "$keep" index.html

git add index.html

if git diff --cached --quiet index.html; then
    echo "No changes to commit."
    exit 0
fi

# 合并同一天的 reading list 更新
if [ "$(git log -1 --pretty=%s)" = "update reading list" ] \
   && [ "$(git log -1 --pretty=%cd --date=short)" = "$(date +%F)" ]; then
    git commit --amend --no-edit
    git push --force-with-lease
else
    git commit -m "update reading list"
    git push
fi

echo "Reading list pushed."
