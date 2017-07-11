#!/bin/sh

set -eu

dst=$(dirname "$(readlink -f "$0")")/fonts
tmp=$(mktemp -d)
pkg='https://github.com/google/roboto/releases/download'$(
	curl -sL 'https://github.com/google/roboto/releases/latest' |
	grep -Eo '/v[0-9.]+/roboto-hinted.zip' |
	head -1
)

curl "$pkg" -Lo "$tmp"/roboto.zip
unzip -o "$tmp"/roboto.zip -d "$tmp"

find "$tmp"/roboto-hinted -type f -name 'Roboto-*.ttf' \
	-exec sfnt2woff {} \; \
	-exec woff2_compress {} \;

rm -rf "$dst" && mkdir -p "$dst"
mv -vt "$dst" \
	"$tmp"/roboto-hinted/*.woff \
	"$tmp"/roboto-hinted/*.woff2 \
	"$tmp"/roboto-hinted/LICENSE

rm -rf "$tmp"
