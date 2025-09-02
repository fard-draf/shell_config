
# ======= ALIAS GIT =======
alias gt='git'
alias gts='git status'
alias gta='git add'
alias gtaa='git add --all'
alias gtc='git commit -m'
alias gtp='git push'
alias gtl='git pull'
alias gtco='git checkout'
alias gtcb='git checkout -b'
alias gtb='git branch'
alias gtd='git diff'
alias gtlog='git log --oneline --graph --decorate'
alias gtnah='git reset --hard && git clean -df'  # Annule tous les changements locaux
alias gtundo='git reset HEAD~1'                 # Annule le dernier commit
alias gtsync='git pull origin $(git rev-parse --abbrev-ref HEAD)' # Synchro avec remote

alias git-al="show_aliases_from_file $DOTFILES/shell/zsh/conf/git.zsh"
