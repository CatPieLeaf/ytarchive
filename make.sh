#!/bin/bash
if [[ "$1" = "t" ]]; then
    go build -race -ldflags "-X main.Commit=-$(git rev-parse --short HEAD)"
elif [[ -n "$1" ]]; then
    CGO_ENABLED=0 go build -ldflags "-X main.Commit=-$(git rev-parse --short HEAD)"
    GOOS=windows GOARCH=amd64 go build -ldflags "-X main.Commit=-$(git rev-parse --short HEAD)" -o ytarchive_windows_amd64.exe
    GOOS=windows GOARCH=arm64 go build -ldflags "-X main.Commit=-$(git rev-parse --short HEAD)" -o ytarchive_windows_arm64.exe
    GOOS=linux GOARCH=amd64 go build -ldflags "-X main.Commit=-$(git rev-parse --short HEAD)" -o ytarchive_linux_amd64
    GOOS=linux GOARCH=arm64 go build -ldflags "-X main.Commit=-$(git rev-parse --short HEAD)" -o ytarchive_linux_arm64
    GOOS=android GOARCH=arm64 go build -ldflags "-X main.Commit=-$(git rev-parse --short HEAD)" -o ytarchive_android_arm64
else
    CGO_ENABLED=0 go build
    GOOS=windows GOARCH=amd64 go build -o ytarchive_windows_amd64
    GOOS=windows GOARCH=arm64 go build -o ytarchive_windows_arm64
    GOOS=linux GOARCH=amd64 go build -o ytarchive_linux_amd64
    GOOS=linux GOARCH=arm64 go build -o ytarchive_linux_arm64
    GOOS=android GOARCH=arm64 go build -o ytarchive_android_arm64
fi

zip ytarchive_windows_amd64.zip ytarchive_windows_amd64.exe
zip ytarchive_windows_arm64.zip ytarchive_windows_arm64.exe
zip ytarchive_linux_amd64.zip ytarchive_linux_amd64
zip ytarchive_linux_arm64.zip ytarchive_linux_arm64
zip ytarchive_android_arm64.zip ytarchive_android_arm64

sha256sum ytarchive_windows_amd64.zip ytarchive_windows_arm64.zip ytarchive_linux_amd64.zip  ytarchive_linux_arm64.zip ytarchive_android_arm64.zip > SHA2-256SUMS
