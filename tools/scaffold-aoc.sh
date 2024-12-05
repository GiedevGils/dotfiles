#!/usr/bin/env bash

if [ -z "$2" ]; then
  echo "usage: scaffold-aoc year foldername"
  exit 1;
fi

mkdir -p $1/$2

touch $1/$2/1.js
touch $1/$2/2.js
touch $1/$2/lib.js
touch $1/$2/input.txt

cd $1/$2
