vim.pack.add {
  { src = 'https://github.com/akinsho/toggleterm.nvim', version = vim.version.range '*' },
}

require('toggleterm').setup {
  size = 20,
  -- Ctrl+/ arrives as <C-_> on legacy terminals and as <C-/> with modern keyboard protocols.
  open_mapping = { [[<C-_>]], [[<C-/>]] },
  direction = 'horizontal',
  shade_terminals = true,
  float_opts = {
    border = 'curved',
  },
}
