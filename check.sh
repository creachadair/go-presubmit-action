#!/bin/bash
#
# Run presubmit checks.
#
source "$(dirname $0)"/lib.sh
GOBIN="$(go env GOPATH)/bin"

readonly scvers="$($GOBIN/staticcheck --version | cut -d' ' -f2 | cut -d. -f1)"

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

    label "Running staticcheck"
    if [[ ("$go_version" =~ ^go1.18) && ("$scvers" -lt 2022) ]] ; then
        printf "\033[50C\033[1;33mSKIPPED\033[0m (staticcheck $scvers does not support $govers)\n"
    else
        $GOBIN/staticcheck ./...
        check
    fi

    popd
done
