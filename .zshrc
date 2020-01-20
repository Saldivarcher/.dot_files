# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH:$HOME/.cargo/bin:$HOME/bin:$HOME/.local/bin

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  gitfast
  zsh-autosuggestions
  zsh-syntax-highlighting
  cargo
  rust
  colored-man-pages
)

source $ZSH/oh-my-zsh.sh

# Need to stop opening vim in an emulator!
if env | grep -q VIMRUNTIME; then
    cmd="echo \"you're in vim!\""
    alias vim="$cmd"
    alias nvim="$cmd"
else
    alias vim="nvim"
    alias vimf="nvim \$(fzf)"
fi

# Open gdb in quiet mode
alias gdb="gdb -q"
alias rust-gdb="rust-gdb -q"

# If you accidentally leave a directory you can go back with this
alias back="cd -"

alias l='exa'
alias la='exa -a'
alias ll='exa -lah'
alias ls='exa --color=auto'

# tmux can become wonky at times after an ssh session
alias reset-display="export DISPLAY=:0.0"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if (( $+commands[xclip] )) ; then
    alias xclip="xclip -selection c"
    alias getclip="xclip -selection c -o"
fi

# Caps-Lock to control using "setxkbmap"
if (($+commands[setxkbmap])) ; then
    if env | grep -q DISPLAY; then
        setxkbmap -option caps:ctrl_modifier
    fi
    alias set-ctrl="setxkbmap -option caps:ctrl_modifier"
fi

if (($+commands[pacmd])) ; then
    alias set-headphones='pacmd set-default-sink "alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.analog-mono"'
fi

fpath+=~/.dot_files/.zfunc
export EDITOR=nvim

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

export PATH="/home/migsaldivar/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

