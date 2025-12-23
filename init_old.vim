" grab defaults from base vim -----------------------------------------------@/
" source $VIMRUNTIME/defaults.vim
" source $VIMRUNTIME/vimrc_example.vim

" syntax highlighting -------------------------------------------------------@/
:au BufRead,BufNewFile *.tra    setfiletype terra
:au BufRead,BufNewFile *.inc    setfiletype asm         " .inc is only for ASM
:au BufRead,BufNewFile *.dmg    setfiletype asm         " SM83 assembly
:au BufRead,BufNewFile *.sx     setfiletype asm         " gas assembly
:au BufRead,BufNewFile *.bsa    setfiletype c           " ? bass assembly?
au! BufRead,BufNewFile *.csv,*.tsv	setfiletype csv

" cpp setup -----------------------------------------------------------------@/
let g:cpp_function_highlight = 0
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1
let g:cpp_simple_highlight = 0
let g:cpp_type_name_highlight = 0
let g:cpp_posix_standard = 1 " enable highlighting of posix fns
let g:cpp_class_decl_highlight = 1
let g:cpp_class_scope_highlight = 1

" plugins
call plug#begin()
	" misc ----------------------------------------------@/
	Plug 'lukas-reineke/indent-blankline.nvim'
	Plug 'nvim-tree/nvim-tree.lua'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'tpope/vim-fugitive'
	Plug 'godlygeek/tabular'
	Plug 'airblade/vim-gitgutter'
	" languages -----------------------------------------@/
	Plug 'pangloss/vim-javascript'
	Plug 'tbastos/vim-lua'
	Plug 'euclidianAce/BetterLua.vim'
	Plug 'bfrg/vim-cpp-modern'
	Plug 'kalvinpearce/ShaderHighlight'
	Plug 'preservim/vim-markdown'
	Plug 'chrisbra/csv.vim'
	" colorschemes --------------------------------------@/
	Plug 'wadackel/vim-dogrun'
	Plug 'cocopon/iceberg.vim'
	Plug 'lifepillar/vim-gruvbox8', { 'branch': 'neovim' }
		" mono themes
		Plug 'owickstrom/vim-colors-paramount'
		Plug 'jaredgorski/fogbell.vim'
		Plug 'jaredgorski/Mies.vim'
		Plug 'suwacrab/stella'
call plug#end()

" js setup
augroup javascript_folding
	au!
	au FileType javascript setlocal foldmethod=syntax
augroup END

" airline config
"let g:airline_left_sep = '»'
"let g:airline_right_sep = '«'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'

" markdown
let g:vim_markdown_folding_disabled = 1

" misc ----------------------------------------------------------------------@/
" :colo gruvbox
" :colo boring
:set termguicolors
:set background=dark
:colo gruvbox8_hard
:let g:airline_theme='gruvbox8'
:set number
:set nowrap
:set noexpandtab 	" don't convert tabs to spaces.
:set tabstop=4 		" tabs are 4 wide
:set shiftwidth=4 	" same for shifting lines
:set belloff=all    " disable that damned bell sound
:set clipboard=unnamedplus  " fix copying across clipboards
:set foldmethod=syntax      " enable folds depending on filetype
:set foldcolumn=1           " i forgot
:let g:javaScript_fold=1

:set hlsearch           " highlight searched words
:set incsearch          " enable incremental searching
:set updatetime=100		" 100ms update (default is 4000)
:set colorcolumn=80		" after 80 columns, show red bar
":set columns=201		" about 2 screens wide, plus enough for tree

" swapfile config; disabled, we dont need temp files
:set noswapfile
":set backupdir=$TEMP//
":set directory=$TEMP//
":set undodir=$TEMP

luafile ~/.config/nvim/startup.lua

" tree config
" would insert :NvimTreeToggle followed by linebreak
:noremap _ :NvimTreeToggle<cr>

