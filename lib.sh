# Shared helpers.

readonly go_version="$(go version | cut -d' ' -f3)"

label() { printf "▷ \033[1;36m$*\033[0m\n" ; }

module() { printf "🛠  \033[1;97m$*\033[0m\n" ; }

check() {
    if [[ $? -ne 0 ]] ; then
        printf "\033[50C\033[1;31mFAILED\033[0m\n"
        exit 1
    else
        printf "\033[50C\033[1;32mSUCCESS\033[0m\n"
    fi
}

# pkgpath prints the specified package name decorated with a version.
# If the current module has a dependency on the package already, the package is
# reported without a specific version; otherwise the given version is appended,
# or "latest" if no specific version is given.
pkgpath() {
    local base="${1:?missing package path}"
    local vers="${2:-latest}"
    # N.B.: Exclude tests of dependencies for this check.
    if go mod why -vendor "$base" | grep -q 'does not need to vendor package' ; then
        echo "$base"@"$vers"
    else
        echo "$base"
    fi
}

istrue() {
    local v="${1:-}"
    case "$v" in
        (y|yes|t|true|1)
            return 0
            ;;
        (n|no|f|false|0)
            return 1
            ;;
        (*)
            echo "Invalid Boolean flag '$v'" 1>&2
            exit 1
            ;;
    esac
}
