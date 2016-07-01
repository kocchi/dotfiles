# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# カラー設定
export TERM=xterm-256color

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="wezm+"
#ZSH_THEME="ramdom"

# Example aliases
 #alias vim="$HOME/local/bin/vim"
 alias zshconfig="mate ~/.zshrc"
 alias ohmyzsh="mate ~/.oh-my-zsh"
 __git_files() { _files }

# iTerm Shell Integration
# https://iterm2.com/documentation-shell-integration.html
source ~/.iterm2_shell_integration.zsh

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git mysql brew themes)

source $ZSH/oh-my-zsh.sh

# User configuration

source ~/perl5/perlbrew/etc/bashrc
#PATH=~/.plenv/shims:$PATH

PATH=/usr/local/bin:$PATH
PATH=$PATH:$HOME/local/bin
PATH=$PATH:/usr/local/share/npm/bin

export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH=$HOME/.nodebrew/current/bin:$PATH

export PATH
alias sudo="sudo env PATH=$PATH"
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

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# rakudobrew
export PATH=~/.rakudobrew/bin:$PATH

bindkey "^R" history-incremental-search-backward
# タイポ修正
setopt correct

## github上でmergeされたローカルブランチを一括削除する
## http://qiita.com/yuya_presto/items/45dca5902107eb7f263a
git-prune-branches () {
    git fetch --prune origin && git branch --merged origin/master | grep -vE ' master$|^\*' | xargs git branch -d
}

git-prune-branches-dry-run() {
    git fetch --dry-run --prune origin
    git fetch origin && git branch --merged origin/master | grep -vE ' master$|^\*' | xargs echo git branch -d
}

eval "$(hub alias -s)"

#source $ZSH/oh-my-zsh.sh

if [ -z $TMUX ]; then
  if $(tmux has-session 2> /dev/null); then
    tmux -2 attach
  else
    tmux -2
  fi
fi

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        awk '!a[$0]++' | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history



fpath=(/path/to/homebrew/share/zsh-completions $fpath)

autoload -U compinit
compinit -u
autoload -U compinit
compinit -u


function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# The next line updates PATH for the Google Cloud SDK.
source '/Users/yuki.hirako/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/Users/yuki.hirako/google-cloud-sdk/completion.zsh.inc'
