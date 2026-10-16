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

require 'kickstart.plugins.neo-tree'
require 'custom.plugins'

-- vim: ts=2 sts=2 sw=2 et
