"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"	env settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	let $MYVIMRC=expand('<sfile>:p')
	if has('unix')
		if has('nvim')
			let $BASE_DIR=$HOME."/.config/nvim/vimfiles"
			let $XDG_CONFIG_HOME=$HOME . "/.config/nvim"
		else
			let $BASE_DIR=$HOME."/.vim"
		endif
	elseif has("win32") || has('win64')
		if has('nvim') "nvim-qt under windows
			let $BASE_DIR=expand('<sfile>:p:h') . "\\vimfiles"
			let $XDG_CONFIG_HOME=$VIM
			if filereadable($BASE_DIR . '/../init.vim')
				exe 'source ' . $BASE_DIR . '/../init.vim'
			endif
		else	"vim under win32 platform
			let $BASE_DIR=expand('<sfile>:p:h') . "\\vimfiles"
			SoReadable $BASE_DIR . '/vimtweak.vim'
		endif
	endif
	let $PLUG_DIR = $BASE_DIR . '/plugged'
	if !exists('g:loaded_plug')
		SoReadable $BASE_DIR . '/autoload/plug.vim' 
	endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"	encoding settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
	"set termencoding=utf-8
	set encoding=utf-8
	SoReadable $VIMRUNTIME . '/delmenu.vim'
	SoReadable $VIMRUNTIME . '/menu.vim'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"	plugin enable or disable
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	call plug#begin($PLUG_DIR)
		Plug 'vim-scripts/c.vim', {'do':':PlugInstall'}
		Plug 'scrooloose/nerdtree', {'do':':PlugInstall'}
		Plug 'ryanoasis/vim-devicons', {'do':':PlugInstall'}
		Plug 'vim-airline/vim-airline', {'do':':PlugInstall'}
		Plug 'vim-airline/vim-airline-themes', {'do':':PlugInstall'}
		Plug 'majutsushi/tagbar', {'do':':PlugInstall'}
		Plug 'vim-scripts/a.vim', {'do':':PlugInstall'}
		Plug 'neoclide/coc.nvim', {'branch': 'release', 'do':':PlugInstall'}
		Plug 'dracula/vim', {'as':'dracula','do':':PlugInstall'}
		Plug 'kevinoid/vim-jsonc', {'do':':PlugInstall'}
		"Plug 'jaxbot/semantic-highlight.vim', {'for': ['c', 'python', 'cpp', 'dosbatch', 'vim'], 'do':':PlugInstall'}
		"Plug 'Yggdroot/indentLine', {'for': ['c', 'python', 'cpp', 'dosbat','vim'], 'do':':PlugInstall'}
		Plug 'jiangmiao/auto-pairs', {'do':':PlugInstall'}
		Plug 'dominikduda/vim_current_word', {'do':':PlugInstall'}
		"Plug 'guns/vim-sexp', {'do':':PlugInstall'}
		Plug 'luochen1990/rainbow', {'do':':PlugInstall'}
		Plug 'voldikss/vim-floaterm', {'do':':PlugInstall'}
		Plug 'lilydjwg/colorizer', {'do':':PlugInstall'}
		"Plug 'boydos/emmet-vim', {'do':':PlugInstall'}
		"Plug 'tpope/vim-fugitive', {'do':':PlugInstall'}
		Plug 'https://gitee.com/liangfxtd/traces.vim.git', {'do':':PlugInstall'}
    Plug 'https://github.com/voldikss/vim-floaterm.git'
    Plug 'https://bgithub.xyz/github/copilot.vim'
    Plug 'jaxbot/semantic-highlight.vim'
    if has('nvim')
      Plug 'lewis6991/gitsigns.nvim', {'do:':':PlugInstall'}
      "Plug 'kevinhwang91/nvim-ufo'
      "Plug 'kevinhwang91/promise-async'
    endif

	call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"	load plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  let g:plug_url_format = 'git@github.com:%s.git'
	" source user defined functions
	SoReadable $BASE_DIR . '/udf.vim'	
	" load airline settings
	if match(string(g:plugs), "airline") > 0 
		SoReadable $BASE_DIR . '/airlinesettings.vim'
	endif
	" load coc settings
	if match(string(g:plugs), "coc")>0 
		SoReadable $BASE_DIR . '/cocsettings.vim'
	endif
  if has('nvim') && match(string(g:plugs), "gitsigns")>0 
    exe "lua require('gitsigns-settings')"
  endif

	" enable rainbow
	if match(string(g:plugs), "rainbow") > 0
		let g:rainbow_active = 1
	endif
	"setting for indentline
	if match(string(g:plugs), 'indentLine') > 0
		let g:indentLine_enabled = 1
		let g:indentLine_fileType = ['c', 'cpp', 'vim', 'python']
	endif
	" set gui commands for nvim-qt
	if has('nvim') && has('gui_running')
		SoReadable $VIM . "/../nvim-qt/runtime/plugin/nvim_gui_shim.vim"
	endif
	let NERDTreeChDirMode=2
  let g:AutoPairsMapsCR=0
"-------------------------------------------------------------------------------
"   GUI options
"-------------------------------------------------------------------------------
	if has('gui') || exists('g:GuiLoaded') == 1
		" if no fontset.vim exists in $BASE_DIR, make one
		if filereadable($BASE_DIR . '/fontset.vim') == 0
			call InitializeFontsetfile()
		endif
		source $BASE_DIR/fontset.vim

		" for gvim
		if !has('nvim')
			"set imactivatekey=C-space
			"inoremap <ESC> <ESC>:set iminsert=0<CR>
			"Toggle Menu and Toolbar
			set guioptions-=m   " hide menu bar
			set guioptions-=T   " hide tool bar
			set guioptions-=r   " hide right scroll bar
			set guioptions-=R   " hide right scroll bar
			set guioptions-=l
			set guioptions-=L
			map <silent> <F2> :if &guioptions =~# 'T'<Bar>
						\set guioptions-=T <Bar>
						\set guioptions-=r <Bar>
						\set guioptions-=l <Bar>
						\set guioptions-=L <Bar>
						\set guioptions-=r <Bar>
						\set guioptions-=R <Bar>
						\set guioptions-=m <Bar>
						\else<Bar>
						\set guioptions+=T <Bar>
						\set guioptions+=m <Bar>
						\set guioptions-=l <Bar>
						\set guioptions-=L <Bar>
						\set guioptions-=r <Bar>
						\set guioptions-=R <Bar>
						\endif<CR>
			exe 'set gfn=' . g:fontset
		" for nvim-qt
		else
			exe "GuiFont! " . g:fontset
			" close popupmenu and tabline of nvim-qt
			try
				call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
				call rpcnotify(1, 'Gui', 'Option', 'Popupmenu', 0)
			catch
			endtry
		endif
	endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   basic settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" pupup menu pseudo-transparency
	if has('nvim')
		set pumblend=30
		hi PmenuSel blend=0
	endif
	set mouse=a
	set winaltkeys=no
	set background=dark
	if !has('gui_running')
		set t_Co=256
	endif
		if match(string(g:plugs), "dracula") 
			color dracula
		else
			color desert
		endif
	let g:mapleader=','
	set number
	set relativenumber
	filetype on
	filetype plugin on
	filetype indent on
	syntax on
	if has('win32')
		set ffs=dos,unix,mac
	elseif has('unix')
		set ffs=unix,dos,mac
	endif
	set nobackup
	set noswapfile
	set hls
	set linebreak
	set nowrap
	set autochdir
	set shiftwidth=2
	set tabstop=2
	set softtabstop=2
	set expandtab
	set bs=indent,start,eol
	set shortmess=atI
	set incsearch
	set ruler
	set scrolloff=5
	set autoread
	set autoindent
	set infercase
	set smartcase
	set showmatch
	set matchtime=2
  function! IsWsl()
    return isdirectory('/mnt/c/Windows')
  endfunction
  if IsWsl()
    set clipboard=unnamedplus
    let g:clipboard = {
        \ 'name': 'win32yank',
        \ 'copy': {
        \    '+': 'win32yank.exe -i --crlf',
        \    '*': 'win32yank.exe -i --crlf',
        \  },
        \ 'paste': {
        \    '+': 'win32yank.exe -o --lf',
        \    '*': 'win32yank.exe -o --lf',
        \ },
        \ 'cache_enabled': 0,
        \ }
  else
    set clipboard+=unnamed
  end
	set cursorline
	set laststatus=2
	set cc=80
	let python_highlight_all = 1
	" high light the col 81
	highlight OverLength ctermbg=red ctermfg=white guibg=#FFA9A9
	match OverLength />\%81v.\+/
	set wildmenu
	set wildmode=list:longest,full
	if has('nvim')
		set termguicolors
	endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Autocmd settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	au FileType c,cpp setlocal fdm=syntax
	au FileType c,cpp setlocal tags+=../tags
	au FileType python setlocal fdm=indent
  au FileType rust setlocal fdm=syntax
	au FileType vim setlocal fdm=indent
	au FileType json setlocal fdm=syntax shiftwidth=2 tabstop=2 softtabstop=2
  au FileType kotlin setlocal fdm=syntax sw=4 ts=4 sts=4
	if has('python3')
		au FileType python nnoremap <buffer> <F5> :py3file %<CR>
	endif
	au FileType dosbatch nnoremap <buffer> <F5> :!%<CR>
	"go to the last edit position
	au BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe
				\"normal`\"" | endif
	if match(string(g:plugs), "rainbow") > 0
		au BufEnter *.c,*.cc,*.cpp,*.h,*.hpp,*.py,*.pyw,*.bat RainbowToggleOn
	endif
	"au! BufWritePost $MYVIMRC so $MYVIMRC
	if !has('nvim') && has('win32')
		"au! BufWritePost $VIM/sysinit.vim so $VIM/sysinit.vim
	endif
	if match(string(g:plugs), "semantic-highlight") > 0
		au BufEnter *.c,*.cc,*.cpp,*.h,*.hpp,*.py,*.pyw,*.bat,*.html,*.htm,*.js SemanticHighlight
	endif
	"au! InsertLeave * set imdisable
	"au! InsertEnter * set noimdisable
	"au! VimEnter * set imdisable
	"autocmd CursorHold,BufEnter * silent! call Timer()
	"function! Timer()
	"	if expand('%') != ''
	"		checktime
	"		call feedkeys("f\e")
	"	endif
	"endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   keymap settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	if has('GUI') || exists('g:GuiLoaded')
		nnoremap <C-Tab>    :bn<CR>
		nnoremap <C-S-Tab>  :bp<CR>
	endif
	nnoremap ,bn		:bn<CR>
	nnoremap ,bp		:bp<CR>
	nnoremap ,w         :w<CR>
	nnoremap ,s         :so %<CR>
	nnoremap ,v         :e $MYVIMRC<CR>
	nnoremap ,q         :q<CR>
	nnoremap ,tt        :TagbarToggle<CR>
	nnoremap <A-t>		:TagbarToggle<CR>
	nnoremap ;          :
	nnoremap <F3>       :cnext<CR>
	nnoremap <S-F3>     :cprev<CR>
	nnoremap //         viwy/<C-R>"<CR>
	nnoremap /<SPACE>   :nohls<CR>
	" ctrl+ hjkl to switch window
	nnoremap <C-l> <ESC><C-w>l
	nnoremap <C-h> <ESC><C-w>h
	nnoremap <C-j> <ESC><C-w>j
	nnoremap <C-k> <ESC><C-w>k
	" Alt+jk to move lines up or down
	nnoremap <A-j> :m+<CR>==
	nnoremap <A-k> :m-2<CR>==
	inoremap <A-j> <Esc>:m+<CR>==gi
	inoremap <A-k> <Esc>:m-2<CR>==gi
	vnoremap <A-j> :m'>+<CR>gv=gv
	vnoremap <A-k> :m-2<CR>gv=gv
	nnoremap ,py "0p
	"nnoremap <F3>	:NERDTreeToggle<CR>
	if has('gui') || exists('g:GuiLoaded')
		nnoremap <A-=>	:call AdjustFontSize(1)<CR>
		nnoremap <A-->	:call AdjustFontSize(-1)<CR>
		"if exists('g:Nvim_qt')
		noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
		noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
		inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
		inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a
		"endif
	endif
	nnoremap <A-f> :NERDTreeToggle<CR>
	if has('nvim')
		map! <S-Insert> <C-R>+
	endif

