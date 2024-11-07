export ZSH="$HOME/.oh-my-zsh"
plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)
source $HOME/.oh-my-zsh/oh-my-zsh.sh

env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

source ~/.config/hooks
[ -f ~/.config/shortcuts ] && . ~/.config/shortcuts

# Created by `pipx` on 2024-11-07 14:01:39
export PATH="$PATH:/home/ubuntu/.local/bin"

eval "$(starship init zsh)"
export ACKRC="$HOME/.config/ack/ackrc"



