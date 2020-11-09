set nocompatible
filetype off
set exrc
set secure
set path +=**
set background=dark
let mapleader=","
set clipboard=unnamed
set wildmenu
set backspace=indent,eol,start
set ttyfast
set gdefault
set encoding=utf-8 nobomb
set binary
set noeol
set splitright
set relativenumber

" ColourColumn = 80, Set the color to dark grey
set colorcolumn=80
highlight ColorColumn ctermbg=2
highlight DiffAdd    cterm=bold ctermfg=51 ctermbg=23 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=51 ctermbg=23 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=51 ctermbg=23 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=51 ctermbg=23 gui=none guifg=bg guibg=Red

" Respect modeline in files
set modeline
set modelines=4
" Enable line numbers
set number
syntax on
set cursorline
set tabstop=3
set softtabstop=3
set shiftwidth=3
set expandtab
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
set hlsearch

" Ignore case of searches
set ignorecase
set incsearch
set laststatus=2
set mouse=a
set noerrorbells
set nostartofline
set ruler
set shortmess=atI
set showmode
set title
set showcmd

autocmd BufWritePre * %s/\s\+$//e
autocmd! FileType qf nnoremap <buffer> <leader><Enter> <C-w><Enter><C-w>L
au FileType qf wincmd J

"Move between splits easily
noremap <C-J> <C-W><C-J>
noremap <C-H> <C-W><C-H>
noremap <C-K> <C-W><C-K>
noremap <C-L> <C-W><C-L>

nnoremap <leader>f /<C-R><C-W><CR>
nnoremap <leader>cf :noh<CR><ESC>
nnoremap <leader>l :cope<CR>
nnoremap <leader>d :ccl<CR>
nnoremap <leader>d :ccl<CR>
nnoremap <leader>g :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap <leader>r :RG <SPACE>
nnoremap <leader>b :Shell ninja -C build
nnoremap <leader>t :Shell ninja -C build test

command! -nargs=+ -complete=file -bar RG silent! grep! <args>|cwindow|redraw!

" Use ripgrep instead of grep if it exists
if executable('rg')
   set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif

function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright vnew ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize '
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)