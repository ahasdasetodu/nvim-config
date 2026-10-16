-- See `:help vim.diagnostic.Opts`
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  virtual_text = true,
  virtual_lines = false,

  -- Auto open the float when jumping with `[d` and `]d`
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}

-- See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Reload buffers changed on disk (for example after saving in Cursor).
-- FocusGained covers switching back to the terminal; CursorHold covers
-- terminals that never send focus events, such as some WSL setups.
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  desc = 'Check buffers for changes made outside Neovim',
  group = vim.api.nvim_create_augroup('refresh-external-changes', { clear = true }),
  callback = function()
    if vim.fn.mode() == 'c' or vim.fn.getcmdwintype() ~= '' then
      return
    end
    vim.cmd 'checktime'
  end,
})
