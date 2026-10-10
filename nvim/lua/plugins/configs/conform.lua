return {
formatters_by_ft = {
  lua = { "stylua" },
  javascript = { "prettier" },
  vhdl = { "vsg" },
  python = { "black" }, -- Using black for Python formatting[cite: 1]
  matlab = { "mh_style" },
typst = { "injected" },
},
formatters = {
  vsg = {
    prepend_args = { "-c", vim.fn.expand("~/.config/nvim/.vsg.yaml") },
  },
  -- Optional: Add custom arguments for mh_style if needed
  -- mh_style = {
  --   prepend_args = { "--process-slx" },
  -- },
},
}
