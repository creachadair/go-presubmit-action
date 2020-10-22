#!/bin/bash
: ${STATICCHECK_VERSION:?missing staticcheck version}

tmp="$(mktemp -d)"
trap "rm -fr -- $tmp" EXIT

echo "-- Installing staticcheck $STATICCHECK_VERSION ..."
cd "$tmp"
go get honnef.co/go/tools/cmd/staticcheck@"${STATICCHECK_VERSION}"
