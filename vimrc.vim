" grab defaults from base vim -----------------------------------------------@/
source $VIMRUNTIME/defaults.vim

" syntax highlighting -------------------------------------------------------@/
:au BufRead,BufNewFile *.tra    setfiletype terra       " terra language
:au BufRead,BufNewFile *.inc    setfiletype asm         " .inc is only for ASM
:au BufRead,BufNewFile *.dmg    setfiletype asm         " SM83 assembly
:au BufRead,BufNewFile *.sx     setfiletype asm         " GNU assembly
:au BufRead,BufNewFile *.bsa    setfiletype c           " near's bass assembler

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
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'tpope/vim-fugitive'
	Plug 'markonm/traces.vim'
	" languages -----------------------------------------@/
	Plug 'pangloss/vim-javascript'
	Plug 'tbastos/vim-lua'
	Plug 'bfrg/vim-cpp-modern'
	Plug 'kalvinpearce/ShaderHighlight'
	Plug 'preservim/vim-markdown'
	Plug 'ap/vim-css-color'
	" colorschemes --------------------------------------@/
	Plug 'sts10/vim-pink-moon'
	Plug 'wadackel/vim-dogrun'
	Plug 'cocopon/iceberg.vim'
	Plug 'keith/parsec.vim'
	Plug 'nvimdev/oceanic-material'
	Plug 'morhetz/gruvbox'
	Plug 'jaredgorski/Mies.vim'
	Plug 'suwacrab/stella'

	Plug 'godlygeek/tabular'

	if has('nvim')
	Plug 'lukas-reineke/indent-blankline.nvim'
	endif
call plug#end()

" js setup ----------------------------------------------@/
augroup javascript_folding
	au!
	au FileType javascript setlocal foldmethod=syntax
augroup END
let g:javaScript_fold=1

" airline config ----------------------------------------@/
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_left_sep = '✦'
let g:airline_right_sep = '✦'
"let g:airline_detect_whitespace=0 " disable trailing warning

" markdown ----------------------------------------------@/
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_fenced_languages= ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'c']
" let g:vim_markdown_fenced_languages= ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']

" misc ----------------------------------------------------------------------@/
:set background=light
:colorscheme gruvbox
let g:airline_theme='gruvbox'
:set guifont=tewi:h8
if has("gui_running")
	:set guioptions -=T  " disable GUI toolbar
	:set guioptions -=m  " disable GUI menubar
	:set guioptions -=e  " disable GUI tabs
	:set guioptions-=l   " disable GUI left scrollbar
	:set guioptions-=L   " ditto
	:set guioptions-=R   " disable GUI right scrollbar
	:set guioptions-=r   " ditto
endif
:set number            " enable line numbers
:set nowrap            " disable line wrapping
:set noexpandtab       " don't convert tabs to spaces.
:set tabstop=4         " tabs are 4 wide
:set shiftwidth=4      " same for shifting lines
:set belloff=all       " disable that annoying as fuck bell
:set clipboard=unnamed " fix pasting (NOTE: on linux, use unnamedplus)
:set foldmethod=syntax " enable folding based on syntax
:set foldcolumn=2
:set autoindent        " automatically indent lines

:set hlsearch           " highlight when searching
:set incsearch          " also, do that too
:set updatetime=100     " 100ms update (default is 4000)
:set colorcolumn=80     " after 80 columns, show red bar
:set columns=176        " about 2 screens wide, plus enough for extras

:noh " clear highlighting, just in case

" neovide-only config -------------------------------------------------------@/
if exists("g:neovide")
    " Put anything you want to happen only in Neovide here
	:set guifont=tewi:h8:#e-alias:#h-none

	let g:neovide_position_animation_length = 0
	let g:neovide_cursor_animation_length = 0.00
	let g:neovide_cursor_trail_size = 0
	let g:neovide_cursor_animate_in_insert_mode = 0
	let g:neovide_cursor_animate_command_line = 0
	let g:neovide_scroll_animation_far_lines = 0
	let g:neovide_scroll_animation_length = 0.00
endif

" backup file storage -------------------------------------------------------@/
:set swapfile
" * NOTE: for linux, the below should be uncommented...? haven't tested yet.
:set backupdir=$TEMP//
:set directory=$TEMP//
:set undodir=$TEMP

