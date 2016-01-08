#!/bin/sh
set -e

tpm=$(readlink -f ../../tag-tmux)/tmux/plugins/tpm

# Clone tmux-plugins/tpm
if [ ! -e $tpm ]; then
    mkdir -p $(dirname $tpm)
    git clone --depth 1 https://github.com/tmux-plugins/tpm $tpm
fi
