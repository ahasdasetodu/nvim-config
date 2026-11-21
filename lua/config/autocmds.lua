-- See `:help vim.diagnostic.Opts`
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  -- Floats wrap long messages; inline virtual text cannot.
  float = { border = 'rounded', source = 'if_many', max_width = 80 },
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

-- Show the full (wrapped) diagnostic message when the cursor rests on a line with one.
-- Fires after `updatetime` ms of no movement; closes when the cursor moves.
vim.api.nvim_create_autocmd('CursorHold', {
  desc = 'Show diagnostics for the current line in a float',
  group = vim.api.nvim_create_augroup('diagnostic-float', { clear = true }),
  callback = function()
    -- Don't stack on top of another float (hover docs, completion, etc).
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(win).relative ~= '' then return end
    end
    vim.diagnostic.open_float { scope = 'line', focus = false }
  end,
})

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
