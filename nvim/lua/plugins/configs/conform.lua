return {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    python = { "black" },
    matlab = { "mh_style" },
    vhdl = { "vsg" },
    typst = { "injected" },
  },
  formatters = {
    vsg = {
      prepend_args = { "-c", vim.fn.stdpath "config" .. "/.vsg.yaml" },
    },
  },
}
