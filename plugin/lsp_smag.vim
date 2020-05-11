if exists('g:loaded_lsp_smag')
  finish
endif

let g:loaded_lsp_smag = 1

if !exists('g:lsp_smag_enabled_providers')
  let g:lsp_smag_enabled_providers = ['definition', 'declaration', 'implementation', 'typeDefinition']
endif

if !exists('g:lsp_smag_tag_kind_priority_order')
  let g:lsp_smag_tag_kind_priority_order = ['definition', 'declaration', 'implementation', 'typeDefinition']
endif

lua require 'lsp_smag'
set tagfunc=v:lua.lsp_smag.tagfunc
