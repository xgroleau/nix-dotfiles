"Installing vimplug if not existing
"" Nvim
if has('nvim')
	let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
	if !filereadable(autoload_plug_path)
		echo "Inside if"
		silent execute '!curl -fLo ' . autoload_plug_path . ' --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
	endif
	unlet autoload_plug_path
"" Vim
else
	if empty(glob('~/.vim/autoload/plug.vim'))
		silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	endif
endif


"Settings
call plug#begin()
	"Installing plugins that are not installed
	autocmd VimEnter *
		\  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
		\|   PlugInstall --sync | q | source $MYVIMRC
		\| endif


	"Plugins
	"" Themes
	Plug 'morhetz/gruvbox'
	Plug 'hardcoreplayers/oceanic-material'

	"" UI
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'

	"" Tools
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
	Plug 'junegunn/fzf.vim'

	" General UI, line number and more
	set nu
	set relativenumber
	set ruler
	set showcmd
	set noshowmode
	set termguicolors
	set wildmenu
	set hidden
	set signcolumn=yes
	set title
	set laststatus=2
	set t_Co=256
	set guifont=FiraCode Nerd Font

	"" Airline
	let g:airline_powerline_fonts = 1
	let g:airline_theme='bubblegum'

	" Code display
	set display=truncate
	set showbreak=↪
	set showmatch
	set nowrap

	" Display invisible characters
	set list
	set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮

	" Code folding
	set foldmethod=syntax
	set foldlevelstart=99
	set foldnestmax=10
	set nofoldenable
	set foldlevel=1

	" Performance
	set ttyfast
	set updatetime=1000
	set ttimeout
	set ttimeoutlen=100
	
	" Tools
	set shell=$SHELL
	set wildmode=list:longest
	if has('mouse') | set mouse=a | endif
	set backspace=indent,eol,start
	set wildchar=<TAB>
	set wildmenu
	set clipboard^=unnamed,unnamedplus
	set undofile
	""set diffopt+=vertical,iwhite,internal,algorithm:patience,hiddenoff

	" Indent
	set autoindent
	set smarttab
	set tabstop=4
	set softtabstop=4
	set shiftwidth=4
	set shiftround

	" Navigation
	set nostartofline

	" Windows
	set splitbelow
	set splitright
	
	" Searching
	set smartcase
	set ignorecase
	set incsearch
	set hlsearch
	set nolazyredraw

	" Other
	set noerrorbells
	set visualbell
	set scrolloff=8
	set history=200

	" Mapping
	"" Leader
	let mapleader=" "
	nnoremap <SPACE> <Nop>

	nmap <leader>ff :Files!<CR>
	nmap <leader>fs :w<CR>
	nmap <leader>fd :w !diff % -<CR>
	nmap <leader>c :Commands<CR>
	nmap <leader>q :q<CR>


	"" Move by visual lines not by file lines
	nnoremap <silent> k gk
	nnoremap <silent> j gj

	"" Keep selection when indenting/outdenting
	vnoremap < <gv
	vnoremap > >gv

	"" Yank to the end
	nnoremap Y y$

	"" Navigation
	nnoremap <C-k> <C-u>
	nnoremap <C-j> <C-d>

	""" Movement in insert mode (alt)
	inoremap <M-h> <Left>
	inoremap <M-j> <Down>
	inoremap <M-k> <Up>
	inoremap <M-l> <Right>

	""" Recenter
	nnoremap }   }zz
	nnoremap {   {zz
	nnoremap ]]  ]]zz
	nnoremap [[  [[zz
	nnoremap []  []zz
	nnoremap ][  ][zz

call plug#end()

"Theme, for whatever reason cannot be called in plug
set background=dark
colorscheme gruvbox
syntax on


