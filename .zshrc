# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"

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
plugins=(git zsh-z zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

eval "$(/opt/homebrew/bin/brew shellenv)"
# PATH=$HOME/bin:/opt/homebrew/opt/go@1.19/bin:usr/local/bin:$HOME/go/bin:$PATH
PATH=/nix/var/nix/profiles/default/bin:$HOME/bin:/opt/homebrew/Cellar/go/1.20.2/bin:usr/local/bin:$HOME/go/bin:$HOME/tools:$HOME/scripts:$PATH
# PATH=$HOME/bin:usr/local/bin:$HOME/go/bin:$PATH

# Theta Lake specific
# per https://bitbucket.org/thetalake/localdev/src/master/
alias localdev='~/code/localdev/localdev'

alias c="code ."
alias cz="code ~/.zshrc"
alias sz="source ~/.zshrc"
alias caws="code ~/.aws/config"
alias cawsc="code ~/.aws/credentials"
alias ohmyzsh="code ~/.oh-my-zsh"

alias g="git"
alias gs="git status"
alias gd="git diff"
alias gdt="git difftool"
alias gdlist="git diff --name-status"
alias gcm="git commit -m"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gcom="git checkout master && git pull"
alias gignore="c .git/info/exclude  "
alias gopen="nix-shell -p git-open"
alias goi="go install ./... && go vet ./..."
alias ll="exa"
alias runingester="export INGESTER_ENV=.env && goi && ingester > tmp.txt"
# alias runintegrator="export INTEGRATOR_ENV=.env && goi && integrator | code -"
alias runintegrator="export INTEGRATOR_ENV=.env && goi && integrator  > tmp.txt"
alias runemailpreprocessor="ENV_FILE=preprocessor.env.localdev go run ./cmd/email_preprocessor/..."
alias telcon="tsh login --proxy=thetalake.teleport.sh --auth=google"
# alias colcon="echo 'creating an ssh tunnel to dev collector via teleport...\ntsh ssh -N -L 27777:localhost.thetalake.com:13579 ubuntu@ingester2.dev1.thetalake.com' && tsh ssh -N -L 27777:localhost.thetalake.com:13579 ubuntu@ingester2.dev1.thetalake.com"
alias colcon="echo 'creating an ssh tunnel to dev collector via teleport...\ntsh ssh -N -L 27777:localhost.thetalake.com:13579 ubuntu@ingester1.dev1.thetalake.com' && tsh ssh -N -L 27777:localhost.thetalake.com:13579 ubuntu@ingester1.dev1.thetalake.com"
alias escon="escon.sh"
alias esclose="esclose.sh"
alias lf="nix run nixpkgs#lf"


# use vscode as default editor (for git and stuff)
# https://bitfieldconsulting.com/golang/vs-code-go
export EDITOR="code --wait"
function gcpb(){
    git branch | grep \* | cut -d ' ' -f2 | pbcopy
}

function gsquash(){
    git reset --soft HEAD~$1
}

function cpd(){
    pwd | pbcopy
}

nixify() {
  if [ ! -e ./.envrc ]; then
    echo "use nix" > .envrc
    direnv allow
  fi
  if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
    cat > default.nix <<'EOF'
with import <nixpkgs> {};
mkShell {
  nativeBuildInputs = [
    bashInteractive
  ];
}
EOF
    ${EDITOR:-vim} default.nix
  fi
}
flakify() {
  if [ ! -e flake.nix ]; then
    nix flake new -t github:nix-community/nix-direnv .
  elif [ ! -e .envrc ]; then
    echo "use flake" > .envrc
    direnv allow
  fi
  ${EDITOR:-vim} flake.nix
}

export scalyr_readlog_token='0bOzw_U_GGCB2mxlBzxSEsRSISja6JPucJpM6rFUXW8g-'
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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# from https://direnv.net/docs/hook.html to hook into direnv
eval "$(direnv hook zsh)"