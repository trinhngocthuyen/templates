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
    _templates::log::wip
}

function _templates::use {
    env CLONE=false REPO_DIR="$(_templates::dir)" \
        sh "$(_templates::dir)"/scripts/use.sh
}

function _templates::update {
    env TEMPLATES_DIR="$(_templates::dir)" zsh $(_templates::dir)/scripts/upgrade.sh
}
