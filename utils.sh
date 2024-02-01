###
# Print an info-level message.
###
info() {
	printf "\r[ \033[00;34m..\033[0m ] $1\n"
}

###
# Print a warning-level message.
###
warn() {
	printf "\r[ \033[0;33m??\033[0m ] $1\n"
}

###
# Print a success-level message.
###
success() {
	printf "\r\033[2K[ \033[00;32mOK\033[0m ] $1\n"
}

###
# Print a fail-level message and exit the process by 1.
###
fail() {
	printf "\r\033[2K[\033[0;31mFAIL\033[0m] $1\n"
	echo ''
	exit 1
}

###
# Confirm Y/n
#
# @param $1 The prompt message.
# @returns {Boolean}
#
# @example
#  if confirm "already exists, overwrite?"; then
#    echo "something"
#  fi
#
###
confirm() {
	read -p "$1 (Y/n): " resp

	if [ -z "$resp" ]; then
		response_lc="y" # empty is Yes
	else
		response_lc=$(echo "$resp" | tr '[:upper:]' '[:lower:]') # case insensitive
	fi

	[ "$response_lc" = "y" ]
}

###
# Expand
#
# @param $1 The prompt message
# @param $... Options, e.g. [s]kip [o]verwrite
# @returns {String} $expand_result User input result.
#
###
expand() {
	local args els desc

	args=("$@")
	els=${#args[@]}
	desc=""

	for ((i = 1; i < $els; i++)); do
		if [[ i -eq 1 ]]; then
			desc+="${args[${i}]}"
		else
			desc+=", ${args[${i}]}"
		fi
	done

	info "$1\n$desc?"

	read -n 1 expand_result </dev/tty
}
