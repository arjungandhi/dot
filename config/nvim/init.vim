""" Vim-Plug
call plug#begin()
" copilot
Plug 'github/copilot.vim'
" tabline at top for buggers
Plug 'ap/vim-buftabline'
" tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" nerd tree
Plug 'preservim/nerdtree'
" complliers for languages
Plug 'konfekt/vim-compilers'
" google code fmt
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
" sensible defaults
Plug 'tpope/vim-sensible'
" line text obj
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" bullets
Plug 'dkarter/bullets.vim'
" nord theme
Plug 'articicestudio/nord-vim'
" ctags
Plug 'ludovicchabant/vim-gutentags'
" python
" isort
Plug 'brentyi/isort.vim'
" Go
"
Plug 'fatih/vim-go'
" Helm
Plug 'towolf/vim-helm'
" Terraform
Plug 'hashivim/vim-terraform'
" jupyter notebooks
Plug 'goerz/jupytext.vim'


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


" highlights
" hi clear SpellRare
" hi clear SpellBad
" hi clear SpellCap
" hi clear SpellLocal
" hi clear Error
" hi clear Todo
" hi SpellBad ctermbg=None ctermfg=darkred
" hi SpellRare ctermbg=None ctermfg=darkred
" hi SpellCap ctermbg=None ctermfg=darkgreen
" hi SpellLocal ctermbg=None ctermfg=darkgreen
" hi Error ctermbg=None ctermfg=darkred
" hi Todo ctermbg=None ctermfg=yellow  


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

augroup web_autofmt
  autocmd FileType javascript,typescript AutoFormatBuffer clang-format
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType vue AutoFormatBuffer prettier
augroup end

augroup python_linting
	autocmd!
    autocmd FileType python AutoFormatBuffer black
	autocmd FileType python compiler flake8
	autocmd BufWritePost *.py silent make! <afile> | silent redraw!
	autocmd QuickFixCmdPost [^l]* cwindow
augroup end

""" set certain filetypes to be typed

" ~/.notepad
autocmd BufNewFile,BufRead ~/.notepad set filetype=markdown

"" $SNIPPETS
autocmd BufNewFile,BufRead $SNIPPETS/bash/* set filetype=bash
autocmd BufNewFile,BufRead $SNIPPETS/python/* set filetype=python
autocmd BufNewFile,BufRead $SNIPPETS/markdown/* set filetype=markdown
autocmd BufNewFile,BufRead $SNIPPETS/yaml/* set filetype=yaml
autocmd BufNewFile,BufRead $SNIPPETS/kube/* set filetype=helm
autocmd BufNewFile,BufRead $SNIPPETS?proto/* set filetype=proto
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
nnoremap <leader>p :ProjectFiles<CR>
nmap <leader>fp :ProjectFiles<CR>

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

" overwrite :W to save all buffers
command! -bar W wa

" Gutentags
let g:gutentags_ctags_tagfile = '.tags'
if executable('rg')
    let g:gutentags_file_list_command = 'rg --files'
endif

" Python
let g:python3_host_prog = '/usr/bin/python'
let g:pydocstring_doq_path = '/home/arjun/.local/bin/doq'
let g:isort_vim_options = join([
	\ '--profile black',
	\ ], ' ')

" set node js path for copilot
let g:copilot_node_command = '~/.nodenv/versions/16.17.0/bin/node'

" FixCursorHold for better performance
let g:cursorhold_updatetime = 100

" context.vim
let g:context_nvim_no_redraw = 1

" setup TreeSitter to have highlighting and indentation
autocmd VimEnter * :TSEnable highlight
autocmd VimEnter * :TSEnable indent
