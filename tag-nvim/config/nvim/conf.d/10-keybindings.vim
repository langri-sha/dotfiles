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

" Don't move cursor when exiting insert mode.
inoremap <silent> <Esc> <C-O>:stopinsert<CR>

" Atom.
nmap <c-d> yyp
imap <c-d> <esc>yypi
nmap <c-k> dd
imap <c-k> <esc>ddi
