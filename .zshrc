###############
# environment #
###############

export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"

# IHP PDK
export PDK_ROOT="$HOME/pdks/IHP-Open-PDK"
export PDK="ihp-sg13g2"

export ELITBOARDDIR="$HOME/nes/arm/toolchain/bin"

###############
# oh-my-zsh   #
###############

ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

###############
# PATH        #
###############

path=(
  /usr/local/texlive/2024/bin/x86_64-linux
  /sbin /bin /usr/local/sbin /usr/local/bin /usr/bin /usr/sbin
  /usr/bin/site_perl /usr/bin/vendor_perl /usr/bin/core_perl
  $HOME/.cargo/bin
  $HOME/.scripts
  $ELITBOARDDIR
  $HOME/intelFPGA/20.1/modelsim_ase/bin
  $HOME/intelFPGA_lite/20.1/quartus/bin
  $HOME/LEL/plecs
)

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/xaver/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/xaver/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/xaver/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/xaver/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/xaver/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# after conda so these take precedence over its python etc.
path=(
  /opt/riscv-gnu-toolchain-multi/bin
  $HOME/bin
  $HOME/.local/bin
  $path
)

###############
# aliases     #
###############

alias cl='~/clean.sh'
alias cb='tee >(xclip -selection clipboard)'
alias del='trash-put'
alias tvim='NVIM_APPNAME=nvim-tmux nvim'
alias matlab="LD_PRELOAD=\"/usr/lib/libgnutls.so.30 /usr/lib/libstdc++.so.6 /usr/lib/libgcc_s.so.1\" ~/matlab_latest/bin/matlab"

###############
# fzf         #
###############

source <(fzf --zsh)

# fz <ext>: pick a file with fzf (with preview) and open it in the matching app
fz() {
    if [[ -z "$1" ]]; then
        echo "Usage: fz <extension> (e.g., fz pdf)"
        return 1
    fi

    local ext="$1"
    local -A app_map=(
        [pdf]="zathura"
        [png]="feh"
        [jpg]="feh"
        [jpeg]="feh"
        [gif]="feh"
        [mp4]="mpv"
        [mkv]="mpv"
    )
    local app="${app_map[$ext]:-nvim}"

    # clears images from kitty's graphics layer so previews don't stick around
    local wipe_kitty="printf '\x1b_Ga=d\x1b\\\\'"

    local preview_cmd
    case "$ext" in
        png|jpg|jpeg|gif)
            preview_cmd="$wipe_kitty; chafa --format=kitty --size=\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES} {}" ;;
        pdf)
            preview_cmd="$wipe_kitty; pdftotext {} - | head -n 100" ;;
        *)
            preview_cmd="$wipe_kitty; bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {} 2>/dev/null" ;;
    esac

    local file
    file="$(fd -t f -e "$ext" | fzf --preview "$preview_cmd" --preview-window=right:60% --border)"
    eval "$wipe_kitty"
    [[ -z "$file" ]] && return

    if [[ "$app" == "nvim" ]]; then
        "$app" "$file"
    else
        "$app" "$file" > /dev/null 2>&1 & disown
    fi
}

###############
# yazi        #
###############

# y: open yazi and cd into the directory it was closed in
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
