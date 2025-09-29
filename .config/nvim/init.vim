"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! SourceIfReadable(path)
	if filereadable(a:path)
		exe 'source ' . a:path
	endif
endfunction
command! -nargs=1 SoReadable :call SourceIfReadable(<args>)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
	let trueInitFile = expand('<sfile>:p:h') . '/sysinit.vim'
else
	let ftype = getftype(expand('<sfile>'))
	if  ftype== "link"
		let trueInitFile = "~/.config/nvim/sysinit.vim"
	else
		let trueInitFile = expand('<sfile>:p:h') . '/sysinit.vim'
	endif
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('unix')
	exe 'source ' . trueInitFile
endif
