# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export OMP_NUM_THREADS=1
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ELITBOARDDIR="$HOME/nes/arm/toolchain/bin"
# alias vi-latex='NVIM_APPNAME=nvim-latex nvim'
# Set environment variables for IHP PDK
export PDK_ROOT="$HOME/pdks/IHP-Open-PDK"
export PDK="ihp-sg13g2"

alias cl='~/clean.sh'
alias cp='tee >(xclip -selection cipboard)'

rg() {
    TEMPFILE="$(mktemp)"
    ranger --choosedir="$TEMPFILE" "$@"
    if [ -f "$TEMPFILE" ]; then
        local NEW_DIR="$(cat "$TEMPFILE")"
        rm -f "$TEMPFILE"
        if [ -n "$NEW_DIR" ] && [ -d "$NEW_DIR" ]; then
            cd "$NEW_DIR"
        fi
    fi
}
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
PATH=/usr/local/texlive/2024/bin/x86_64-linux:/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/xaver/.cargo/bin:/home/xaver/.scripts:$ELITBOARDDIR


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

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/home/xaver/intelFPGA/20.1/modelsim_ase/bin"
# export PATH="$HOME/matlab/2025/bin:$PATH"
export PATH="$PATH:/home/xaver/intelFPGA_lite/20.1/quartus/bin"
export PATH="$PATH:/home/xaver/LEL/plecs"
export PATH="$PATH:/usr/local/MATLAB/R2024b/bin"
alias del='trash-put'
source <(fzf --zsh)
# Zathura FZF wrapper
fz() {
    if [[ -z "$1" ]]; then
        echo "Usage: fz <extension> (e.g., fz pdf)"
        return 1
    fi

    local ext="$1"
    
    local -A app_map
    app_map=(
        [pdf]="zathura"
        [png]="feh"
        [jpg]="feh"
        [jpeg]="feh"
        [mp4]="mpv"
        [mkv]="mpv"
        [gif]="feh"
    )

    local app="${app_map[$ext]:-nvim}"
    
    # --- PREVIEW LOGIC ---
    # The magic wipe command to delete images from Kitty's graphics layer
    local wipe_kitty="printf '\x1b_Ga=d\x1b\\\\'"

    # Default previewer: bat or cat
    # Notice we prepend the wipe command so text files don't render on top of old images
    local preview_cmd="$wipe_kitty; bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {} 2>/dev/null"
    
    # Image preview using chafa (far more stable inside fzf than icat)
    if [[ "$ext" == "png" || "$ext" == "jpg" || "$ext" == "jpeg" || "$ext" == "gif" ]]; then
        preview_cmd="$wipe_kitty; chafa --format=kitty --size=\${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES} {}"
    fi
    
    # PDF preview
    if [[ "$ext" == "pdf" ]]; then
        preview_cmd="$wipe_kitty; pdftotext {} - | head -n 100"
    fi
    # ---------------------

    # Run fzf with the dynamic preview command
    local file
    file="$(fd -t f -e "$ext" | fzf --preview "$preview_cmd" --preview-window=right:60% --border)"
    
    # If the user cancels (ESC), wipe the terminal graphics layer and exit cleanly
    if [[ -z "$file" ]]; then
        eval "$wipe_kitty"
        return
    fi

    # Wipe the terminal graphics layer one last time before opening the app
    # (Prevents the last previewed image from getting stuck on your terminal screen)
    eval "$wipe_kitty"

    # Launch the application
    if [[ "$app" == "nvim" ]]; then
        "$app" "$file"
    else
        "$app" "$file" > /dev/null 2>&1 & disown
    fi
}
