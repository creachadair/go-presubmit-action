#!/bin/bash
: ${STATICCHECK_VERSION:?missing staticcheck version}

source "$(dirname $0)"/lib.sh

tmp="$(mktemp -d)"
trap "rm -fr -- $tmp" EXIT

label "Installing staticcheck $STATICCHECK_VERSION"
cd "$tmp"
go mod init install # satisfy Go 1.11
go get honnef.co/go/tools/cmd/staticcheck@"${STATICCHECK_VERSION}"
check
