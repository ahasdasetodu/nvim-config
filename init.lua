require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.pack'

-- editor and git load before ui so gitsigns is configured before the colorscheme.
require 'plugins.editor'
require 'plugins.git'
require 'plugins.ui'
require 'plugins.telescope'
require 'plugins.lsp'
require 'plugins.python'
require 'plugins.format'
require 'plugins.cmp'
require 'plugins.treesitter'
require 'plugins.neo-tree'
require 'plugins.toggleterm'
require 'plugins.render-markdown'
require 'plugins.claude'

-- Available but disabled. Uncomment to enable.
-- require 'plugins.autopairs'   -- overlaps with mini.pairs (plugins/editor.lua)
-- require 'plugins.indent-line'
-- require 'plugins.lint'
-- require 'plugins.debug'       -- DAP, set up for Go

-- vim: ts=2 sts=2 sw=2 et
