#!/usr/bin/env bash

# 打包源码归档，供 GitHub Release 发布
set -euo pipefail

cd "$(dirname "$0")/.."

out="${1:-dist/helloworld-1.0.0.tar.gz}"

files=(
  Makefile
  Dockerfile
  .dockerignore
  README.md
  main.go
  go.mod
  go.sum
  LICENSE
)

for f in "${files[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "missing required file: $f" >&2
    exit 1
  fi
done

if [[ ! -d internal ]]; then
  echo "missing required directory: internal" >&2
  exit 1
fi

stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

cp "${files[@]}" "$stage/"
cp -R internal "$stage/internal"

mkdir -p "$(dirname "$out")"
tar -czf "$out" -C "$stage" .

echo "finish $out"
