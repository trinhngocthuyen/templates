#!/usr/bin/env zsh

for lib_file in "$(dirname $0)"/lib/*.zsh; do
    source "${lib_file}"
done
unset lib_file
