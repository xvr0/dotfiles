local o = vim.o

vim.g.mapleader = " "

-- UI
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.laststatus = 3 -- global statusline
o.showmode = false
o.termguicolors = true
o.background = "dark"
o.splitbelow = true
o.splitright = true
vim.opt.fillchars = { eob = " " }

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true

-- Folding (overridden by treesitter folding for buffers with a filetype)
o.foldmethod = "indent"
o.foldlevel = 99
o.foldenable = true

-- Search
o.ignorecase = true
o.smartcase = true

-- Behaviour
o.mouse = "a"
o.clipboard = "unnamedplus"
o.timeoutlen = 400
o.undofile = true
o.backupcopy = "yes"

-- Filetypes
vim.filetype.add {
  extension = {
    m = "matlab", -- not Objective-C
    tex = "tex",
    gp = "gnuplot",
    plt = "gnuplot",
    gnuplot = "gnuplot",
  },
}

-- add binaries installed by mason.nvim to path
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath "data" .. "/mason/bin"

vim.api.nvim_set_hl(0, "IndentLine", { link = "Comment" })
