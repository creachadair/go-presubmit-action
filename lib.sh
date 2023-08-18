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

istrue() {
    local v="${1:-}"
    case "$v" in
        (y|yes|t|true|1)
            return 0
            ;;
        (*)
            return 1
            ;;
    esac
}
