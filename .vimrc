set number
set ruler
syntax on
" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" copy indent from current line when starting a new line
set autoindent
" indent after lines starting with '{', 'do', 'if', etc.
set cindent
set cinkeys-=0#
set indentkeys-=0#
" when pressing Tab key, convert to 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Configure vim-gitgutter (shows git diff changes while editing a file)
highlight! link SignColumn LineNr
highlight GitGutterAdd    guifg=#009900 ctermfg=2 "green
highlight GitGutterChange guifg=#bbbb00 ctermfg=3 "yellow
highlight GitGutterDelete guifg=#ff2222 ctermfg=1 "red

" Reduce the time between file updates and certain actions,
" e.g. writing swap files, triggering `CursorHold` autocommand, etc.
" The vim-gitgutter plugin uses `CursorHold` to display diff markers.
" These markers will now display after 100ms, rather than the default
" 4000ms (4 seconds).
set updatetime=100
