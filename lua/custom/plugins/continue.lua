vim.pack.add { 'https://github.com/Megatherium/continue.nvim' }

require('continue').setup {
  cn_bin = 'cn',
  continue_config = vim.fn.expand '~/.continue/config.yaml',
  port_range = { 8000, 8010 },
  terminal = {
    position = 'right',
    hsize = 40,
  },
}

-- Upstream bug: overlapping /state probes each try to close the same timer.
local process = require 'continue.process'
function process.wait_for_ready(timeout_ms, callback)
  local http = require 'continue.utils.http'
  local start = vim.uv.now()
  local timer = vim.uv.new_timer()
  local done = false

  local function finish(err)
    if done then return end
    done = true
    timer:stop()
    timer:close()
    callback(err)
  end

  timer:start(
    100,
    100,
    vim.schedule_wrap(function()
      if done then return end
      local status = process.status()
      if not status.running then return finish 'Server not running' end
      http.get(string.format('http://localhost:%d/state', status.port), function(err, _)
        if not err then
          finish(nil)
        elseif vim.uv.now() - start > timeout_ms then
          finish 'Timeout waiting for server to start'
        end
      end)
    end)
  )
end

local function text_of(content)
  if type(content) == 'string' then return content end
  if type(content) ~= 'table' then return '' end
  local parts = {}
  for _, part in ipairs(content) do
    if type(part) == 'table' and type(part.text) == 'string' then
      table.insert(parts, part.text)
    elseif type(part) == 'table' and type(part.content) == 'string' then
      table.insert(parts, part.content)
    end
  end
  return table.concat(parts, '\n')
end

local function tool_preview(output, max_lines)
  local lines = vim.split(text_of(output), '\n', { plain = true, trimempty = true })
  if #lines > max_lines then
    lines = vim.list_slice(lines, 1, max_lines)
    table.insert(lines, '…')
  end
  return table.concat(lines, '\n')
end

-- cn 1.5.x serves `session.history` ({ message, toolCallStates }) while the plugin
-- renders a flat `chatHistory` ({ role, content, messageType, toolName, ... }).
local function to_chat_history(server_state)
  local history = vim.tbl_get(server_state, 'session', 'history')
  if type(history) ~= 'table' then return nil end

  local out = {}
  for _, item in ipairs(history) do
    local msg = type(item) == 'table' and item.message
    if type(msg) == 'table' and msg.role ~= 'system' and msg.role ~= 'tool' then
      local content = text_of(msg.content)
      if content ~= '' then table.insert(out, { role = msg.role, content = content }) end
      if type(item.toolCallStates) == 'table' then
        for _, call in ipairs(item.toolCallStates) do
          local fn = vim.tbl_get(call, 'toolCall', 'function') or {}
          local args = type(call.parsedArgs) == 'table' and (call.parsedArgs.command or call.parsedArgs.filepath or call.parsedArgs.path)
          if type(args) == 'string' then
            local first, rest = args:match '^([^\n]*)\n(.*)$'
            if first then args = first .. (rest:find '%S' and ' …' or '') end
          end
          local name = (fn.name or 'tool') .. (type(args) == 'string' and (': ' .. args) or '')
          local kind = call.status == 'done' and 'tool-result' or (call.status == 'errored' or call.status == 'error') and 'tool-error' or 'tool-start'
          table.insert(out, {
            role = 'assistant',
            messageType = kind,
            toolName = name,
            toolResult = kind == 'tool-result' and tool_preview(call.output, 8) or nil,
            content = kind == 'tool-error' and tool_preview(call.output, 8) or nil,
          })
        end
      end
    end
  end

  if server_state.isProcessing and #out > 0 then out[#out].isStreaming = true end
  return out
end

-- Upstream bug: JSON null decodes to vim.NIL (truthy), and each poll yields a new
-- table, so the plugin would prompt on null or re-prompt for the same request.
local chat = require 'continue.ui.chat'
local update_from_state = chat.update_from_state
local prompted = {}
local last_render_error
function chat.update_from_state(new_state)
  if new_state.chatHistory == nil then new_state.chatHistory = to_chat_history(new_state) end
  local permission = new_state.pendingPermission
  if type(permission) ~= 'table' or prompted[permission.requestId] then
    new_state.pendingPermission = nil
  else
    prompted[permission.requestId] = true
  end
  -- A render error would otherwise repeat on every poll and block on "Press ENTER".
  local ok, err = pcall(update_from_state, new_state)
  if not ok and err ~= last_render_error then
    last_render_error = err
    vim.notify('continue.nvim render failed: ' .. tostring(err), vim.log.levels.WARN)
  end
end

-- `/clear` only wipes the buffer; a fresh session needs a fresh `cn serve`.
-- process.stop() force-kills whatever job is current 2s after /exit returns, so
-- starting the new server before then would get it killed.
vim.api.nvim_create_user_command('ContinueNew', function()
  vim.cmd 'ContinueStop'
  chat.clear_history()
  prompted = {}
  local function open_when_stopped(tries)
    if process.status().running and tries > 0 then return vim.defer_fn(function() open_when_stopped(tries - 1) end, 250) end
    vim.cmd 'Continue'
  end
  vim.defer_fn(function() open_when_stopped(20) end, 3000)
end, { desc = 'Start a new Continue chat session' })

vim.keymap.set('n', '<leader>cc', '<cmd>Continue<cr>', { desc = '[C]ontinue [c]hat' })
vim.keymap.set('n', '<leader>cn', '<cmd>ContinueNew<cr>', { desc = '[C]ontinue [n]ew chat' })
