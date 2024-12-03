#!/bin/zsh

if [ -z "$1" ]; then
  echo "usage: zcode <folder>"
  exit 1;
fi

source ~/.zshrc
z $1
code .
