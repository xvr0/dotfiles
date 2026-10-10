local map = vim.keymap.set
vim.g.mapleader = " "

vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = 'Telescope buffers' })

-- Global diagnostic keymaps
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
-------------------------------
-- BUFFER & NORMAL MAPS
-------------------------------
map("n", "<Tab>", "<cmd>bnext<CR>")
map("n", "<C-Tab>", "<cmd>bprev<CR>")
map("n", "<leader><leader>", "<cmd> w  <CR>")
map("n", "zz", "ZZ")
map("n", "<leader>nh", "<cmd> noh <CR>")
map("n", "<leader>u", "<cmd> undo <CR>")
map("n", "<leader>r", "<cmd> redo <CR>")
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<C-s>", "<cmd> w <CR>")
map("n", "<C-c>", "<cmd> %y+ <CR>") -- copy whole filecontent

-------------------------------
-- TERMINAL MODE MAPS
-------------------------------
map("t", "<C-n>", "<C-\\><C-n>", { desc = "Enter normal mode in terminal" })
map("t", "<S-Tab>", "<C-\\><C-n><cmd> BufferLineCyclePrev <CR>")
map("t", "<C-q>", "<C-\\><C-n><cmd> bd <CR>")

map("t", "<C-h>", "<C-\\><C-n><C-w>h")
map("t", "<C-j>", "<C-\\><C-n><C-w>j")
map("t", "<C-k>", "<C-\\><C-n><C-w>k")
map("t", "<C-l>", "<C-\\><C-n><C-w>l")


local function OpenPDFUnderCursor()
    local filepath = vim.fn.expand('<cfile>')
    
    -- Strip any surrounding quotes that <cfile> might accidentally capture
    filepath = filepath:gsub('^["\']+', ''):gsub('["\']+$', '')

    if not filepath:match('%.pdf$') then
        print("Not a PDF. Cursor is on: " .. filepath)
        return
    end

    -- Convert to absolute path to guarantee filereadable finds it
    local full_path = vim.fn.fnamemodify(filepath, ":p")

    if vim.fn.filereadable(full_path) == 1 then
        local job_id = vim.fn.jobstart({ "zathura", full_path }, { detach = true })
        if job_id <= 0 then
            print("Error: Failed to launch zathura. Is it installed and on your PATH?")
        else
            print("Success! Opened: " .. full_path)
        end
    else
        print("File not found on disk: " .. full_path)
    end
end

vim.keymap.set("n", "<leader>pd", OpenPDFUnderCursor, { desc = "Open PDF under cursor" })
-------------------------------
-- TMUX RUNNER LOGIC
-------------------------------
_G.last_tmux_cmd = nil

-- Utility to ensure we have an adjacent tmux pane
-- Utility to ensure we have an adjacent tmux pane
local function ensure_tmux_pane(repl_start_cmd)
  if vim.env.TMUX == nil then
    vim.notify("Not inside a tmux session!", vim.log.levels.ERROR)
    return false
  end
  
  -- Count panes in the current window
  local panes = tonumber(vim.fn.system("tmux display-message -p '#{window_panes}'"))
  if panes == 1 then
    -- -v creates a top/bottom split
    -- -d keeps focus on Neovim so "-t .+" targets the new pane correctly
    vim.fn.system("tmux split-window -v -d")
    if repl_start_cmd then
      -- If starting a REPL (like Julia or Matlab), send the boot command first
      vim.fn.system("tmux send-keys -t .+ " .. vim.fn.shellescape(repl_start_cmd) .. " C-m")
      vim.cmd("sleep 600m") -- Give the REPL a moment to initialize
    end
  end
  return true
end
local function RunFileTmux()
  vim.cmd('w')
  local filetype = vim.bo.filetype
  local filename = vim.fn.shellescape(vim.fn.expand('%'))
  local full_path = vim.fn.expand('%:p')
  local cmd = nil
  local repl_start = nil

  -- Matches the exact filetype parsing from your original mappings.lua
  if filetype == 'python' then
    cmd = 'python3 ' .. filename
  elseif filetype == 'c' then
    local base_name = vim.fn.expand('%:r')
    cmd = 'gcc ' .. filename .. ' -o ' .. base_name .. ' -lfftw3 -lm && ./' .. base_name
  elseif filetype == 'sh' or filetype == 'bash' then
    cmd = 'bash ' .. filename
  elseif filetype == 'julia' then
    cmd = 'include("' .. full_path .. '")'
    repl_start = 'julia -i "' .. full_path .. '"'
  elseif filetype == 'matlab' then
    cmd = "run('" .. full_path .. "')"
    repl_start = 'matlab -nodesktop -nosplash -r "' .. cmd .. '"'
  elseif filetype == 'cpp' then
    if vim.fn.filereadable('CMakeLists.txt') == 1 then
      cmd = 'cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && cmake --build build && echo ---Output--- && $(find build -maxdepth 1 -type f -executable | head -n 1)'
    else
      local base_name = vim.fn.expand('%:r')
      cmd = 'g++ $([ -f compile_flags.txt ] && cat compile_flags.txt ) ' .. filename .. ' -o ' .. base_name .. ' && ./' .. base_name
    end
  end

  if cmd then
    if not ensure_tmux_pane(repl_start) then return end
    _G.last_tmux_cmd = cmd
    -- Send the actual execution command to the adjacent pane
    vim.fn.system("tmux send-keys -t .+ " .. vim.fn.shellescape(cmd) .. " C-m")
  else
    vim.notify("No tmux run command configured for filetype: " .. filetype, vim.log.levels.WARN)
  end
end

vim.keymap.set('n', '<leader>x', RunFileTmux, { desc = 'Run File in Tmux', silent = true })

local function RepeatLastTmuxCmd()
  if not _G.last_tmux_cmd then
    vim.notify("No command to repeat. Run <leader>x first.", vim.log.levels.WARN)
    return
  end
  if not ensure_tmux_pane() then return end
  vim.fn.system("tmux send-keys -t .+ " .. vim.fn.shellescape(_G.last_tmux_cmd) .. " C-m")
end

vim.keymap.set("n", "<leader>y", RepeatLastTmuxCmd, { desc = "Repeat Last Shell Command", silent = true })

-------------------------------
-- TMUX NATIVE REPL EVALUATION
-------------------------------
local function SendCellToTmuxREPL()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local ft = vim.bo.filetype
  
  -- Retains your original pattern matching for Python, Typst, and Matlab
  local pattern_vim = '^# %%'
  local pattern_lua = '^# %%'
  if ft == 'typst' then
    pattern_vim = '```'
    pattern_lua = '```'
  elseif ft == 'matlab' then
    pattern_vim = '^%%'
    pattern_lua = '^%%%%'
  end

  local start_line = vim.fn.search(pattern_vim, 'bnW')
  start_line = (start_line == 0) and 1 or (start_line + 1)
  
  local end_line = vim.fn.search(pattern_vim, 'nW')
  end_line = (end_line == 0) and vim.api.nvim_buf_line_count(0) or (end_line - 1)

  if vim.api.nvim_get_current_line():find(pattern_lua) then
    start_line = cursor[1] + 1
    end_line = vim.fn.search(pattern_vim, 'nW')
    end_line = (end_line == 0) and vim.api.nvim_buf_line_count(0) or (end_line - 1)
  end

  if start_line > end_line then return end
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  
  -- Format multiline code to send to tmux
  local text = table.concat(lines, "\n") .. "\n"

  if not ensure_tmux_pane() then return end

  -- Sending multiline strings directly via send-keys is error-prone due to quoting.
  -- Loading it into the tmux paste buffer and pasting it is incredibly robust.
  local job = vim.fn.jobstart({"tmux", "load-buffer", "-"}, {
    on_exit = function()
      vim.fn.system("tmux paste-buffer -t .+ -p")
      vim.fn.system("tmux send-keys -t .+ C-m")
    end
  })
  vim.fn.chansend(job, text)
  vim.fn.chanclose(job, "stdin")

  -- Jump to next cell, matching your original workflow
  local next_cell = vim.fn.search(pattern_vim, 'W')
  if next_cell > 0 then vim.api.nvim_win_set_cursor(0, { next_cell, 0 }) end
end

vim.keymap.set("n", "<leader>rr", SendCellToTmuxREPL, { desc = "Evaluate Cell Only in Tmux", silent = true })

