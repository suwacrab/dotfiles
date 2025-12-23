" grab defaults from base vim -----------------------------------------------@/
" source $VIMRUNTIME/defaults.vim
set backspace=indent,eol,start

" syntax highlighting -------------------------------------------------------@/
au BufRead,BufNewFile *.tra    setfiletype terra       " terra language
au BufRead,BufNewFile *.inc    setfiletype asm         " .inc is only for ASM
au BufRead,BufNewFile *.dmg    setfiletype asm         " SM83 assembly
au BufRead,BufNewFile *.sx     setfiletype asm         " GNU assembly
au BufRead,BufNewFile *.bsa    setfiletype c           " near's bass assembler

" cpp setup -----------------------------------------------------------------@/
let g:cpp_function_highlight = 0
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1
let g:cpp_simple_highlight = 0
let g:cpp_type_name_highlight = 0
let g:cpp_posix_standard = 1 " enable highlighting of posix fns
let g:cpp_class_decl_highlight = 1
let g:cpp_class_scope_highlight = 1

" plugins -------------------------------------------------------------------@/
call plug#begin()
	" misc ----------------------------------------------@/
	Plug 'airblade/vim-gitgutter'
	Plug 'kshenoy/vim-signature'
	Plug 'tpope/vim-fugitive'
	Plug 'markonm/traces.vim'
	Plug 'preservim/tagbar'
	Plug 'godlygeek/tabular'
	if !has('nvim')
		Plug 'Konfekt/FastFold'
	"	Plug 'vim-airline/vim-airline'
	"	Plug 'vim-airline/vim-airline-themes'
	else
		Plug 'nvim-lualine/lualine.nvim'
		Plug 'nvim-tree/nvim-tree.lua'
		Plug 'nvim-tree/nvim-web-devicons'
	endif
	" languages -----------------------------------------@/
	Plug 'pangloss/vim-javascript'
	Plug 'bfrg/vim-cpp-modern'
	Plug 'kalvinpearce/ShaderHighlight'
	Plug 'preservim/vim-markdown'
	Plug 'ap/vim-css-color'
	Plug 'suwacrab/BetterLua.vim'
	" colorschemes --------------------------------------@/
	Plug 'cocopon/iceberg.vim'
	Plug 'morhetz/gruvbox'
	Plug 'suwacrab/stella'
"	Plug 'sts10/vim-pink-moon'
"	Plug 'wadackel/vim-dogrun'
"	Plug 'keith/parsec.vim'
"	Plug 'nvimdev/oceanic-material'
"	Plug 'jaredgorski/Mies.vim'

	if has('nvim')
	"	Plug 'lukas-reineke/indent-blankline.nvim'
		Plug 'nvim-treesitter/nvim-treesitter'
		Plug 'kevinhwang91/promise-async' " depend VVV
		Plug 'kevinhwang91/nvim-ufo'
	endif
call plug#end()

" js setup ----------------------------------------------@/
augroup javascript_folding
	au!
	au FileType javascript setlocal foldmethod=syntax
augroup END
let g:javaScript_fold=1

" airline config ----------------------------------------@/
let s:line_sepL = ''
let s:line_sepR = ''
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
"let g:airline_left_sep = '✦'
"let g:airline_right_sep = '✦'
let g:airline#extensions#whitespace#enabled=0 " disable trailing warning
let g:airline_left_sep = s:line_sepL
let g:airline_right_sep = s:line_sepR
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = s:line_sepL
let g:airline#extensions#tabline#right_sep = s:line_sepR
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.linenr=''
"let g:airline_symbols.maxlinenr=''



" markdown ----------------------------------------------@/
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_fenced_languages= ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'c']
" let g:vim_markdown_fenced_languages= ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']

" fastfold ----------------------------------------------@/
nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

" color -------------------------------------------------@/
let g:gruvbox_contrast_light='soft'
let g:gruvbox_termcolors=16
let g:gruvbox_bold=0
let g:stella_bold=0

"if !has('nvim')
"	set list lcs=tab:\┊\ 
if has('win32')
	set list lcs=tab:\\ 
else
	set list lcs=tab:\│\ 
endif
"endif

" gvim --------------------------------------------------@/
if has('win32')
	if has('gui_running')
		" set renderoptions=type:directx,renmode:6,taamode:0
	endif
endif

" tagbar ------------------------------------------------@/
nmap <F8> :TagbarToggle<CR>
let g:tagbar_show_data_type = 1

" misc ----------------------------------------------------------------------@/
set termguicolors
set t_Co=256
set background=dark
colorscheme gruvbox
let g:airline_theme="gruvbox"
set guifont=tewi:h8
if has("gui_running")
	set guioptions -=T  " disable GUI toolbar
	set guioptions -=m  " disable GUI menubar
	set guioptions -=e  " disable GUI tabs
	set guioptions-=l   " disable GUI left scrollbar
	set guioptions-=L   " ditto
	set guioptions-=R   " disable GUI right scrollbar
	set guioptions-=r   " ditto
	set columns=176     " about 2 screens wide, plus enough for extras
endif
set number                " enable line numbers
set nowrap                " disable line wrapping
set noexpandtab           " don't convert tabs to spaces.
set tabstop=4             " tabs are 4 wide
set shiftwidth=4          " same for shifting lines
set belloff=all           " disable that annoying as fuck bell
set clipboard=unnamedplus " fix pasting (NOTE: on linux, use unnamedplus)
set foldmethod=syntax     " enable folding based on syntax
set foldcolumn=0          " disable numbers to left of folds
set autoindent            " automatically indent lines
set conceallevel=0        " lower line concealing, md messes up if !0

set hlsearch           " highlight when searching
set incsearch          " also, do that too
set updatetime=100     " 100ms update (default is 4000)
set colorcolumn=80     " after 80 columns, show red bar
set nocursorcolumn     " no veritcal cursor visual

:noh " clear highlighting, just in case

" neovide-only config -------------------------------------------------------@/
if exists("g:neovide")
	" Put anything you want to happen only in Neovide here
	set guifont=tewi:h8:#e-alias:#h-none

	let g:neovide_position_animation_length = 0
	let g:neovide_cursor_animation_length = 0.00
	let g:neovide_cursor_trail_size = 0
	let g:neovide_cursor_animate_in_insert_mode = 0
	let g:neovide_cursor_animate_command_line = 0
	let g:neovide_scroll_animation_far_lines = 0
	let g:neovide_scroll_animation_length = 0.00
endif

" backup file storage -------------------------------------------------------@/
set swapfile
" * NOTE: for linux, $TEMP only work, so don't use it.
if has('win32')
	set backupdir=$TEMP//
	set directory=$TEMP//
	set undodir=$TEMP
else
	set backupdir=/tmp//
	set directory=/tmp//
	set undodir=/tmp/
endif

" linux settings ------------------------------------------------------------@/
if !has('win32')
	hi Normal guibg=NONE
endif

