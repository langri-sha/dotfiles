" Leader is comma.
let mapleader = ','

" Take the record button away. I don't like my voice.
map q <Nop>

" Use *just* semicolon for executing statements. Yuuuge!
nnoremap ; :

" Align block of text and retain selection.
vmap < <gv
vmap > >gv

" Terminal 'normal mode'.
tmap <esc> <c-\><c-n><esc><cr>

" Exit insert, dd line, enter insert.
inoremap <c-d> <esc>ddi
