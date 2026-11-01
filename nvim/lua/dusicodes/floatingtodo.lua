local M = {}

local default_opts = {
  target_file = "~/notes/todo.md",
  border = "rounded",
  width = 0.8,
  height = 0.8,
  position = "center",
}

local state = {
  win = nil,
  buf = nil,
  opts = nil,
}

local function expand(path)
  return (path:gsub("^~/", os.getenv("HOME") .. "/"))
end

local function ensure_file(path)
  local dir = path:match("^(.*)/[^/]+$")
  if dir and vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
  if vim.fn.filereadable(path) == 0 then
    local f = io.open(path, "w")
    if f then
      f:write("# Todo\n\n- [ ] \n")
      f:close()
    end
  end
end

local function calculate_position(position)
  local posx, posy = 0.5, 0.5
  if type(position) == "table" then
    posx, posy = position[1] or 0.5, position[2] or 0.5
  elseif position == "center" then
    posx, posy = 0.5, 0.5
  elseif position == "topleft" then
    posx, posy = 0, 0
  elseif position == "topright" then
    posx, posy = 1, 0
  elseif position == "bottomleft" then
    posx, posy = 0, 1
  elseif position == "bottomright" then
    posx, posy = 1, 1
  end
  return posx, posy
end

local function win_config(opts)
  local width = math.min(math.floor(vim.o.columns * opts.width), 100)
  local height = math.floor(vim.o.lines * opts.height)
  local posx, posy = calculate_position(opts.position)
  local col = math.floor((vim.o.columns - width) * posx)
  local row = math.floor((vim.o.lines - height) * posy)
  return {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    border = opts.border,
  }
end

local function toggle_checkbox()
  local line = vim.api.nvim_get_current_line()
  local done = line:gsub("^(%s*%- )%[ %]", "- [x]", 1)
  if done ~= line then
    vim.api.nvim_set_current_line(done)
    return
  end
  local undone = line:gsub("^(%s*%- )%[x%]", "- [ ]", 1)
  vim.api.nvim_set_current_line(undone)
end

local function close()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    if vim.api.nvim_get_option_value("modified", { buf = state.buf }) then
      vim.api.nvim_buf_call(state.buf, function()
        vim.cmd("silent write")
      end)
    end
  end
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
  state.buf = nil
end

local function open()
  local path = expand(state.opts.target_file)
  ensure_file(path)

  local buf = vim.fn.bufadd(path)
  vim.fn.bufload(buf)
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = true

  state.buf = buf
  state.win = vim.api.nvim_open_win(buf, true, win_config(state.opts))

  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true, desc = desc })
  end
  map("q", close, "Close todo")
  map("d", toggle_checkbox, "Toggle checkbox")
  map("<leader>w", function()
    vim.cmd("write")
  end, "Save todo")
end

function M.toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    close()
  else
    open()
  end
end

function M.setup(opts)
  state.opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  vim.api.nvim_create_user_command("Todo", function()
    M.toggle()
  end, { desc = "Toggle floating todo" })
  vim.api.nvim_create_user_command("Td", function()
    M.toggle()
  end, { desc = "Toggle floating todo" })
end

return M
