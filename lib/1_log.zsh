function _templates::log {
    local logtype=$1
    shift
    case "$logtype" in
        prompt) print -Pn "%F{blue}$@%F{reset}" ;;
        debug) print -P "%F{white}$@%F{reset}" ;;
        info) print -P "%F{green}$@%F{reset}" ;;
        warn) print -P "%F{yellow}$@%F{reset}" ;;
        error) print -P "%F{red}$@%F{reset}" ;;
    esac >&2
}

function _templates::log::wip {
    local caller="${functrace[1]}"
    _templates::log warn "Code at ${caller} is still WIP"
}
