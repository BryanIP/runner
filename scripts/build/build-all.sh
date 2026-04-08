#!/usr/bin/env bash

set -euo pipefail

VERSION=${VERSION:-v0.0.1}
OUT_DIR="dist/bin"

mkdir -p "$OUT_DIR"

pushd apps/assinatura-cli > /dev/null
GOOS=windows GOARCH=amd64 go build -o "../../$OUT_DIR/assinatura-$VERSION-windows-amd64.exe" ./cmd/assinatura
GOOS=linux GOARCH=amd64 go build -o "../../$OUT_DIR/assinatura-$VERSION-linux-amd64" ./cmd/assinatura
GOOS=darwin GOARCH=amd64 go build -o "../../$OUT_DIR/assinatura-$VERSION-darwin-amd64" ./cmd/assinatura
popd > /dev/null

echo "Build concluído em $OUT_DIR"
