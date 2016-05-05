if (!isdirectory(expand("$HOME/.config/nvim/repos/github.com/Shougo/dein.vim")))
    call system(expand("mkdir -p $HOME/.config/nvim/repos/github.com"))
    call system(expand("git clone https://github.com/Shougo/dein.vim $HOME/.config/nvim/repos/github.com/Shougo/dein.vim"))
endif

set runtimepath+=~/.config/nvim/repos/github.com/Shougo/dein.vim/
call dein#begin(expand('~/.config/nvim'))
call dein#add('Shougo/dein.vim')

call dein#add('airblade/vim-gitgutter')
call dein#add('bling/vim-airline')
call dein#add('christoomey/vim-tmux-navigator')
call dein#add('easymotion/vim-easymotion')
call dein#add('sgur/vim-editorconfig')
call dein#add('ekalinin/Dockerfile.vim')
call dein#add('fatih/vim-go')
call dein#add('fholgado/minibufexpl.vim')
call dein#add('flazz/vim-colorschemes')
call dein#add('gcmt/taboo.vim')
call dein#add('jistr/vim-nerdtree-tabs')
call dein#add('mileszs/ack.vim')
call dein#add('qualiabyte/vim-colorstepper')
call dein#add('scrooloose/nerdtree')
call dein#add('terryma/vim-multiple-cursors')
call dein#add('Xuyuanp/nerdtree-git-plugin')

if dein#check_install()
    call dein#install()
    let pluginsExist=1
endif
