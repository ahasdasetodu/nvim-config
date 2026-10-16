local M = {}

local function project_root(bufnr)
  return vim.fs.root(bufnr, {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'uv.lock',
    '.python-version',
    '.git',
  }) or vim.fn.getcwd()
end

local function realpath(path)
  return (vim.uv.fs_realpath(path)) or path
end

local function command_output(cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd, text = true }):wait()
  if result.code ~= 0 then return nil end
  local stdout = vim.trim(result.stdout or '')
  if stdout == '' then return nil end
  return stdout
end

local function python_version(path)
  local version = command_output({ path, '-c', 'import sys; print(sys.version.split()[0])' })
  return version or '?'
end

---@param list table[]
---@param seen table<string, boolean>
local function add(list, seen, path, source, version)
  if not path or path == '' or vim.fn.executable(path) ~= 1 then return end
  local real = realpath(path)
  if seen[real] then return end
  seen[real] = true
  list[#list + 1] = {
    path = real,
    source = source,
    version = version or python_version(real),
  }
end

---Interpreters for the current project, most relevant first.
---@param bufnr integer
function M.choices(bufnr)
  local root = project_root(bufnr)
  local list, seen = {}, {}

  for _, name in ipairs { '.venv', 'venv', 'env' } do
    add(list, seen, root .. '/' .. name .. '/bin/python', 'project')
  end

  if vim.fn.executable 'uv' == 1 then
    local found = command_output({ 'uv', 'python', 'find', '--no-python-downloads' }, root)
    add(list, seen, found, 'uv')
  end

  local virtual_env = vim.env.VIRTUAL_ENV
  if virtual_env then add(list, seen, virtual_env .. '/bin/python', 'active') end

  local conda = vim.env.CONDA_PREFIX
  if conda then add(list, seen, conda .. '/bin/python', 'active') end

  if vim.fn.executable 'uv' == 1 then
    local listed = command_output { 'uv', 'python', 'list', '--only-installed' }
    if listed then
      for line in vim.gsplit(listed, '\n', { plain = true }) do
        if not line:find('->', 1, true) then
          local version, path = line:match '^cpython%-(%d+%.%d+%.%d+)%-%S+%s+(%S+)'
          if version and path then add(list, seen, path, 'installed', version) end
        end
      end
    end
  end

  return list
end

local function current_python()
  if vim.g.python_interpreter and vim.g.python_interpreter ~= '' then return realpath(vim.g.python_interpreter) end
  local client = vim.lsp.get_clients({ name = 'pyright' })[1]
  local path = client and client.settings and client.settings.python and client.settings.python.pythonPath
  if path and path ~= '' then return realpath(path) end
end

function M.apply(path)
  path = realpath(path)
  vim.g.python_interpreter = path

  vim.lsp.config('pyright', {
    settings = {
      python = { pythonPath = path },
    },
  })

  local clients = vim.lsp.get_clients { name = 'pyright' }
  for _, client in ipairs(clients) do
    client.settings = client.settings or {}
    client.settings.python = vim.tbl_deep_extend('force', client.settings.python or {}, { pythonPath = path })
    client.config.settings = vim.tbl_deep_extend('force', client.config.settings or {}, { python = { pythonPath = path } })
    client:notify('workspace/didChangeConfiguration', { settings = nil })
  end

  local where = #clients > 0 and 'Pyright is using' or 'Pyright will use'
  vim.notify(('%s %s'):format(where, path), vim.log.levels.INFO)
end

function M.pick()
  local bufnr = vim.api.nvim_get_current_buf()
  local choices = M.choices(bufnr)
  if #choices == 0 then
    vim.notify('No Python interpreters found', vim.log.levels.WARN)
    return
  end

  local current = current_python()
  vim.ui.select(choices, {
    prompt = 'Python interpreter',
    format_item = function(item)
      local mark = current and realpath(item.path) == current and '* ' or '  '
      return ('%s%-9s %s  %s'):format(mark, item.source, item.version, vim.fn.fnamemodify(item.path, ':~'))
    end,
  }, function(choice)
    if choice then M.apply(choice.path) end
  end)
end

vim.keymap.set('n', '<leader>pi', M.pick, { desc = 'Choose [P]ython [I]nterpreter' })

return M
