#!/bin/sh
set -e

zsh=$(readlink -f ../../tag-zsh/oh-my-zsh)

# Clone robbyrussel/oh-my-zsh
if [ ! -e $zsh ]; then
    git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh $zsh
fi
