
" Filetypes --------------------------------------------------------------------
" autocmd BufNewFile,BufFilePre,BufRead *.rmd,*.Rmd	set filetype=rmarkdown
" autocmd BufNewFile,BufFilePre,BufRead *.sh			set filetype=bash
" autocmd BufNewFile,BufFilePre,BufRead *.py			set filetype=python
" autocmd BufNewFile,BufFilePre,BufRead *.R			set filetype=R

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
set ttymouse=sgr

" Search configuration
set ignorecase
set smartcase
set incsearch

" Tab and Indent default configuration
set tabstop=4 shiftwidth=4
set noexpandtab
set autoindent
" set smartindent
set listchars=tab:\│\ ,eol:¬ 
set list

" Plug-ins ---------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

	" ** R & Python autocomplete dependencies **
	" pip3 install pynvim
	" pip3 install jedi
	" pip3 install flake8
	" pip3 install autopep8
	
	" UI related
	Plug 'chriskempson/base16-vim'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'edkolev/tmuxline.vim'
	Plug 'Raimondi/delimitMate'
	Plug 'Yggdroot/indentLine'
	
	" File manager
	Plug 'preservim/nerdtree'
	
	" Languaje tools
	Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
	
	" Autocomplete
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
	Plug 'ncm2/ncm2'
	
	Plug 'ncm2/ncm2-bufword'
	Plug 'ncm2/ncm2-path'
	Plug 'ncm2/ncm2-jedi'
	Plug 'ncm2/ncm2-ultisnips'
	Plug 'SirVer/ultisnips' 
	Plug 'gaalcaras/ncm-R'
	
	" Syntax check
	Plug 'dense-analysis/ale'
	
	" CSV data viewer
	Plug 'chrisbra/csv.vim'

call plug#end()

filetype plugin indent on

" Plug-ins settings ------------------------------------------------------------

" Render Rmarkdown documents
" autocmd Filetype rmarkdown map <F5> :!Rscript -e "rmarkdown::render('%')" <CR>

" Base-16 color themes integration
if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
endif

hi Normal guibg=NONE ctermbg=NONE

" 80th column mark
set colorcolumn=81

highlight Comment cterm=italic gui=italic
highlight ALEError cterm=underline ctermfg=red ctermbg=NONE
highlight ALEWarningSign cterm=underline ctermfg=yellow ctermbg=NONE
"highlight NonText ctermfg=19 ctermbg=NONE
"highlight SpecialKey ctermfg=18 ctermbg=NONE

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
let g:indentLine_color_term=base16_cterm03
let g:indentLine_char = '│'
let g:indentLine_showFirstIndentLevel=1
let g:indentLine_first_char = '│'

" NCM2
augroup NCM2
	autocmd!
	
	" To enable ncm2 for all buffers.
	autocmd BufEnter * call ncm2#enable_for_buffer()
	
	" :help Ncm2PopupOpen for more
	set completeopt=noinsert,menuone,noselect
	
	" Use <TAB> to select the popup menu:
	inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"" information.

augroup END

" Ale
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'always'
" let g:ale_echo_msg_error_str = 'E'
" let g:ale_echo_msg_warning_str = 'W'
" let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" let g:ale_linters = {'python': ['flake8']}

" NerdTree
map <C-n> :NERDTreeToggle<CR>

" Nvim-R
" let R_csv_delim = ','
" let R_csv_app = 'tmux split-window vd'
let R_csv_app = 'tmux split-window sc-im'

" csv.vim
let g:csv_autocmd_arrange = 1
