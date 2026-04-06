return {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
vhdl = { "vsg" },
  },
formatters = {
vsg = {
      prepend_args = { "-c", vim.fn.expand("~/.config/nvim/.vsg.yaml") },
    },
  },
}
