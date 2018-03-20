if exists("g:loaded_tabtab") || &cp
  finish
endif
let g:loaded_tabtab = 1

if get(g:, 'tabtab_maps', 1)
  if mapcheck('<Tab>', 'i') == ''
    inoremap <expr> <Tab>    tabtab#complete_or_indent(+1)
  endif
  if mapcheck('<S-Tab>', 'i') == ''
    inoremap <expr> <S-Tab>  tabtab#complete_or_indent(-1)
  endif
endif
