-- require("nvim-treesitter.configs").setup {
--   ensure_installed = { "python","lua", "vim", "vimdoc", "html", "css", "typescript", "javascript", "latex" },
--
--   highlight = {
--     enable = true,
--     use_languagetree = true,
--   },
--   indent = { enable = true },
-- }
-- ~/.config/nvim/lua/plugins/configs/treesitter.lua

-- 1. Installing parsers is now handled by the install() function, 
-- NOT the "ensure_installed" table.
require("nvim-treesitter").install({
  "c", "lua", "vim", "vimdoc", "query", "latex", "markdown", -- Add your specific languages here
})

-- 2. Syntax highlighting is now handled natively by Neovim's core.
-- You no longer use `highlight = { enable = true }`. 
-- Instead, tell Neovim to attach Tree-sitter whenever you open a file:


-- 3. (Optional) If you want Tree-sitter code folding, add this:
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
})

-- ~/.config/nvim/lua/plugins/configs/treesitter.lua

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    -- Add this IF statement to skip LaTeX files:
    local lang = args.match
    if lang == "tex" or lang == "latex" then
      return
    end
    
    -- Start Treesitter for everything else
    pcall(vim.treesitter.start)
  end,
})
