local M = {}
local history_buf, input_buf
local history_win, input_win
local ns_id = vim.api.nvim_create_namespace('chat_ns')

function M.setup(user_opts)
  config = vim.tbl_deep_extend('force', config, user_opts or {})
end

local function make_http_request(url, body)
  local socket = require('socket.http')
  local ltn12 = require('ltn12')
  local response = {}
  local _, status = socket.request({
    url = url,
    method = 'POST',
    headers = {
      ['Content-Type'] = 'application/json'
    },
    source = ltn12.source.string(body),
    sink = ltn12.sink.table(response)
  })
  return {
    status = status,
    body = table.concat(response)
  }
end

function M.open_chat()
  M.close_chat()
  history_buf = vim.api.nvim_create_buf(false, true)
  input_buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_name(history_buf, 'Chat_History_'..os.time())
  vim.api.nvim_buf_set_option(history_buf, 'filetype', 'markdown')
  vim.api.nvim_buf_set_option(history_buf, 'modifiable', false)

  vim.api.nvim_buf_set_name(input_buf, 'Chat_Input_'..os.time())
  vim.api.nvim_buf_set_option(input_buf, 'filetype', 'markdown')
  vim.api.nvim_buf_set_lines(input_buf, 0, -1, false, {'Type your message here...'})

  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width/2)
  local height = math.floor(ui.height/2)
  local input_height = 5
  local total_height = height
  local history_win_opts = {
    relative = 'editor',
    width = width,
    height = height - input_height,
    col = math.floor((ui.width - width)/2),
    row = math.floor((ui.height - total_height) / 3),
    style = 'minimal',
    border = 'single'
  }

  history_win = vim.api.nvim_open_win(history_buf, true, history_win_opts)
  input_win = vim.api.nvim_open_win(input_buf, true, {
    relative = 'editor',
    width = width,
    height = input_height,
    col = math.floor((ui.width - width) / 2),
    row = math.floor((ui.height - total_height) / 3) + (total_height - input_height),
    style = 'minimal',
    border = 'single'
  })
  vim.api.nvim_set_keymap('n', '<C-w>h', '', {
    callback = function()
      if vim.api.nvim_win_is_valid(history_win) then
        vim.api.nvim_set_current_win(history_win)
      end
    end,
    noremap = true,
    silent = true
  })

  vim.api.nvim_set_keymap('n', '<C-w>l', '', {
    callback = function()
      if vim.api.nvim_win_is_valid(input_win) then
        vim.api.nvim_set_current_win(input_win)
      end
    end,
    noremap = true,
    silent = true
  })

  vim.api.nvim_win_set_option(history_win, 'winfixwidth', true)
  vim.api.nvim_win_set_option(history_win, 'winfixheight', true)
  vim.api.nvim_win_set_option(input_win, 'winfixwidth', true)
  vim.api.nvim_win_set_option(input_win, 'winfixheight', true)
  vim.keymap.set('n', '<CR>', M.send_message, {buffer = input_buf})
  vim.keymap.set('i', '<CR>', function()
    if vim.fn.mode() == 'i' then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', false)
    else
      M.send_message()
    end
  end, {buffer = input_buf})

  vim.api.nvim_create_autocmd('BufWipeout', {
    buffer = input_buf,
    callback = function() M.close_chat() end
  })
end

function M.send_message()
  if not input_buf or not vim.api.nvim_buf_is_valid(input_buf) then return end
  if not history_buf or not vim.api.nvim_buf_is_valid(history_buf) then return end

  local lines = vim.api.nvim_buf_get_lines(input_buf, 0, -1, false)
  local message = table.concat(vim.tbl_filter(function(line)
    return line:gsub("%s", "") ~= ""
  end, lines), "\n")

  if message ~= "" then
    vim.api.nvim_buf_set_option(history_buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(history_buf, -1, -1, false,
      vim.split("You:\n"..message.."\n", "\n")
    )
    vim.api.nvim_buf_set_option(history_buf, 'modifiable', false)

    vim.api.nvim_buf_set_lines(input_buf, 0, -1, false, {""})
    vim.api.nvim_win_set_cursor(input_win, {1, 0})

    M._get_bot_response(message)
  end
end

function M._get_bot_response(message)
  if not history_buf or not vim.api.nvim_buf_is_valid(history_buf) then return end

  vim.api.nvim_buf_set_option(history_buf, 'modifiable', true)
  local thinking_line = vim.api.nvim_buf_line_count(history_buf)
  vim.api.nvim_buf_set_lines(history_buf, -1, -1, false, {"Bot: Thinking..."})
  vim.api.nvim_buf_set_option(history_buf, 'modifiable', false)

  local request_body = vim.json.encode({
    model = config.model_name,
    messages = {
      {role = "user", content = message}
    },
    stream = false
  })

  vim.loop.new_work(
    function()
      return make_http_request(config.api_endpoint, request_body)
    end,
    function(response)
      vim.schedule(function()
        vim.api.nvim_buf_set_option(history_buf, 'modifiable', true)
        vim.api.nvim_buf_set_lines(history_buf, thinking_line, thinking_line + 1, false, {})

        if response.status >= 200 and response.status < 300 then
          local ok, data = pcall(vim.json.decode, response.body)
          if ok then
            local reply = data.response or
                         (data.choices and data.choices[1].message.content) or
                         data.content or
                         "[Unknown response format]"
            vim.api.nvim_buf_set_lines(history_buf, -1, -1, false, {
              "Bot:",
              reply,
              ""
            })
          else
            vim.api.nvim_buf_set_lines(history_buf, -1, -1, false, {
              "Bot: [Malformed JSON response]",
              ""
            })
          end
        else
          local error_msg = response.body:match('"error":"([^"]+)"') or
                          response.body:gsub("\n", " "):sub(1, 80)
          vim.api.nvim_buf_set_lines(history_buf, -1, -1, false, {
            "Bot: [Error "..response.status.."]",
            error_msg,
            ""
          })
        end

        vim.api.nvim_buf_set_option(history_buf, 'modifiable', false)
        vim.api.nvim_win_set_cursor(history_win, {vim.api.nvim_buf_line_count(history_buf), 0})
      end)
    end
  )
end

function M.close_chat()
  if history_win and vim.api.nvim_win_is_valid(history_win) then
    vim.api.nvim_win_close(history_win, {force = true})
    history_win = nil
  end

  if input_win and vim.api.nvim_win_is_valid(input_win) then
    vim.api.nvim_win_close(input_win, {force = true})
    input_win = nil
  end
  history_buf, input_buf = nil, nil
end

return M
