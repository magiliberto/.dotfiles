" General settings -------------------------------------------------------------
syntax on
syntax enable

set encoding=utf-8  " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.

set noerrorbells
set number
set relativenumber
set nowrap
set mouse=a

" Tab and Indent default configuration
" set tabstop=4 shiftwidth=4
" set noexpandtab
" set autoindent
" set smartindent
set listchars=tab:\┊\ ,eol:¬ 
set list

" Plug-ins ---------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

	" UI related
	Plug 'chriskempson/base16-vim'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'edkolev/tmuxline.vim'
	Plug 'Raimondi/delimitMate'
	Plug 'Yggdroot/indentLine'
	
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/completion-nvim'

call plug#end()

lua << EOF

local nvim_lsp = require'nvim_lsp'
nvim_lsp.jedi_language_server.setup{ on_attach=require'completion'.on_attach }
nvim_lsp.pyls.setup{ on_attach=require'completion'.on_attach }
nvim_lsp.r_language_server.setup{ on_attach = require'completion'.on_attach }
EOF


" filetype plugin indent on

set completeopt=menuone,noinsert " ,noselect
" let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" Plug-ins settings ------------------------------------------------------------
" Base-16 color themes integration
if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
endif

hi Normal guibg=NONE ctermbg=NONE

" 80th column mark
set colorcolumn=81

highlight Comment cterm=italic gui=italic

" Airline
let g:airline_theme='base16_vim'
let g:airline_base16_improved_contrast=1
let g:airline_base16_solarized=1
let g:airline_left_sep =''
let g:airline_right_sep = ''
let g:airline#extensions#ale#enabled=1
let airline#extensions#ale#error_symbol='E:'
let airline#extensions#ale#warning_symbol='W:'

autocmd VimLeave * :TmuxlineSnapshot! ~/.tmux_background

" delimitMate
let g:delimitMate_expand_cr=1

" indentLine
highlight NonText ctermfg=19
highlight Whitespace ctermfg=19
let g:indentLine_color_term=base16_cterm02
let g:indentLine_char = '┊'
let g:indentLine_showFirstIndentLevel=1
let g:indentLine_first_char = '┊'
