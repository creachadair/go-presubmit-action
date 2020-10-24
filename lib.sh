# Shared helpers.

label() { printf "▷ \033[1;36m$*\033[0m\n" ; }

check() {
    if [[ $? -ne 0 ]] ; then
	printf "\033[50C\033[1;31mFAILED\033[0m\n"
	exit 1
    else
	printf "\033[50C\033[1;32mSUCCESS\033[0m\n"
    fi
}
