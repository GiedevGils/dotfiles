# Install

On how to install. 

I have chosed to use a bare git repo. It is cloned into a folder, and then uses the $HOME folder as its workspace. That workspace does not show untracked files, and I have set up a zsh alias to use for this repo specifically (can be found in `.config/shortcuts`).

## Prerequisites
1. ZSH needs to be installed.

## Commands
- `git clone git@gitlab.com/GiedevGils/dotfiles.git $HOME/.cfg --bare`
- `source ~/.zshrc`
- `gcfg config --local status.showUntrackedFiles no`