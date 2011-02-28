colorscheme delek
set nobackup
syntax on
set lbr
set ai
set nosi
set expandtab
set tabstop=4
set softtabstop=4
set modelines=1
set encoding=utf-8
set fenc=utf-8
augroup mkd
    autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:>
augroup END
