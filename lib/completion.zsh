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
    elif (( CURRENT == 3 )); then
        case "$words[2]" in
            use)
                local -aU available_templates
                available_templates=($(_templates::list))
                _describe 'template' available_templates ;;
        esac
    fi
}

if (( ${+functions[compdef]} )); then
    compdef _templates templates
fi
