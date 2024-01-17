#!/usr/bin/env zsh

function templates {
    [[ $# -gt 0 ]] || {
        _templates::help
        return 1
    }

    local command="$1"
    shift

    (( ${+functions[_templates::$command]} )) || {
        _templates::help
        return 1
    }

    _templates::$command "$@"
}

function _templates {
    local -a cmds
    cmds=(
        'help:Usage information'
        'list:List available templates'
        'use:Use a template'
        'update:Update templates'
    )
    if (( CURRENT == 2 )); then
        _describe 'command' cmds
    fi
}

if (( ${+functions[compdef]} )); then
    compdef _templates templates
fi

function _templates::help {
    cat >&2 <<EOF
Usage: templates <command> [options]

Available commands:

    help                Print this help message
    list                List available templates
    use <template>      Use a template
    update              Update templates
EOF
}

function _templates::list {
    find "$(_templates::dir)/templates" -depth 1 -type d -not -name _metadata -exec basename {} \;
}

function _templates::use {
    if [[ -z "$1" ]]; then
        echo >&2 "Usage: ${(j: :)${(s.::.)0#_}} <template> [...]"
        return 1
    fi

    local template=$1
    local template_dir="$(_templates::dir)/templates/${template}"
    local tmp_dir=$(mktemp -d -t templates)
    trap "rm -rf ${tmp_dir}" EXIT

    if [[ ! -d "${template_dir}" ]]; then
        _templates::log error "No such template: ${template}!"
        _templates::log info "Available templates:" $(_templates::list)
        return 1
    fi

    _templates::log debug "Unpacking template: ${template}..."
    rsync -ra "${template_dir}/" "${tmp_dir}"
    pip3 show jinja2 &> /dev/null || pip3 install jinja2
    python3 "$(_templates::dir)/scripts/sub.py" --name ${template} --dir "${tmp_dir}"
    rsync --exclude={.git,.build,__pycache__} -ra "${tmp_dir}/" .
}

function _templates::update {
    env TEMPLATES_DIR="$(_templates::dir)" zsh $(_templates::dir)/scripts/upgrade.sh
}
