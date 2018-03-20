if exists("g:autoloaded_tabtab") | finish | endif
let g:autoloaded_tabtab = 1

func! tabtab#complete_or_indent(direction)
  " complete if popup-menu displayed
  if pumvisible() | return s:complete(a:direction) | endif

  let line = getline('.')  " current line
  let col  = col('.') - 1  " current 0-indexed column

  if a:direction > 0 && (!s:finishing_word(line, col) || s:want_tab())
    return s:indent()
  endif

  " non-whitespace characters before cursor
  let prefix = expand(matchstr(line[0:col-1], '\S*$'), 1)

  " complete filename if finishing a path
  if prefix =~ '^[~/.]' | return "\<C-X>\<C-F>" | endif

  " perform custom completion if possible
  if !empty(&completefunc) && call(&completefunc, [1, prefix]) >= 0
    return "\<C-X>\<C-U>"
  endif

  return s:complete(a:direction)
endf

func! s:finishing_word(line, col)
  " preceded by word/filename char AND NOT inside word
  return a:line[a:col-1] =~ '\k\|[/~.]' && a:line[a:col] !~ '\k'
endf

func! s:want_tab()
  " this needs to be smarter
  return ! &expandtab
endf

func! s:complete(direction)
  return a:direction > 0 ? "\<C-N>" : "\<C-P>"
endf

func! s:indent()
  return (!empty(&indentexpr) || &cindent) ? "\<C-F>" : "\<Tab>"
endf
