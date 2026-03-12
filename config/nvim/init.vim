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

" Molten - Jupyter in Neovim
Plug 'benlubas/molten-nvim', { 'do': ':UpdateRemotePlugins' }

" Image rendering in terminal
Plug '3rd/image.nvim'

" Jupytext - open .ipynb as scripts
Plug 'GCBallesteros/jupytext.nvim'

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

call glaive#Install()
Glaive codefmt nixpkgs_fmt_executable='nixfmt'

""" main config

" enable syntax and plugins
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
autocmd FileType nix AutoFormatBuffer nixpkgs-fmt

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
autocmd FileType * lua pcall(vim.treesitter.start)

" easy align
"" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


" LSP config
lua <<EOF
vim.opt.signcolumn = 'yes'
vim.diagnostic.config({virtual_text = true})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

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

vim.lsp.config('pylsp', {
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {enabled = false},
        ruff = {
          enabled = true,
          formatEnabled = true,
          executable = "/usr/bin/ruff",
          extendSelect = {"I"},
          format = {"I"},
          severities = {["D212"] = "I"},
          lineLength = 88,
        },
      }
    }
  }
})

vim.lsp.config('gopls', {capabilities = capabilities})
vim.lsp.config('eslint', {capabilities = capabilities})
vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
        languages = {"javascript", "typescript", "vue"},
      },
    },
  },
  filetypes = {"javascript", "typescript", "vue"},
})
vim.lsp.config('terraformls', {capabilities = capabilities})
vim.lsp.config('cmake', {capabilities = capabilities})

vim.lsp.enable({'pylsp', 'gopls', 'eslint', 'ts_ls', 'terraformls', 'cmake'})

local cmp = require('cmp')
cmp.setup({
  sources = {{name = 'nvim_lsp'}},
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.confirm({select = true}),
  }),
})

-- Jupytext setup
require('jupytext').setup({
  style = 'percent',
  output_extension = 'auto',
  force_ft = nil,
})

-- Override jupytext write to avoid --update flag which corrupts notebooks
vim.api.nvim_create_autocmd({ "BufWriteCmd", "FileWriteCmd" }, {
  pattern = "*.ipynb",
  group = vim.api.nvim_create_augroup("jupytext-no-update", { clear = true }),
  callback = function(ev)
    local ipynb = ev.match
    local py_file = vim.fn.fnamemodify(ipynb, ":r") .. ".py"
    py_file = vim.fn.resolve(vim.fn.expand(py_file))
    vim.cmd.write({ py_file, bang = true })
    vim.fn.system("jupytext " .. vim.fn.shellescape(py_file)
      .. " --to ipynb"
      .. " --output " .. vim.fn.shellescape(ipynb))
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_err_writeln("jupytext write failed")
    end
    vim.api.nvim_set_option_value("modified", false, { buf = vim.api.nvim_get_current_buf() })
  end,
})

-- image.nvim setup
require('image').setup({
  backend = 'kitty',
  processor = 'magick_cli',
  max_width = 100,
  max_height = 12,
  max_height_window_percentage = math.huge,
  max_width_window_percentage = math.huge,
  window_overlap_clear_enabled = true,
})

-- Molten config
vim.g.molten_image_provider = 'image.nvim'
vim.g.molten_output_win_max_height = 20
vim.g.molten_wrap_output = true
vim.g.molten_output_win_border = "single"
vim.g.molten_output_crop_border = false
vim.g.molten_use_border_highlights = true

-- Clean up molten highlight groups to match Nord
vim.api.nvim_set_hl(0, "MoltenOutputBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "MoltenOutputBorderFail", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "MoltenOutputBorderSuccess", { link = "DiagnosticOk" })
vim.api.nvim_set_hl(0, "MoltenOutputWin", { link = "NormalFloat" })
vim.g.molten_auto_open_output = false
vim.g.molten_virt_text_output = true
vim.g.molten_virt_lines_off_by_1 = true

-- Run the current # %% cell under cursor
local function run_cell()
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1 -- 0-indexed
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local total = #lines

  -- find start of cell (search up for # %%)
  local cell_start = 0
  for i = row, 0, -1 do
    if lines[i + 1]:match("^# %%%%") then
      cell_start = i + 1 -- 1-indexed, line after marker
      break
    end
  end

  -- find end of cell (search down for next # %% or EOF)
  local cell_end = total
  for i = row + 1, total - 1 do
    if lines[i + 1]:match("^# %%%%") then
      cell_end = i -- 1-indexed, line before next marker
      break
    end
  end

  -- skip empty leading/trailing lines
  if cell_start > 0 and cell_start <= total and lines[cell_start]:match("^# %%%%") then
    cell_start = cell_start + 1
  end

  if cell_start > cell_end then return end

  vim.api.nvim_buf_set_mark(buf, '<', cell_start, 0, {})
  vim.api.nvim_buf_set_mark(buf, '>', cell_end, 0, {})
  vim.cmd("MoltenEvaluateVisual")
end

-- Molten keybindings
vim.keymap.set("n", "<leader>ji", ":MoltenInit<CR>", { silent = true, desc = "Molten Init" })
vim.keymap.set("n", "<leader>jip", ":MoltenInit shared http://localhost:1898<CR>", { silent = true, desc = "Molten Connect to Docker Jupyter" })
vim.keymap.set("n", "<leader>jel", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Molten Evaluate Line" })
vim.keymap.set("n", "<leader>je", run_cell, { silent = true, desc = "Molten Evaluate Cell" })
vim.keymap.set("v", "<leader>je", ":<C-u>MoltenEvaluateVisual<CR>gv", { silent = true, desc = "Molten Evaluate Visual" })

vim.keymap.set("n", "<leader>jdc", ":MoltenDelete<CR>", { silent = true, desc = "Molten Delete Cell" })
vim.keymap.set("n", "<leader>jh", ":MoltenHideOutput<CR>", { silent = true, desc = "Molten Hide Output" })
vim.keymap.set("n", "<leader>jo", ":noautocmd MoltenEnterOutput<CR>", { silent = true, desc = "Molten Enter Output" })
vim.keymap.set("n", "<leader>jr", ":MoltenRestart<CR>", { silent = true, desc = "Molten Restart Kernel" })
vim.keymap.set("n", "<leader>jn", ":MoltenNext<CR>", { silent = true, desc = "Molten Next Cell" })
vim.keymap.set("n", "<leader>jp", ":MoltenPrev<CR>", { silent = true, desc = "Molten Prev Cell" })

EOF
