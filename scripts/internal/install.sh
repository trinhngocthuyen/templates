#!/bin/bash
set -e

export REPO_DIR="$(realpath $(dirname $0)/../..)"
if [[ "${REPO_DIR}" == "$(PWD)" ]]; then
    source scripts/base
    log_error -b "Please run this script in a temp dir to prevent side effects!"
    exit 1
fi
env CLONE=false "${REPO_DIR}/install.sh" "$@"
