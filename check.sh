#!/usr/bin/env bash
#
# Run presubmit checks.
#
source "$(dirname "${BASH_SOURCE[0]}")"/lib.sh

# Repositories may contain multiple modules.
# Search for directories containing go.mod files and repeat
# the checks for each, since the go tool respect module boundaries.
find . -type f -name go.mod -print | while read -r mod ; do
    module "Checking module $(dirname $mod)"
    pushd "$(dirname $mod)"

    label "Fetching module dependencies"
    go mod download
    check

    label "Checking source format"
    bash -s -- gofmt -l -s ./... <<EOF
if find . -type f -name '*.go' -print0 \
   | xargs -0 gofmt -l -s \
   | grep .
then
  echo "^ These files need formatting with go fmt"
  exit 1
fi
EOF
    check

    label "Running unit tests"
    go test -vet=all -race -cpu="${GO_TEST_CPU}" ./...
    check

    if istrue "${CHECK_STATICCHECK:-1}" ; then
        label "Running staticcheck"
        scpath="$(pkgpath honnef.co/go/tools/cmd/staticcheck ${STATICCHECK_VERSION:-latest})"
        go run "$scpath" ./...
        check
    fi

    if istrue "${CHECK_REPLACE:-1}" ; then
        label "Checking go.mod structure"
        # N.B. We are already in the module root here.
        if grep '^replace ' go.mod ; then
            echo "^ Found replacement directives in $mod"
            false
        else
            true
        fi
        check
    fi

    popd
done
