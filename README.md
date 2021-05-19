# NeoVim Language Server Smart Tags

This plugin allows to seamlessly integrate the language server protocol into
_NeoVim_. It leverages the
[tagfunc](https://neovim.io/doc/user/options.html#'tagfunc') option to customize
how tags are searched. Instead of searching in a tag file, this plugin queries
all attached language clients. It queries the servers for the definition,
declaration, implementation and type definition. The resulting list combines all
of them together. It can be partially empty if the server doesn't provide all
capabilities or a response was empty. In case there is no language client
connected to the current buffer, it falls back to the default functionality with
a tag file.

The main advantage is to simplify the whole process of either using a tag file
or the `vim.lsp.client`. Furthermore it also combines all location lookup
functions together. Instead of defining a separated mapping for the definition,
declaration, implementation and type definition this provides all at once. It
can be configured which of them should have the highest priority. So it is still
possible to jump directly or select from a list of all locations.

## Installation

Install the plugin with your favorite manager tool. Here is an example using
[dein.vim](https://github.com/Shougo/dein.vim):

```vim
call dein#add('weilbith/nvim-lsp-smag')
```

It is recommended to use the
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) plugin to attach
language clients to your buffers.

## Usage

The plugin works out of the box. You can simply use all standard ex-commands
for [tags](https://neovim.io/doc/user/tagsrch.html) as always. No need to tweak
your mappings to conditional switch the to execute command (checkout
[nvim-lsp-bacomp](https://github.com/weilbith/nvim-lsp-bacomp) when still
needed).

To always jump directly to the definition no matter if the implementations etc.
just use the `:tag` command. This will always jump to the tag location with the
highest priority. The priority sort order can be defined in the configuration.
Furthermore it is also configurable which language server providers to query for
locations.

_Checkout the
[docs](https://github.com/weilbith/nvim-lsp-smag/blob/master/doc/lsp_smag.txt)
(`:help lsp-smag.txt`) to read about how to configure the behavior of this
plugin._

---

**Warning:**

Using this plugin will remove the ability to search for arbitrary tags with any
of the tag related ex-commands. As long as a language client is available, the
current cursor location is used by the server to determine the results.
Nevertheless it is necessary to define the `[name]` parameter. This parameter
gets simply ignored as long as no tag file is used. Else the ex-commands work
different for empty `[name]` parameter. Therefore it is recommended to use
mappings like `<cmd>execute 'tjump ' . expand('<cword>')<CR>` or type
`<C-R><C-W>` for interactive solutions. Thereby it will work for any case. To
search for tags, I recommend to use the symbols by the language server. Checkout
`vim.lsp.bug.document_symbols()` (and the `workspace` version) or plugins like
[nvim-lsp-denite](https://github.com/weilbith/nvim-lsp-denite).
