#!/bin/bash
FILE="$1"

# 1. THE MAGIC FIX: Send the Kitty protocol command to delete all active images
printf "\x1b_Ga=d\x1b\\"

# 2. Safely check the mime type
MIME=$(file -b --mime-type "$FILE" 2>/dev/null)

# 3. Grab the exact size of the fzf preview window
COLS=${FZF_PREVIEW_COLUMNS:-40}
LINES=${FZF_PREVIEW_LINES:-40}

case "$MIME" in
    image/*)
        # Draw the new image constrained to the fzf pane size
        chafa --format=kitty --size="${COLS}x${LINES}" "$FILE"
        ;;
    application/pdf)
        pdftotext "$FILE" - | head -n 100
        ;;
    *)
        bat --color=always --style=plain "$FILE" 2>/dev/null || cat "$FILE" 2>/dev/null
        ;;
esac
