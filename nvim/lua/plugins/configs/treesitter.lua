require("nvim-treesitter").install {
  "c", "lua", "vim", "vimdoc", "query", "latex", "markdown",
}

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

    -- vimtex handles highlighting for LaTeX
    if args.match == "tex" or args.match == "latex" then return end
    pcall(vim.treesitter.start)
  end,
})
