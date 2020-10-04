if exists('g:loaded_lsp_smag')
  finish
endif

let g:loaded_lsp_smag = 1

lua require 'lsp_smag'
set tagfunc=v:lua.lsp_smag.tagfunc
