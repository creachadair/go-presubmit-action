#!/bin/bash

label() { printf "▷ \033[1;36m$*\033[0m\n" ; }
check() {
    if [[ $? -ne 0 ]] ; then
	printf "\033[50C\033[1;31mFAILED\033[0m\n"
	exit 1
    else
	printf "\033[50C\033[1;32mSUCCESS\033[0m\n"
    fi
}

GOBIN="$(go env GOPATH)/bin"

if [[ -f go.mod ]] ; then
    label "Fetching module dependencies"
    go mod download
    check
fi

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
go test -race -cpu=1,2 ./...
check

label "Running staticcheck"
$GOBIN/staticcheck ./...
check
