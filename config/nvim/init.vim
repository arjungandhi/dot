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


" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'

" complliers for languages
" compilers? 
Plug 'konfekt/vim-compilers'
" google code fmt
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'

" Github Copilot
Plug 'github/copilot.vim'

" Useful vim modz
" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
" bullets
Plug 'dkarter/bullets.vim'
" nord theme
Plug 'arcticicestudio/nord-vim'
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
autocmd FileType rust AutoFormatBuffer rustfmt

" python
" run black on save then compile flake8 and show errors
" then run make to show errors in quickfix
autocmd FileType python AutoFormatBuffer black
autocmd FileType python compiler flake8
autocmd BufWritePost python silent make! <afile> | silent redraw!
autocmd QuickFixCmdPost [^l] cwindow

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
autocmd BufNewFile,BufRead $SNIPPETS/bazel/* set filetype=bzl
autocmd BufNewFile,BufRead $ATP_DIR/project/* set filetype=todotxt
autocmd BufNewFile,BufRead $ATP_DIR/todo/* set filetype=todotxt

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

" Python
let g:python3_host_prog = '/usr/bin/python'
let g:pydocstring_doq_path = '/home/arjun/.local/bin/doq'

" FixCursorHold for better performance
let g:cursorhold_updatetime = 100

" context.vim
let g:context_nvim_no_redraw = 1

" setup TreeSitter to have highlighting and indentation
autocmd VimEnter * :TSEnable highlight
autocmd VimEnter * :TSEnable indent

" easy align
"" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


" LSP config
lua <<EOF
-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})


-- Actual LSP Servers
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
require'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
          pycodestyle = {
              enabled = false
          },
          ruff = {
              enabled = true,  -- Enable the plugin
              formatEnabled = true,  -- Enable formatting using ruffs formatter
              executable = "/usr/bin/ruff",  -- Custom path to ruff
              extendSelect = { "I" },  -- Rules that are additionally used by ruff
              format = { "I" },  -- Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
              severities = { ["D212"] = "I" },  -- Optional table of rules where a custom severity is desired
              lineLength = 88,  -- Line length to pass to ruff checking and formatting
          }, 
        }
      }
    }
}
require'lspconfig'.gopls.setup{}
require'lspconfig'.eslint.setup{}
require'lspconfig'.ts_ls.setup{
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
        languages = {"javascript", "typescript", "vue"},
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "vue",
  },
}

require'lspconfig'.terraformls.setup{}

-- cmp
local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
  ['<Tab>'] = cmp.mapping.confirm({ select = true}),
  }),
})

EOF
