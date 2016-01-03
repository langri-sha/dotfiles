dotfiles-local
==============

My local configurations which supplement
[`thoughtbot/dotfiles`](https://github.com/thoughtbot/dotfiles) with lasers. To
be used in conjunction with [`rcm`](https://github.com/thoughtbot/rcm#rcm).

Pew pew
-------

Take a moment first to familiarize yourself with the base set of `git`, `tmux`,
`vim` and `zsh` configurations from `thoughtbot/dotfiles`.

Features include:

* ZSH awesomeness according to [`robbyrussell/oh-my-zsh`](robbyrussell/oh-my-zsh
  )

Installing
----------

Run through the [`rcm` installation
guide](https://github.com/thoughtbot/rcm#installation).

```
cd $HOME

# Clone repositories
git clone git://github.com/thoughtbot/dotfiles.git
git clone git://github.com/langri-sha/dotfiles-local.git

# Install provided rcm configuration
cp ./dotfiles-local/rcrc ./.rcrc

# Inspect
lsrc

# Install
rcup
```

Rebasing
--------

Feel free to use and supersede mine. Here's a sample `.rcrc` to get you rolling
with a set of three configuration repositories, prioritizing yours, mine, then
theirs:

```
# rcm configuration
DIRECTORIES="~/dotfiles-local ~/dotfiles-langri-sha ~/dotfiles"
```
