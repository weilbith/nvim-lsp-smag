# NeoVim Language Server Smart Tags

This plugin allows to seamlessly integrate the language server protocol in
NeoVim. It leverages the
[tagfunc](https://neovim.io/doc/user/options.html#'tagfunc') option to customize
how tags are searched. Instead of searching in a tag file, this plugin queries
a possibly attached language client. It puts the definition, declaration,
implementation and type definition into one list, making it easy to use all of
these language server features. No need to define an endless number new mappings
and never know which to use.

The main advantage is to simplify the whole process of either using a tag file or
the `vim.lsp.client`. This does also preserves the |tag-stack|, allowing to
navigate as always also with language servers support.

## Installation

Install the plugin with your favorite manager tool. Here is an example using
[dein.vim](https://github.com/Shougo/dein.vim):

```vim
call dein#add('weilbith/nvim-lsp-smag')
```

It is recommended to use the [nvim-lsp](https://github.com/neovim/nvim-lsp)
plugin to attach language client to your buffers.

## Usage

The plugin works out of the box. You can simply use all standard ex-commands
for [tags](https://neovim.io/doc/user/tagsrch.html) as always. No need to tweak
your mappings to conditional switch the to execute command (checkout
[nvim-lsp-bacomp](https://github.com/weilbith/nvim-lsp-bacomp) when still
needed).

To always jump directly to the definition no matter if the implementations etc.
just use the `:tag` command. This will always jump to the tag location with the
highest priority. The priority sort order can be defined in the configuration.
Furthermore it is also configurable which language server prover to query for
locations.

**Warning:**

Using this plugin will remove the ability to search for arbitrary tags with any
of the tag related ex-commands. As long as a language client is available, the
current cursor location is used by the server to determine the results.
Nevertheless it is necessary to define the `[name]` parameter. This parameter
gets simply ignored as long as no tag file is used. Else the ex-commands work
different for empty `[name]` parameter. There it is recommended to use mappings
like `<cmd>execute 'tjump ' . expand('<cword>')<CR>` or type `<C-R><C-W>` for
interactive solutions. Thereby it will work for any case. To search for tags,
I recommend to use the symbols by the language server. Checkout
`vim.lsp.bug.document_symbols()` (and the `workspace` version) or plugins like
[nvim-lsp-denite](https://github.com/weilbith/nvim-lsp-denite).
