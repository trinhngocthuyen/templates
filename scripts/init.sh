#!/bin/bash
set -e

while getopts "t:d:" flag; do
    case ${flag} in
    t) TEMPLATE=${OPTARG};;
    d) REPO_DIR=${OPTARG};;
    esac
done

REPO_DIR=${REPO_DIR:-/var/tmp/templates}
TEMPLATE=${TEMPLATE:--}
TEMPLATE_REPO_URL=git@github.com:trinhngocthuyen/templates.git

if [[ "${CLONE}" != "false" ]]; then
    rm -rf ${REPO_DIR} && mkdir -p ${REPO_DIR}
    git clone --single-branch --depth=1 ${TEMPLATE_REPO_URL} ${REPO_DIR}
fi

source "${REPO_DIR}/scripts/base.sh"
TEMPLATE_DIR="${REPO_DIR}/templates/${TEMPLATE}"

log_debug "Repo dir: ${REPO_DIR}"
log_debug "Template: ${TEMPLATE}"

if [[ ! -d "${TEMPLATE_DIR}" ]]; then
    log_error -b "No such template: ${TEMPLATE}!"
    log_error -b "Available templates: $(find "${REPO_DIR}/templates" -depth 1 -type d | xargs -I x basename x)"
    exit 1
fi

log_info -b "Unpacking template: ${TEMPLATE}..."
cp -r "${TEMPLATE_DIR}/" .
