local map = vim.keymap.set
local runner = require "tmux_runner"

-------------------------------
-- GENERAL
-------------------------------
map("n", "<leader><leader>", "<cmd>w<CR>")
map("n", "<C-s>", "<cmd>w<CR>")
map("n", "zz", "ZZ")
map("n", "<leader>nh", "<cmd>noh<CR>")
map("n", "<leader>u", "<cmd>undo<CR>")
map("n", "<leader>r", "<cmd>redo<CR>")
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word under cursor" })

-- move selected lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- buffers
map("n", "<Tab>", "<cmd>bnext<CR>")
map("n", "<C-Tab>", "<cmd>bprev<CR>")

-------------------------------
-- TELESCOPE
-------------------------------
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Telescope find files" })
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Telescope live grep" })
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Telescope buffers" })

-------------------------------
-- DIAGNOSTICS (LSP maps live in plugins/configs/lspconfig.lua)
-------------------------------
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-------------------------------
-- TERMINAL MODE
-------------------------------
map("t", "<C-n>", "<C-\\><C-n>", { desc = "Enter normal mode in terminal" })
map("t", "<S-Tab>", "<C-\\><C-n><cmd>BufferLineCyclePrev<CR>")
map("t", "<C-q>", "<C-\\><C-n><cmd>bd<CR>")
map("t", "<C-h>", "<C-\\><C-n><C-w>h")
map("t", "<C-j>", "<C-\\><C-n><C-w>j")
map("t", "<C-k>", "<C-\\><C-n><C-w>k")
map("t", "<C-l>", "<C-\\><C-n><C-w>l")

-------------------------------
-- TMUX RUNNER / REPL
-------------------------------
map("n", "<leader>x", runner.run_file, { desc = "Run file in tmux", silent = true })
map("n", "<leader>y", runner.repeat_last, { desc = "Repeat last tmux command", silent = true })
map("n", "<leader>rr", runner.send_cell, { desc = "Evaluate cell in tmux REPL", silent = true })

-------------------------------
-- MISC
-------------------------------
local function open_pdf_under_cursor()
  -- strip surrounding quotes that <cfile> might capture
  local filepath = vim.fn.expand("<cfile>"):gsub("^[\"']+", ""):gsub("[\"']+$", "")

  if not filepath:match "%.pdf$" then
    print("Not a PDF. Cursor is on: " .. filepath)
    return
  end

  local full_path = vim.fn.fnamemodify(filepath, ":p")
  if vim.fn.filereadable(full_path) ~= 1 then
    print("File not found on disk: " .. full_path)
    return
  end

  if vim.fn.jobstart({ "zathura", full_path }, { detach = true }) <= 0 then
    print "Error: Failed to launch zathura. Is it installed and on your PATH?"
  else
    print("Opened: " .. full_path)
  end
end

map("n", "<leader>pd", open_pdf_under_cursor, { desc = "Open PDF under cursor" })
