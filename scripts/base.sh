#!/bin/bash
set -e

ansi_color() {
    local color_code=$1
    case $2 in
    -b|--bold)
        color_code="\x1b[1;${color_code}"
        shift 2
        ;;
    *)
        shift 1
        ;;
    esac
    echo "\033[${color_code}$@\033[0m"
}
log() { ansi_color $@ ; }
log_debug() { log 37m $@ ; }
log_info() { log 32m $@ ; }
log_warning() { log 33m $@ ; }
log_error() { log 31m $@ ; }

read_input() { read -p "$(log_debug -b "$1: ") " "$2" ; }
confirm() {
    local flag=${2:-flagval}
    read_input "$1 [Y/n]" ${flag};
    local flagval=${flagval:-${!flag}}
    [[ "${flagval}" == "y" ]] && return 0 || return 1
}
