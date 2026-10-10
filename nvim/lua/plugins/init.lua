return {
  { "nvim-lua/plenary.nvim", lazy = true },

  -------------------------------
  -- UI
  -------------------------------
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require "plugins.configs.kanagawa"
    end,
  },
  { "nvim-tree/nvim-web-devicons", opts = {} },
  { "echasnovski/mini.statusline", opts = {} },
  { "akinsho/bufferline.nvim", opts = require "plugins.configs.bufferline" },
  { "lewis6991/gitsigns.nvim", opts = {} },
  {
    "nvimdev/indentmini.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      image = {
        enabled = true,
        doc = { enabled = false }, -- no automatic inline rendering in typst/markdown/latex
      },
    },
  },

  -------------------------------
  -- Navigation
  -------------------------------
  "christoomey/vim-tmux-navigator", -- <C-h/j/k/l> across nvim splits and tmux panes
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = require "plugins.configs.telescope",
  },
  { "rbgrouleff/bclose.vim" },

  -------------------------------
  -- Treesitter / LSP / formatting
  -------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require "plugins.configs.treesitter"
    end,
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall" },
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = require "plugins.configs.conform",
  },
  {
    -- LSP for code embedded in typst files
    "jmbuhr/otter.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "typst",
        callback = function()
          require("otter").activate({ "python", "julia", "matlab" }, true, true, nil)
        end,
      })
    end,
  },

  -------------------------------
  -- Completion & snippets (loaded on InsertEnter)
  -------------------------------
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "L3MON4D3/LuaSnip",
        config = function()
          local snips = vim.fn.stdpath "config" .. "/snips"
          require("luasnip.loaders.from_vscode").lazy_load { exclude = { "vhdl" } }
          require("luasnip.loaders.from_vscode").lazy_load { paths = { snips } }
          require("luasnip.loaders.from_lua").lazy_load { paths = snips }
        end,
      },
      { "windwp/nvim-autopairs", opts = {} },
    },
    -- function so the config file is only read when blink actually loads
    opts = function()
      return require "plugins.configs.blink"
    end,
  },

  -------------------------------
  -- LaTeX
  -------------------------------
  {
    "lervag/vimtex",
    lazy = false, -- vimtex must not be lazy loaded
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_latexmk_engines = { _ = "-lualatex" }
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        hooks = {},
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-shell-escape",
        },
      }
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_spell_enabled = 1
      vim.g.tex_conceal = "abdmg"
      vim.opt.conceallevel = 2
    end,
  },
  {
    "let-def/texpresso.vim",
    ft = { "tex", "latex" },
    keys = {
      { "<leader>tx", "<cmd>TeXpresso %<CR>", desc = "Launch Texpresso" },
    },
  },
}
