" Vim with all enhancements
source $VIMRUNTIME/defaults.vim
" source $VIMRUNTIME/vimrc_example.vim

" mine
:au BufRead,BufNewFile *.tra    setfiletype terra
:au BufRead,BufNewFile *.inc    setfiletype asm         " .inc is only for ASM
:au BufRead,BufNewFile *.dmg    setfiletype asm         " SM83 assembly
:au BufRead,BufNewFile *.sx     setfiletype asm         " gas assembly
:au BufRead,BufNewFile *.bsa    setfiletype c           " ? bass assembly?

" cpp setup
let g:cpp_function_highlight = 0
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1
let g:cpp_simple_highlight = 0
let g:cpp_posix_standard = 1 " posix fn highlight
let g:cpp_class_decl_highlight = 1
let g:cpp_class_scope_highlihgt = 1

" plugins
call plug#begin()
	" languages -----------------------------------------@/
	Plug 'pangloss/vim-javascript'
	Plug 'tbastos/vim-lua'
	Plug 'bfrg/vim-cpp-modern'
	Plug 'kalvinpearce/ShaderHighlight'
	" colorschemes --------------------------------------@/
	Plug 'sts10/vim-pink-moon'
	Plug 'wadackel/vim-dogrun'
	Plug 'cocopon/iceberg.vim'
	Plug 'keith/parsec.vim'
	Plug 'nvimdev/oceanic-material'
	Plug 'morhetz/gruvbox'
	" misc ----------------------------------------------@/
	Plug 'kshenoy/vim-signature'
	Plug 'vim-airline/vim-airline'
	Plug 'tpope/vim-fugitive'

	Plug 'godlygeek/tabular'
	Plug 'preservim/vim-markdown'
call plug#end()

" js setup
augroup javascript_folding
	au!
	au FileType javascript setlocal foldmethod=syntax
augroup END

" airline config
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'

" markdown
let g:vim_markdown_folding_disabled = 1

" misc
:colo gruvbox
":set guifont=MS_Gothic:h9:cSHIFTJIS:qDRAFT
":set guifont=tewi:h8:cSHIFTJIS:qDRAFT
:set guifont=tewi:h8
:set number
:set nowrap
:set noexpandtab 	" don't convert tabs to spaces.
:set tabstop=4 		" tabs are 4 wide
:set shiftwidth=4 	" same for shifting lines
:set belloff=all
:set clipboard=unnamedplus
:set foldmethod=syntax
:set foldcolumn=1
:let g:javaScript_fold=1

:set hlsearch           " the best search
:set incsearch          " also, do that too
:set updatetime=100		" 100ms update (default is 4000)
:set colorcolumn=80		" after 80 columns, show red bar
:set columns=201		" about 2 screens wide, plus enough for tree

:set noswapfile
":set backupdir=$TEMP//
":set directory=$TEMP//
":set undodir=$TEMP

