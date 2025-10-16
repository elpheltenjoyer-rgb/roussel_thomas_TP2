#!/bin/sh
echo -ne '\033c\033]0;project_sol\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/project_sol.x86_64" "$@"
