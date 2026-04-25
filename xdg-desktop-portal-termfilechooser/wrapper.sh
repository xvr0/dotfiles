#!/bin/sh
set -e

multiple="$1"
directory="$2"
save="$3"
path="$4"
out="$5"

# --- CHANGE THIS TO YOUR TERMINAL ---
termcmd="kitty --"
# ------------------------------------

# Fallback path logic
# if [ -d "$path" ]; then
#     search_dir="$path"
# elif [ -f "$path" ]; then
#     search_dir="$(dirname "$path")"
# else
    search_dir="$HOME"
# fi

# The preview command (uses bat, falls back to cat, falls back to file)
# preview_cmd="bat --color=always --style=plain {} 2>/dev/null || cat {} 2>/dev/null || file {}"
# Get the directory where the wrapper script lives
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Tell fzf to pass the file path ({}) to your new preview script
preview_cmd="$SCRIPT_DIR/preview.sh {}"
if [ "$save" = "1" ]; then
    # SAVE MODE
    $termcmd sh -c "echo 'Saving in: $search_dir'; echo 'Type filename:'; read -r filename; echo \"$search_dir/\$filename\" > \"$out\""

elif [ "$multiple" = "1" ]; then
    # OPEN MODE (MULTI-FILE ALLOWED) - With Preview!
    $termcmd sh -c "find \"$search_dir\" ! -path '*/\.*' 2>/dev/null | fzf -m --preview '$preview_cmd' --preview-window='right:50%:border-left' --prompt='Multiple Files (Use Tab)> ' > \"$out\""

else
    # OPEN MODE (SINGLE FILE ONLY) - With Preview!
    $termcmd sh -c "find \"$search_dir\" ! -path '*/\.*' 2>/dev/null | fzf --preview '$preview_cmd' --preview-window='right:50%:border-left' --prompt='1 File Only (Tab Disabled)> ' > \"$out\""
fi
