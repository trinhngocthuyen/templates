#!/bin/sh
#
# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/main/scripts/install.sh)"

set -e

TEMPLATES_DIR="${TEMPLATES_DIR:-${HOME}/.templates}"
REPO=${REPO:-trinhngocthuyen/templates}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-main}

function setup_color {
    FMT_RED=$(printf '\033[31m')
    FMT_GREEN=$(printf '\033[32m')
    FMT_YELLOW=$(printf '\033[33m')
    FMT_BLUE=$(printf '\033[34m')
    FMT_BOLD=$(printf '\033[1m')
    FMT_RESET=$(printf '\033[0m')
}

function setup_templates {
    if [[ -d "${TEMPLATES_DIR}" ]]; then
        echo "${FMT_YELLOW}The templates dir already exists at: ${TEMPLATES_DIR}${FMT_RESET}"
        read -p "${FMT_YELLOW}Remove this dir? [Y/n]: ${FMT_RESET}" confirm
        [[ "${confirm}" == [yY] ]] && rm -rf "${TEMPLATES_DIR}" || return 0
    fi

    echo "${FMT_BLUE}Cloning templates...${FMT_RESET}"
    git init --quiet "${TEMPLATES_DIR}" && cd "${TEMPLATES_DIR}" \
    && git config templates.remote origin \
    && git config templates.branch "${BRANCH}" \
    && git remote add origin "${REMOTE}" \
    && git fetch --depth=1 origin ${BRANCH} \
    && git checkout -f FETCH_HEAD &> /dev/null
    cd -
}

function setup_zshrc {
    local CONTENT='source ${TEMPLATES_DIR:-$HOME/.templates}/source-me.sh'
    grep -q "${CONTENT}" ~/.zshrc || echo "${CONTENT}" >> ~/.zshrc
}

function log_instructions {
    cat >&2 <<EOF

${FMT_GREEN}🎉 The templates repo was installed at ${TEMPLATES_DIR}.${FMT_RESET}
Now, source the ~/.zshrc file to have the CLI installed:
    ${FMT_BLUE}\$ source ~/.zshrc${FMT_RESET}
For CLI usage, run:
    ${FMT_BLUE}\$ templates help${FMT_RESET}
EOF
}

function main {
    setup_color
    setup_templates
    setup_zshrc
    log_instructions
}

main "$@"
