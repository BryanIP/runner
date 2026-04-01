#!/bin/bash

set -e

mkdir -p bin

VERSION=v0.0.1

cd cli

GOOS=windows GOARCH=amd64 go build -o ../bin/assinatura-$VERSION-windows-amd64.exe ./cmd/assinatura
GOOS=linux GOARCH=amd64 go build -o ../bin/assinatura-$VERSION-linux-amd64 ./cmd/assinatura
GOOS=darwin GOARCH=amd64 go build -o ../bin/assinatura-$VERSION-darwin-amd64 ./cmd/assinatura