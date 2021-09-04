#!/bin/bash
#
# Install the staticcheck tool.
# Environment:
#   STATICCHECK_VERSION: Release branch or tag (required)
#
: ${STATICCHECK_VERSION:?missing staticcheck version}

source "$(dirname $0)"/lib.sh

# Create a temporary module to run the installation.
tmp="$(mktemp -d)"
trap "rm -fr -- $tmp" EXIT
cd "$tmp"

label "Installing staticcheck $STATICCHECK_VERSION"
go mod init install # satisfy Go 1.11
go install honnef.co/go/tools/cmd/staticcheck@"${STATICCHECK_VERSION}"
check
