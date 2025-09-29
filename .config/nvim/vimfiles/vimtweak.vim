if has('win64')
	let g:vimtweakdll=$BASE_DIR . '/vimtweak64.dll'
elseif has('win32')
	let g:vimtweakdll=$BASE_DIR . '/vimtweak32.dll'
endif
if has('win32')|| has('win64')
	command! -nargs=1 SetAlpha :call libcallnr(g:vimtweakdll, 'SetAlpha', <args>)
	command! -nargs=0 ResetAlpha :call libcallnr(g:vimtweakdll, 'SetAlpha', 255)
	command! -nargs=0 MaxWindowOn :call libcallnr(g:vimtweakdll, 'EnableMaximize', 1)
	command! -nargs=0 MaxWindowOff :call libcallnr(g:vimtweakdll, 'EnableMaximize', 0)
	command! -nargs=0 TopWindowOn :call libcallnr(g:vimtweakdll, 'EnableTopMost', 1)
	command! -nargs=0 TopWindowOff :call libcallnr(g:vimtweakdll, 'EnableTopMost', 0)
	command! -nargs=0 EnableCaption :call libcallnr(g:vimtweakdll, 'EnableCaption', 1)
	command! -nargs=0 DisableCaption :call libcallnr(g:vimtweakdll, 'EnableCaption', 0)
endif
