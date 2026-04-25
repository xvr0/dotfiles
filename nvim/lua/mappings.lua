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

  vim.cmd("term")  
end

vim.keymap.set('n', '<leader>t', switch_terminal, { noremap = true, silent = true })

map("n","<leader>bt","<cmd>bd!<CR>")

local function RunFile()
    vim.cmd('w')

    local filetype = vim.bo.filetype
    
    local filename = vim.fn.shellescape(vim.fn.expand('%'))

    local command = nil

    if filetype == 'python' then
        command = 'terminal python3 ' .. filename
    elseif filetype == 'tex' then
        
        command = 'VimtexCompile'
    elseif filetype == 'sh' or filetype == 'bash' then
        command = 'terminal ' .. filename
    elseif filetype == 'c' then
        local base_name = vim.fn.expand('%:r') 
        command = 'terminal gcc ' .. filename .. ' -o ' .. base_name .. ' && ./' .. base_name
    elseif filetype == 'matlab' then
        command = 'terminal matlab -batch "run(' .. filename .. ')"'
        -- command = 'terminal matlab -nodesktop -nosplash -r "run(' .. filename .. ')"'
    end

    if command then
        vim.cmd(command)
    else
        vim.notify('No run command defined for filetype: ' .. filetype, vim.log.levels.WARN)
    end
end 

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

-- spell check
local function ToggleSpell(lang)
  if vim.o.spell and vim.o.spelllang == lang then
    vim.o.spell = false
  else
    vim.o.spell = true
    vim.o.spelllang = lang
  end
end

map("n", "<leader>spe", function() ToggleSpell("en_us") end)
map("n", "<leader>spg", function() ToggleSpell("de_de") end)

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

-------------------------------
--  EDIT SNIPPETS MAP
-------------------------------
local function EditSnippets()
    local ft = vim.bo.filetype
    
    if ft == "" then
        vim.notify("No filetype detected for current buffer.", vim.log.levels.WARN)
        return
    end
    local snip_path = vim.fn.expand("~/.config/nvim/snips/" .. ft .. ".lua")
    vim.cmd("edit " .. snip_path)
end

map("n", "<leader>sn", EditSnippets, { 
    desc = "Edit Snippets for Current Filetype", 
    silent = true 
})

vim.keymap.set('n', '<leader>r', function()
    local filename = vim.fn.expand('%:p') -- Get absolute path of current file
    
    -- Find the first open terminal buffer
    local term_chan = nil
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == 'terminal' then
            term_chan = vim.bo[buf].channel
            break
        end
    end

    if term_chan then
        -- Save the file first
        vim.cmd('write')
        -- Send the run command to the MATLAB terminal
        -- Note: We send \r (Enter) at the end to execute it
        vim.fn.chansend(term_chan, "run('" .. filename .. "')\r")
        print("Sent to MATLAB REPL")
    else
        print("No terminal found! Open a terminal and run 'matlab -nodesktop -nosplash' first.")
    end
end, { desc = "Run MATLAB script in existing terminal" })


vim.keymap.set(
    "n", 
    "<leader><CR>", 
    "?^# %%<CR>jV/^# %%<CR>k:<C-u>MoltenEvaluateVisual<CR>:noh<CR>", 
    { desc = "Evaluate Cell", silent = true }
)

vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>",
    { silent = true, desc = "Initialize the plugin" })
vim.keymap.set("n", "<leader>e", ":MoltenEvaluateOperator<CR>",
    { silent = true, desc = "run operator selection" })
vim.keymap.set("n", "<leader>rl", ":MoltenEvaluateLine<CR>",
    { silent = true, desc = "evaluate line" })
vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>",
    { silent = true, desc = "re-evaluate cell" })
vim.keymap.set("v", "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
    { silent = true, desc = "evaluate visual selection" })

vim.keymap.set("n", "<leader>rd", ":MoltenDelete<CR>",
    { silent = true, desc = "molten delete cell" })
vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<CR>",
    { silent = true, desc = "hide output" })
vim.keymap.set("n", "<leader>os", ":noautocmd MoltenEnterOutput<CR>",
    { silent = true, desc = "show/enter output" })
