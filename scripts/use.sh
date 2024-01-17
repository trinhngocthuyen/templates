#!/bin/bash
set -e

run() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
        -t|--template) TEMPLATE="$2"; shift 2; ;;
        -d|--dir) WORKING_DIR="$2"; shift 2; ;;
        -s|--sub) SUBSTITUTE_CONTENT="$2"; shift 2; ;;
        *) shift ;;
        esac
    done

    WORKING_DIR="${WORKING_DIR:-$(PWD)}"
    TMP_DIR=$(mktemp -d -t templates)
    REPO_DIR=${REPO_DIR:-${TMP_DIR}/templates}
    TEMPLATE_REPO_URL=git@github.com:trinhngocthuyen/templates.git
    trap "rm -rf ${TMP_DIR}" EXIT

    if [[ "${CLONE}" != "false" ]]; then
        rm -rf ${REPO_DIR} && mkdir -p ${REPO_DIR}
        git clone --single-branch --depth=1 ${TEMPLATE_REPO_URL} ${REPO_DIR}
    fi

    source "${REPO_DIR}/scripts/base"
    log_debug "Repo dir: ${REPO_DIR}"

    AVAILABLE_TEMPLATES=$(find "${REPO_DIR}/templates" -depth 1 -type d -not -name _metadata | xargs -I x basename x)
    if [[ -z "${TEMPLATE}" ]]; then
        log_warning "What template to use? Available templates: ${AVAILABLE_TEMPLATES}"
        read_input "Enter the template name" TEMPLATE
    fi
    log_debug "Template: ${TEMPLATE}"

    TEMPLATE_DIR="${REPO_DIR}/templates/${TEMPLATE}"
    TEMPLATE_UNPACKED_TMP_DIR="${TMP_DIR}/template-unpacked"

    if [[ ! -d "${TEMPLATE_DIR}" ]]; then
        log_error -b "No such template: ${TEMPLATE}!"
        log_error -b "Available templates: ${AVAILABLE_TEMPLATES}"
        exit 1
    fi

    fill_placeholder_contents() {
        rm -rf "${TEMPLATE_UNPACKED_TMP_DIR}"
        cp -r "${TEMPLATE_DIR}/" "${TEMPLATE_UNPACKED_TMP_DIR}"
        log_debug "Filling placeholder contents..."
        pip3 show jinja2 &> /dev/null || pip3 install jinja2
        "${REPO_DIR}/scripts/sub" --name ${TEMPLATE} --dir "${TEMPLATE_UNPACKED_TMP_DIR}" --replace "${SUBSTITUTE_CONTENT}"
    }

    log_info -b "Unpacking template: ${TEMPLATE}..."
    fill_placeholder_contents
    rsync --exclude=**/{.git,.build,__pycache__} -ra "${TEMPLATE_UNPACKED_TMP_DIR}/" "${WORKING_DIR}"
}

if [[ "$0" = *install.sh ]]; then
    run "$@"
else
    run "$0" "$@"
fi
