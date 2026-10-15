# dotfiles

The deafults never worked, so I turned to the robots :muscle:.

Shell, editor and desktop configuration, linked into `$HOME` with
[rcm](https://github.com/thoughtbot/rcm) on top of
[thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles). Most files sit
in tags — `emacs`, `fdupanovic`, `gnome`, `nvim`, `tmux`, `vim` and `zsh` — and
the `*.local` ones extend thoughtbot's.

## Usage

Install rcm, then clone this repository as thoughtbot's `~/dotfiles-local` and
link both with the tags you want:

```sh
git clone https://github.com/thoughtbot/dotfiles ~/dotfiles
git clone https://github.com/langri-sha/dotfiles ~/dotfiles-local
env RCRC=$HOME/dotfiles/rcrc rcup -t nvim -t tmux -t zsh
```

The pre-up hooks clone oh-my-zsh and tpm on the first run.

In a GitHub Codespace, `setup.sh` runs instead: it installs ripgrep, starship,
tealdeer, Terraform and the Google Cloud CLI, and links nothing.

## Contributing

CI builds the Codespace image (`docker compose build codespace`), which runs
`setup.sh`. See
[CONTRIBUTING.md](https://github.com/langri-sha/github/blob/main/CONTRIBUTING.md).
