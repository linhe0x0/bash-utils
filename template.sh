#!/usr/bin/env bash

# Exit immediately if a simple command exits with a non-zero status, unless
# the command that fails is part of an until or while loop, part of an
# if statement, part of a && or || list, or if the command's return status
# is being inverted with !. Treat unset variables as errors (-u), and
# propagate pipeline errors from all commands (pipefail).
set -euo pipefail

# Set the WORKING_DIR to the directory of the current script.
WORKING_DIR=$(pwd)

# source utils
source "${WORKING_DIR}"/utils.sh

# do something
success "Great!"
