return {
  snippets = { preset = "luasnip" },
  cmdline = { enabled = true },
  appearance = { nerd_font_variant = "normal" },
  fuzzy = { implementation = "prefer_rust" },
  
  sources = { 
    default = { "lsp", "snippets", "buffer", "path" },
    providers = {
      buffer = {
        opts = {
          get_bufnrs = function()
            local bufs = {}
            local current_ft = vim.bo.filetype
            
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == current_ft then
                table.insert(bufs, buf)
              end
            end
            
            return bufs
          end
        }
      }
    }
  },

  keymap = {
    preset = "default",
    ["<CR>"] = { "accept", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" }, -- Fixed missing '>' here!
  },

  completion = {
    ghost_text = { enabled = true },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = "single" },
    },
  },
}
