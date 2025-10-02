# Go Presubmit Checks Action

This repository defines a [GitHub action][gha] to perform presubmit checks for
a repository containing [Go][go] source code. The checks performed include:

1. Ensure that all source files are formatted with  `go fmt`.
2. Ensure that all unit tests pass.
3. Ensure the [`staticcheck`][sc] tool does not report any warnings.

The following example workflow demonstrates its use:

```yaml
name: Go presubmit

on:
  push:
    branches:
      - main
  pull_request:
    types: [opened, reopened, synchronize]

permissions: read-all

jobs:
  build:
    name: Go presubmit
    runs-on: 'ubuntu-latest'
    steps:
    - uses: actions/checkout@v5
    - name: Install Go ${{ matrix.go-version }}
      uses: actions/setup-go@v6
      with:
        go-version: stable
    - uses: creachadair/go-presubmit-action@v2
```

[gha]: https://docs.github.com/en/actions
[go]: https://golang.org/
[sc]: https://staticcheck.io/
