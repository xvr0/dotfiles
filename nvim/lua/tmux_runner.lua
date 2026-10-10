-- Run the current file / send code cells to the adjacent tmux pane.
local M = {}

local last_cmd = nil

local function send_keys(keys)
  vim.fn.system("tmux send-keys -t .+ " .. vim.fn.shellescape(keys) .. " C-m")
end

-- Make sure there is a second pane to send to; optionally boot a REPL in it.
local function ensure_pane(repl_start_cmd)
  if vim.env.TMUX == nil then
    vim.notify("Not inside a tmux session!", vim.log.levels.ERROR)
    return false
  end

  local panes = tonumber(vim.fn.system "tmux display-message -p '#{window_panes}'")
  if panes == 1 then
    -- -d keeps focus on Neovim so "-t .+" targets the new pane
    vim.fn.system "tmux split-window -v -d"
    if repl_start_cmd then
      send_keys(repl_start_cmd)
      vim.cmd "sleep 600m" -- give the REPL a moment to initialize
    end
  end
  return true
end

function M.run_file()
  vim.cmd "w"
  local ft = vim.bo.filetype
  local filename = vim.fn.shellescape(vim.fn.expand "%")
  local full_path = vim.fn.expand "%:p"
  local base_name = vim.fn.expand "%:r"
  local cmd, repl_start

  if ft == "python" then
    cmd = "python3 " .. filename
  elseif ft == "sh" or ft == "bash" then
    cmd = "bash " .. filename
  elseif ft == "c" then
    cmd = "gcc " .. filename .. " -o " .. base_name .. " -lfftw3 -lm && ./" .. base_name
  elseif ft == "cpp" then
    if vim.fn.filereadable "CMakeLists.txt" == 1 then
      cmd = "cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && cmake --build build && echo ---Output--- && $(find build -maxdepth 1 -type f -executable | head -n 1)"
    else
      cmd = "g++ $([ -f compile_flags.txt ] && cat compile_flags.txt ) " .. filename .. " -o " .. base_name .. " && ./" .. base_name
    end
  elseif ft == "julia" then
    cmd = 'include("' .. full_path .. '")'
    repl_start = 'julia -i "' .. full_path .. '"'
  elseif ft == "matlab" then
    cmd = "run('" .. full_path .. "')"
    repl_start = 'matlab -nodesktop -nosplash -r "' .. cmd .. '"'
  end

  if not cmd then
    vim.notify("No tmux run command configured for filetype: " .. ft, vim.log.levels.WARN)
    return
  end
  if not ensure_pane(repl_start) then return end
  last_cmd = cmd
  send_keys(cmd)
end

function M.repeat_last()
  if not last_cmd then
    vim.notify("No command to repeat. Run <leader>x first.", vim.log.levels.WARN)
    return
  end
  if not ensure_pane() then return end
  send_keys(last_cmd)
end

-- Send the code cell under the cursor (delimited by "# %%", "%%" or ```) to the REPL
function M.send_cell()
  local ft = vim.bo.filetype
  -- vim regex for search(), lua pattern for find()
  local pattern_vim, pattern_lua = "^# %%", "^# %%"
  if ft == "typst" then
    pattern_vim, pattern_lua = "```", "```"
  elseif ft == "matlab" then
    pattern_vim, pattern_lua = "^%%", "^%%%%"
  end

  local last_line = vim.api.nvim_buf_line_count(0)
  local start_line, end_line
  if vim.api.nvim_get_current_line():find(pattern_lua) then
    -- cursor is on a cell marker: run the cell below it
    start_line = vim.api.nvim_win_get_cursor(0)[1] + 1
  else
    start_line = vim.fn.search(pattern_vim, "bnW")
    start_line = (start_line == 0) and 1 or (start_line + 1)
  end
  end_line = vim.fn.search(pattern_vim, "nW")
  end_line = (end_line == 0) and last_line or (end_line - 1)

  if start_line > end_line then return end
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, "\n") .. "\n"

  if not ensure_pane() then return end

  -- load-buffer + paste-buffer is far more robust than send-keys for multiline text
  local job = vim.fn.jobstart({ "tmux", "load-buffer", "-" }, {
    on_exit = function()
      vim.fn.system "tmux paste-buffer -t .+ -p"
      vim.fn.system "tmux send-keys -t .+ C-m"
    end,
  })
  vim.fn.chansend(job, text)
  vim.fn.chanclose(job, "stdin")

  -- jump to the next cell
  local next_cell = vim.fn.search(pattern_vim, "W")
  if next_cell > 0 then vim.api.nvim_win_set_cursor(0, { next_cell, 0 }) end
end

return M
