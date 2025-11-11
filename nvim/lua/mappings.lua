local map = vim.keymap.set
map("n","<leader>nn","<cmd> bn <CR>")
map("n","<leader>pp","<cmd> bp <CR>")
map("n","<leader>dd","<cmd> bd <CR>")
map("n","<leader>bl","<cmd> buffers <CR>")


-- Leader key for window commands
-- local wincmds = { 
--     w = "w", c = "c", n = "n", s = "s", v = "v", o = "o",
--     ["="] = "=", h = "h", j = "j", k = "k", l = "l"
-- }
--
-- for key, cmd in pairs(wincmds) do
--     vim.keymap.set(
--         "n",                        -- Normal mode
--         "<leader>w" .. key,         -- e.g., <leader>wh
--         "<cmd>wincmd " .. cmd .. "<CR>",
--         { noremap = true, silent = true }
--     )
-- end

map("n","<leader><leader>","<cmd> w  <CR>")
map("n","zz","ZZ")

map("n","<leader>nh","<cmd> noh <CR>")

map("n","<leader>u","<cmd> undo <CR>")
map("n","<leader>r","<cmd> redo <CR>")


map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

local function switch_terminal()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_set_current_buf(buf)
      return
    end
  end

  vim.cmd("term")  -- You can use :vsplit if you prefer vertical split
end

-- Map <leader>t to toggle_terminal
vim.keymap.set('n', '<leader>t', switch_terminal, { noremap = true, silent = true })

map("n","<leader>bt","<cmd>bd!<CR>")

local function RunFile()
    -- Ensure the current file is saved before running
    vim.cmd('w')

    -- Get the current filetype (e.bo.filetype is buffer-local option)
    local filetype = vim.bo.filetype
    
    -- Get the current file path, escaped for safe shell execution
    local filename = vim.fn.shellescape(vim.fn.expand('%'))

    -- The command to run in the terminal
    local command = nil

    if filetype == 'python' then
        -- Execute Python script
        command = 'terminal python3 ' .. filename
    elseif filetype== 'tex' then
        command= 'TeXpresso %'
    elseif filetype == 'sh' or filetype == 'bash' then
        -- Execute shell script
        command = 'terminal ' .. filename
    elseif filetype == 'c' then
        -- Compile and run C code (Requires gcc and assumes you want to run immediately)
        local base_name = vim.fn.expand('%:r') -- filename without extension
        -- Use && to chain the commands: compile, then run the executable
        command = 'terminal gcc ' .. filename .. ' -o ' .. base_name .. ' && ./' .. base_name
    end

    if command then
        vim.cmd(command)
    else
        vim.notify('No run command defined for filetype: ' .. filetype, vim.log.levels.WARN)
    end
end 
-- Create a Normal mode mapping (e.g., F5) to run the file
vim.keymap.set('n', '<leader>x', RunFile, {
    desc = 'Run/Execute Current File (Filetype-Aware)',
    silent = true
})


map("n", "<leader>ht", "<cmd> terminal htop <CR>")
-- general mappings
map("n", "<C-s>", "<cmd> w <CR>")
map("i", "jk", "<ESC>")
 map("n", "<C-c>", "<cmd> %y+ <CR>") -- copy whole filecontent


vim.g.ranger_map_keys = 0
map("n", "<leader>fr", "<cmd> Ranger <CR>")
-- telescope
map("n", "<leader>ff", "<cmd> Telescope find_files <CR>")
map("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>")
map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>")
map("n", "<leader>gt", "<cmd> Telescope git_status <CR>")

-- bufferline, cycle buffers
map("n", "<Tab>", "<cmd> BufferLineCycleNext <CR>")
map("n", "<S-Tab>", "<cmd> BufferLineCyclePrev <CR>")
map("n", "<C-q>", "<cmd> bd <CR>")

-- comment.nvim
map("n", "<leader>/", "gcc", { remap = true })
map("v", "<leader>/", "gc", { remap = true })

-- format
map("n", "<leader>fm", function()
  require("conform").format()
end)
