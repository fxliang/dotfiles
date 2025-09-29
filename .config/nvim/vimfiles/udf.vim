"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   user define function
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Tab2Space(tabs)
    :set ts=tabs
    :set expandtab
    :%retab!
endfunction

function! Space2Tab(tabs)
    :set ts=tabs
    :set noexpandtab
    :%retab!
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" e.g.	call FormatSrcs("*.c *.h")
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! FormatSrcs(subfix)
	silent exe "args " . a:subfix
	silent argdo !start astyle --delete-empty-lines --ascii -p --indent=tab=4
				\--indent-lables --indent-cases --style=ansi -n % | update
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" e.g call ChangeEncodingTo('*.txt *.c', 'utf-8')
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ChangeEncodingTo(subfix, enc)
	silent exe "args " . a:subfix
	silent exe "argdo set fenc=" . a:enc . " | update "	
endfunction

function! AdjustFontSize(amount)
	let g:fontsize = g:fontsize + a:amount	
	let g:fontset = FontStr(g:fonts, g:fontsize)
	if !has('nvim')
		exe 'set gfn=' . g:fontset
	else
		exe "GuiFont! " . g:fontset
	endif
	silent args $BASE_DIR/fontset.vim
	silent argdo %s/let g:fontsize = \d\+/\="let g:fontsize = " 
				\. g:fontsize/g | update | bd
endfunction

function! InitializeFontsetfile()
	let s:lines = [
				\"let g:fonts = [",
				\"			\\'FantasqueSansMono\\ NF', ",
				\"			\\'MonofurForPowerline\\ NF', ",
				\"			\\'JetBrainsMono\\ NF', ",
				\"			\\'Consolas'",
				\"			\\]",
				\"let g:fontsize = 14",
				\"function! FontStr(fontlist, fontsize)",
				\"	let s:gfn = ''",
				\"	for s:fontname in a:fontlist",
				\"		let s:gfn = s:gfn . s:fontname . ':h' . a:fontsize . ':cANSI:qDRAFT'",
				\"		if index(a:fontlist, s:fontname) != len(a:fontlist) - 1",
				\"			let s:gfn = s:gfn . ','",
				\"		endif",
				\"	endfor",
				\"	return s:gfn",
				\"endfunction",
				\"let g:fontset = FontStr(g:fonts, g:fontsize)",
				\]
	args $BASE_DIR/fontset.vim
	for line in s:lines
		argdo call append(line('$'), line)
	endfor
	argdo update | bd 
endfunction

function! GetPlugsInfo()
	let items = items(g:plugs)
	for it in items
		echo it[0]
	endfor
endfunction

function! GetFilesR(path)
	let ret = []
	let l:tpath = fnamemodify(a:path, ':p')
	let fs = readdir(l:tpath)
	for f in fs
		if getftype(l:tpath . f) == "file"
			let ret = ret + [l:tpath . f]
		elseif getftype(l:tpath . f) == "dir"
			let ret = ret + GetFilesR(l:tpath . f)
		endif
	endfor
	return ret
endfunction

function! GetFilesPattern(path, pattern)
	let ret = []
	let l:flist = GetFilesR(a:path)
	for f in l:flist
		if matchstr(f, a:pattern) != ""
			let ret = ret + [escape(f, ' \')]
		endif
	endfor
	return ret
endfunction

function! GetDirs(path, pattern)
	let fs = []
	let l:flist = GetFilesR(a:path)
	for f in l:flist
		if matchstr(f, a:pattern) != ""
			let fs += [f]
		endif
	endfor

	let ret = []
	for f in fs
		let ret += [escape(fnamemodify(f, ':p:h'), ' \')] 
	endfor
	for r in ret
		if count(ret, r) > 1
			call remove(ret, index(ret, r))
		endif
	endfor
	return ret
endfunction

function! GenCompileCommandsFile(path, defines, includes, compilr) abort
	if type(a:includes) == type([])
		if len(a:includes)
			let incs = a:includes
		else
			let incs = GetDirs(a:path, '.*\.h\(pp\)*$')
		endif
	endif

	let incarg = ''
	for inc in incs
		let incarg = incarg . ' -I' . inc
	endfor

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	let defarg = ''
	"define string
	if type(a:defines) == type([])
		if len(a:defines)
			for def in a:defines
				let defarg = defarg . ' -D' . def
			endfor
		endif
	endif

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	let files = GetFilesPattern(a:path, '.*\.cc*$')

	let output = []

	if a:compilr == ''
		let l:cplr = 'gcc.exe'
	else
		let l:cplr = a:compilr
	endif
	let defs = ''
	let output += ['[']

	for file in files
		let output += ['{']
		let output += ['"directory":"' . escape(fnamemodify(a:path . '/build/', ':p:h') , ' \') . '",']
		let output += ['"command":"' . l:cplr . incarg . defarg . ' -c ' . file . '",']
		let output += ['"file":"' . file . '"']
		if index(files, file) < len(files)-1
			let output += ['},']
		else
			let output += ['}']
		endif
	endfor

	let output += [']']
	""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	if has('macunix')
		let l:output_file = fnamemodify(a:path, ':p:h') . '/compile_commands.json'
	else
		let l:output_file = fnamemodify(a:path, ':p:h') . '\compile_commands.json'
	endif
	let l:ccmdext = filereadable(l:output_file)
	exe 'args ' . expand(l:output_file)
	if l:ccmdext
		argdo g/^.*$/d
	endif
	for out in output
		argdo call append(line('$')-1, out)
	endfor
	argdo call feedkeys('gg=G') | w
	argdo update | w | bd
endfunction

function! FindFirstDotClangFile(stpath) abort
	let l:files = readdir(fnamemodify(a:stpath, ':p:h'))	
	for file in l:files
		if file == '.clang'
			return fnamemodify(file, ':p')
		endif
	endfor
	if fnamemodify(a:stpath, ":p:h") == fnamemodify(a:stpath . '/..', ':p:h')
		echo 'get to toppest but no .clang file found' . fnamemodify(a:stpath . '/..', ':p:h')
		return ''
	else
		return FindFirstDotClangFile(a:stpath . '/..')
	endif
endfunction
"
function! ParseDotClangFile(dotfile) abort
	let ret = {'define':[], 'include':[]}
	let lines = readfile(a:dotfile)
	for line in lines
		if matchstr(line, '^\s*-D\h\w*\s*$') != ""
			let ret['define'] += [matchstr(line, '\(^\s*-D\)\@<=\(\h\w*\)')]
			" pettern needed to be enhanced
		elseif matchstr(line, '\(^\s*-I\)\(\(\.\+\|\u:\)\|\w\+\)\?\(\(\/\?\(\w\+\|\.\+\)\)\|\\\)*') != ""
			let ret['include'] += [matchstr(line, '\(^\s*-I\)\@<=\(.*\)')]
		endif
	endfor
	return ret
endfunction
