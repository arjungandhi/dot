""" Vim-Plug
call plug#begin()
" Vim Mods
" tabline at top for buggers
Plug 'ap/vim-buftabline'
" sensible defaults
Plug 'tpope/vim-sensible'
" line text obj
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'


" complliers for languages
Plug 'konfekt/vim-compilers'
" google code fmt
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
" Go
Plug 'fatih/vim-go'
" Helm
Plug 'towolf/vim-helm'
" Terraform
Plug 'hashivim/vim-terraform'

" Useful vim modz
" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" bullets
Plug 'dkarter/bullets.vim'
" nord theme
Plug 'arcticicestudio/nord-vim'
" ctags
Plug 'ludovicchabant/vim-gutentags'
" copilot
Plug 'github/copilot.vim'
" tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" nerd tree
Plug 'preservim/nerdtree'
" calendar
" Come back to this
" Plug 'itchyny/calendar.vim' 


call plug#end()


""" main config

" enable syntax and plugins
" syntax enable
filetype plugin indent on

" turn on relative numbers
set relativenumber
set number

" turn on autowrite
set autowrite

" colorscheme nord
colorscheme nord

" set the path to where we opened vim
set path+=**

" set up wild menu
set wildmode=longest:list,full wildmenu

" set title
set title

" set filetime config
set softtabstop=4
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab 
set autoindent 
set smartindent
" split window control remap
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" set buffer control
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>


" set split opening

set splitbelow
set splitright

""" Filetype-Specific Configurations
autocmd FileType bzl AutoFormatBuffer buildifier
autocmd FileType proto AutoFormatBuffer clang-format
autocmd FileType html,css,sass,scss,less,json,javascript,typescript AutoFormatBuffer prettier
autocmd FileType go AutoFormatBuffer gofmt  
" autocmd FileType python AutoFormatBuffer black
autocmd FileType python AutoFormatBuffer isort

" python
" autocmd FileType python compiler flake8
" autocmd BufWritePost python silent make! <afile> | silent redraw!
" autocmd QuickFixCmdPost [^l] cwindow




" md 
autocmd FileType markdown setlocal spell spelllang=en_us
autocmd FileType markdown setlocal complete+=kspell

" gitcommit
autocmd FileType gitcommit setlocal spell spelllang=en_us
autocmd FileType gitcommit setlocal complete+=kspell

""" set certain filetypes to be typed

" ~/.notepad
autocmd BufNewFile,BufRead ~/.notepad set filetype=markdown

"" $SNIPPETS
autocmd BufNewFile,BufRead $SNIPPETS/bash/* set filetype=bash
autocmd BufNewFile,BufRead $SNIPPETS/python/* set filetype=python
autocmd BufNewFile,BufRead $SNIPPETS/markdown/* set filetype=markdown
autocmd BufNewFile,BufRead $SNIPPETS/yaml/* set filetype=yaml
autocmd BufNewFile,BufRead $SNIPPETS/kube/* set filetype=helm
autocmd BufNewFile,BufRead $SNIPPETS/proto/* set filetype=proto
autocmd BufNewFile,BufRead $SNIPPETS/go/* set filetype=go    
autocmd BufNewFile,BufRead $SNIPPETS/hugo/* set filetype=markdown

""" Custom Functions
" Trim Whitespaces
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\\\@<!\s\+$//e
    call winrestview(l:save)
endfunction

" Core
let mapleader=","
" reload conifg
nmap <leader>r :so ~/.config/nvim/init.vim<CR>
" trim whitespaces
nmap <leader>t :call TrimWhitespace()<CR>
" toggle file explorer
nmap <leader>e :NERDTreeToggle<CR>
" clear highlighting
nmap <silent> <leader><leader> :noh<CR>
" change numbs 
nmap <leader>$s <C-w>s<C-w>j:terminal<CR>:set nonumber<CR><S-a>
nmap <leader>$v <C-w>v<C-w>l:terminal<CR>:set nonumber<CR><S-a>
" go to current error
nmap <leader>n :cc<CR>
" close all open buffers
nmap <leader>bd :bufdo bd<CR>

" spell check commands
" toggle spell check
nmap <leader>s :setlocal spell!<CR>
inoremap <C-s> <C-G>u<Esc>[s1z=`]a<C-G>u

"" fzf commands
" project files
function! s:find_files()
    let git_dir = system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
    if git_dir != ''
        execute 'GFiles' git_dir
    else
        execute 'Files'
    endif
endfunction
command! ProjectFiles execute s:find_files()
nmap <leader>fg :ProjectFiles<CR>

" tags
nmap <leader>ft :Tags<CR>

" files
nmap <leader>ff :Files<CR>

" snippets
command! SNIPPETS call fzf#run(fzf#wrap({'source': 'snip list', 'sink': '.!snip'}))
nmap <leader>fs :SNIPPETS<CR>

""" Core plugin configuration (vim)
" fzf
let g:fzf_layout = { 'down': '40%' }

" Gutentags
let g:gutentags_ctags_tagfile = '.tags'
if executable('rg')
    let g:gutentags_file_list_command = 'rg --files'
endif

" Python
let g:python3_host_prog = '/usr/bin/python'
let g:pydocstring_doq_path = '/home/arjun/.local/bin/doq'

" set node js path for copilot
let g:copilot_node_command = '~/.nodenv/versions/16.17.0/bin/node'

" FixCursorHold for better performance
let g:cursorhold_updatetime = 100

" context.vim
let g:context_nvim_no_redraw = 1

" setup TreeSitter to have highlighting and indentation
autocmd VimEnter * :TSEnable highlight
autocmd VimEnter * :TSEnable indent

