if (!isdirectory(expand("$XDG_CONFIG_HOME/nvim/repos/github.com/Shougo/dein.vim")))
    call system(expand("mkdir -p $XDG_CONFIG_HOME/nvim/repos/github.com/Shougo"))
    call system(expand("git clone https://github.com/Shougo/dein.vim $XDG_CONFIG_HOME/nvim/repos/github.com/Shougo/dein.vim"))
endif

set runtimepath+=$XDG_CONFIG_HOME/nvim/repos/github.com/Shougo/dein.vim/
call dein#begin(expand("$XDG_CONFIG_HOME/nvim"))
call dein#add('Shougo/dein.vim')

" Syntax
call dein#add('sheerun/vim-polyglot')
call dein#add('othree/yajs.vim', {'on_ft': 'javascript'})
call dein#add('elzr/vim-json', {'on_ft': 'json'})
call dein#add('othree/jsdoc-syntax.vim', {'on_ft': 'javascript'})
call dein#add('othree/es.next.syntax.vim', {'on_ft': 'javascript'})
call dein#add('othree/javascript-libraries-syntax.vim', {'on_ft': 'javascript'})
call dein#add('ap/vim-css-color', {'on_ft': ['css', 'scss']})
call dein#add('tpope/vim-markdown', {'on_ft': 'markdown'})
call dein#add('hail2u/vim-css3-syntax', {'on_ft':['css','scss']})
call dein#add('kchmck/vim-coffee-script', {'on_ft': 'coffee'})
call dein#add('ekalinin/Dockerfile.vim')
call dein#add('tyru/markdown-codehl-onthefly.vim', {'on_ft': 'markdown'})
call dein#add('fatih/vim-go', {'on_ft': 'go'})

" Color schemes
call dein#add('DrSpatula/vim-buddy')
call dein#add('DrowsySaturn/VIvid.vim')
call dein#add('GGalizzi/cake-vim')
call dein#add('Konstruktionist/vim')
call dein#add('RussellBradley/vim-rockets-away')
call dein#add('atelierbram/vim-colors_duotones')
call dein#add('cesardeazevedo/Fx-ColorScheme')
call dein#add('joshdick/onedark.vim')
call dein#add('mhartington/oceanic-next')
call dein#add('notpratheek/vim-luna')
call dein#add('petelewis/vim-evolution')
call dein#add('ronny/birds-of-paradise.vim')
call dein#add('uu59/vim-herokudoc-theme')
call dein#add('vim-scripts/C64.vim')
call dein#add('vim-scripts/ecostation')
call dein#add('vim-scripts/inkpot')
call dein#add('vim-scripts/otaku')
call dein#add('vim-scripts/sift')
call dein#add('vim-scripts/turbo.vim')

" Editing
call dein#add('christoomey/vim-tmux-navigator')
call dein#add('dhruvasagar/vim-table-mode')
call dein#add('easymotion/vim-easymotion')
call dein#add('editorconfig/editorconfig-vim')
call dein#add('itchyny/vim-cursorword')
call dein#add('junegunn/goyo.vim')
call dein#add('mhinz/vim-sayonara')
call dein#add('tpope/vim-surround')

" External
call dein#add('benekastah/neomake')
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})

" Completion
call dein#add('Shougo/deoplete.nvim')
call dein#add('Shougo/unite-outline')
call dein#add('Shougo/unite.vim')
call dein#add('carlitux/deoplete-ternjs', {'on_ft': 'javascript'})
call dein#add('junkblocker/unite-codesearch')
call dein#add('ujihisa/unite-colorscheme')
call dein#add('zchee/deoplete-jedi', {'on_ft': 'python'})

" Interface
call dein#add('airblade/vim-gitgutter')
call dein#add('bling/vim-airline')
call dein#add('jaxbot/github-issues.vim')
call dein#add('jistr/vim-nerdtree-tabs')
call dein#add('mileszs/ack.vim')
call dein#add('qualiabyte/vim-colorstepper')
call dein#add('ryanoasis/vim-devicons')
call dein#add('scrooloose/nerdtree')
call dein#add('terryma/vim-multiple-cursors')
call dein#add('Xuyuanp/nerdtree-git-plugin')

if dein#check_install()
    call dein#install()
    let pluginsExist=1
endif

call dein#end()
filetype plugin indent on

runtime! conf.d/*.vim
runtime! plugins.d/*.vim
