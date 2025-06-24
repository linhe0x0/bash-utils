BOLD="$(tput bold 2>/dev/null || printf '')"
GREY="$(tput setaf 0 2>/dev/null || printf '')"
UNDERLINE="$(tput smul 2>/dev/null || printf '')"
RED="$(tput setaf 1 2>/dev/null || printf '')"
GREEN="$(tput setaf 2 2>/dev/null || printf '')"
YELLOW="$(tput setaf 3 2>/dev/null || printf '')"
BLUE="$(tput setaf 4 2>/dev/null || printf '')"
MAGENTA="$(tput setaf 5 2>/dev/null || printf '')"
NO_COLOR="$(tput sgr0 2>/dev/null || printf '')"

###
# Print an info-level message.
###
info() {
  printf '%s\n' "${BOLD}${BLUE}>${NO_COLOR} $*"
}

###
# Print a warning-level message.
###
warn() {
  printf '%s\n' "${YELLOW}! $*${NO_COLOR}"
}

###
# Print a success-level message.
###
success() {
  printf '%s\n' "${GREEN}✓${NO_COLOR} $*"
}

###
# Print a fail-level message and exit the process by 1.
###
error() {
  printf '%s\n' "${RED}x $*${NO_COLOR}" >&2
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
# Link files
#
# @param $1 The source file path you want to link.
# @param $2 The destination file path you want to link to.
###
link_file() {
  info "Linking files: $1 => $2"

  local src=$1 dst=$2

  local action= overwrite= backup= skip=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then
    local currentSrc="$(readlink $dst)"

    if [ "$currentSrc" == "$src" ]; then
      skip=true
    else
      info "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
              [s]kip, [o]verwrite, [b]ackup?"
      read -n 1 action </dev/tty

      case "$action" in
        o)
          overwrite=true
          ;;
        b)
          backup=true
          ;;
        s)
          skip=true
          ;;
        *) ;;
      esac
    fi

    if [ "$overwrite" == "true" ]; then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]; then
      mv "$dst" "${dst}.bak"
      success "moved $dst to ${dst}.bak"
    fi

    if [ "$skip" == "true" ]; then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]; then # "false" or empty
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi

  success "Files linked"
}
