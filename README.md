# Go Presubmit Checks Action

This repository defines a GitHub action to perform presubmit checks for a
repository containing Go source code. The checks performed include:

1. Ensure that all source files are formatted with  `go fmt`.
2. Ensure that all unit tests pass.
3. Ensure the `staticcheck` tool does not report any warnings.

The following example workflow demonstrates its use:

```yaml
name: Go presubmit

on:
  - push

jobs:
  build:
    name: Go presubmit
    runs-on: ubuntu-latest
    steps:
    - name: Install Go 1.15
      uses: actions/setup-go@v1
      with:
        go-version: '1.15'
    - uses: actions/checkout@v2
    - uses: creachadair/go-presubmit-action@default
```
