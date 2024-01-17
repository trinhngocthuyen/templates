#!/bin/sh
set -e

TEMPLATES_DIR="${TEMPLATES_DIR:-${HOME}/.templates}"

function setup_color {
    FMT_RED=$(printf '\033[31m')
    FMT_GREEN=$(printf '\033[32m')
    FMT_YELLOW=$(printf '\033[33m')
    FMT_BLUE=$(printf '\033[34m')
    FMT_BOLD=$(printf '\033[1m')
    FMT_RESET=$(printf '\033[0m')
}

function update_templates {
    echo "${FMT_BLUE}Updating templates...${FMT_RESET}"
    local remote=${"$(git config --local templates.remote)":-origin}
    local branch=${"$(git config --local templates.branch)":-main}
    git fetch --depth=1 "${remote}"  "${branch}" \
        && git checkout -f FETCH_HEAD &> /dev/null || {
            echo "${FMT_RED}Error occurred${FMT_RESET}"
            exit 1
        }
    echo "${FMT_GREEN}-> Done!${FMT_RESET}"
}

function main {
    cd "${TEMPLATES_DIR}"
    setup_color
    update_templates
}

main "$@"
