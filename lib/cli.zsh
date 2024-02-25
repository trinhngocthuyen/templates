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

    case "$command" in
        update) ;;
        *) _templates::auto-update ;;
    esac

    _templates::$command "$@"
}

function _templates::help {
    cat >&2 <<EOF
Usage: templates <command> [options]

Available commands:

    help                Print this help message
    list                List available templates
    use <template>      Use a template
    update              Update templates
    reload              Reload the CLI
EOF
}

function _templates::list {
    find "$(_templates::dir)/templates" -depth 1 -type d -exec basename {} \;
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
    date +%s > ~/.templates_last_update
    env TEMPLATES_DIR="$(_templates::dir)" zsh $(_templates::dir)/scripts/upgrade.sh
    _templates::reload
}

function _templates::auto-update {
    local last_update=0
    if [[ -f ~/.templates_last_update ]]; then
        last_update=$(cat ~/.templates_last_update)
    fi
    local duration=$(expr $(date +%s) - ${last_update})
    if [[ ${duration} -gt 259200 ]]; then # 3 days
        echo -n "Would you like to update templates? [Y/n] "
        read -r -k 1 option
        [[ "$option" = $'\n' ]] || echo
        case "$option" in
            [yY$'\n']) _templates::update ;;
            [nN]) date +%s > ~/.templates_last_update ;&
            *) echo "You can update manually by running \`templates update\`" ;;
        esac
    fi
}

function _templates::reload {
    omz reload # Just trigger `omz reload`
}
