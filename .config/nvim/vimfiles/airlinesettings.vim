"-------------------------------------------------------------------------------
"   airline settings
"-------------------------------------------------------------------------------
    let g:airline_theme='dark'
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#buffer_nr_show = 1
    " 关闭状态显示空白符号计数,用处不大"
    let g:airline#extensions#whitespace#enabled = 0
    let g:airline#extensions#whitespace#symbol = '!'
    let g:airline#extensions#tabline#fnamemod=':t'
    let g:webdevicons_enable_airline_tabline = 1
    let g:webdevicons_enable_airline_statusline = 1
