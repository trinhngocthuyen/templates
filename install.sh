#!/bin/bash
set -e

if [[ "$0" = *install.sh ]]; then args=$@; else args="$0 $@"; fi

run() {
    while getopts "t:d:s:" flag; do
        case ${flag} in
        t) TEMPLATE=${OPTARG};;
        d) WORKING_DIR=${OPTARG};;
        s) SUBSTITUTE_CONTENT=${OPTARG};;
        esac
    done

    WORKING_DIR="${WORKING_DIR:-$(PWD)}"
    TMP_DIR=$(mktemp -d -t templates)
    REPO_DIR=${REPO_DIR:-${TMP_DIR}/templates}
    TEMPLATE=${TEMPLATE:--}
    TEMPLATE_REPO_URL=git@github.com:trinhngocthuyen/templates.git
    trap "rm -rf ${TMP_DIR}" EXIT

    if [[ "${CLONE}" != "false" ]]; then
        rm -rf ${REPO_DIR} && mkdir -p ${REPO_DIR}
        git clone --single-branch --depth=1 ${TEMPLATE_REPO_URL} ${REPO_DIR}
    fi

    source "${REPO_DIR}/scripts/base"
    TEMPLATE_DIR="${REPO_DIR}/templates/${TEMPLATE}"
    TEMPLATE_UNPACKED_TMP_DIR="${TMP_DIR}/template-unpacked"

    log_debug "Repo dir: ${REPO_DIR}"
    log_debug "Template: ${TEMPLATE}"

    if [[ ! -d "${TEMPLATE_DIR}" ]]; then
        log_error -b "No such template: ${TEMPLATE}!"
        log_error -b "Available templates: $(find "${REPO_DIR}/templates" -depth 1 -type d | xargs -I x basename x)"
        exit 1
    fi

    fill_placeholder_contents() {
        rm -rf "${TEMPLATE_UNPACKED_TMP_DIR}"
        cp -r "${TEMPLATE_DIR}/" "${TEMPLATE_UNPACKED_TMP_DIR}"
        if [[ ! -z ${SUBSTITUTE_CONTENT} ]]; then
            log_debug "Filling placeholder contents..."
            pip3 show jinja2 &> /dev/null || pip3 install jinja2
            "${REPO_DIR}/scripts/sub" --dir "${TEMPLATE_UNPACKED_TMP_DIR}" --map "${SUBSTITUTE_CONTENT}"
        fi
    }

    log_info -b "Unpacking template: ${TEMPLATE}..."
    fill_placeholder_contents
    rsync --exclude=**/{.git,.build,__pycache__} -ra "${TEMPLATE_UNPACKED_TMP_DIR}/" "${WORKING_DIR}"
}

run ${args}
