local gh = require 'config.pack'

-- See `:help vim.version.range()`
vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = {
    nerd_font_variant = 'mono',
  },
  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },
  snippets = { preset = 'luasnip' },
  -- Lua matcher. `'prefer_rust_with_warning'` downloads a prebuilt binary instead.
  -- See `:help blink-cmp-config-fuzzy`
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}
