# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH:$HOME/.cargo/bin:$HOME/bin

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.rustup/toolchains/nightly-2018-10-18-x86_64-unknown-linux-gnu/lib:$HOME/.rustup/toolchains/nightly-2018-10-18-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="clean"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  cargo
  rust
  tmux
  colored-man-pages
)

source $ZSH/oh-my-zsh.sh

if env | grep -q vim; then
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if (( $+commands[xclip] )) ; then
    alias xclip="xclip -selection c"
    alias getclip="xclip -selection c -o"
fi

source "$HOME/.vim/plugged/gruvbox/gruvbox_256palette.sh"

