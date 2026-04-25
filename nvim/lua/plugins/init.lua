return {
  { "nvim-lua/plenary.nvim", lazy=true },
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
{
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-shell-escape",
      }
    }
    vim.g.vimtex_quickfix_mode=0
    vim.g.vimtex_spell_enabled = 1
    vim.g.concceallevel=2
    vim.g.tex_conceal="abdmg"
  end
},
  { "nvim-tree/nvim-web-devicons", opts = {} },
  { "echasnovski/mini.statusline", opts = {} },
  { "lewis6991/gitsigns.nvim", opts = {} },

  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = function()
    require "plugins.configs.gruvbox"
  end
},
{
  "jbyuki/nabla.nvim",
  keys = {
    { "<leader>p", function() require("nabla").popup() end, desc = "Preview math popup" },
    -- Add this new line:
    { "<leader>n", function() require("nabla").toggle_virt() end, desc = "Toggle inline math" },
  },
},
{
  "let-def/texpresso.vim",
  ft = { "tex", "latex" }, -- Only load this plugin for LaTeX files
  keys = {
    -- Let's create a custom shortcut to launch it
    { "<leader>tx", "<cmd>TeXpresso %<CR>", desc = "Launch Texpresso" },
  },
},
  {
    "nvim-treesitter/nvim-treesitter",
branch = "main",
    build = ":TSUpdate",
    config = function()
      require "plugins.configs.treesitter"
    end,
  },

  {  'rbgrouleff/bclose.vim'},
  {
    "akinsho/bufferline.nvim",
    opts = require "plugins.configs.bufferline",
  },

  -- we use blink plugin only when in insert mode
  -- so lets lazyload it at InsertEnter event
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",

      -- snippets engine
{
"L3MON4D3/LuaSnip",
  config = function()
    -- 1. Load global VSCode snippets, BUT explicitly exclude VHDL
    require("luasnip.loaders.from_vscode").lazy_load({
      exclude = { "vhdl" }
    })
    
    -- 2. Load custom VSCode JSON snippets from your snips directory (if any)
    require("luasnip.loaders.from_vscode").lazy_load({ 
      paths = { vim.fn.stdpath("config") .. "/snips" } 
    })
    
    require("luasnip.loaders.from_lua").lazy_load({
      paths = vim.fn.stdpath("config") .. "/snips"
    })
  end,
},

      -- autopairs , autocompletes ()[] etc
      { "windwp/nvim-autopairs", opts = {} },
    },
    -- made opts a function cuz cmp config calls cmp module
    -- and we lazyloaded cmp so we dont want that file to be read on startup!
    opts = function()
      return require "plugins.configs.blink"
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
    "nvimdev/indentmini.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- files finder etc
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = require "plugins.configs.telescope",
  },

{
    "goerz/jupytext.vim",
    config = function()
        -- Tells Jupytext to use the "percent" format (cells are separated by # %%)
        vim.g.jupytext_fmt = 'py:percent'
        
        -- Optional: Don't show the "Jupytext: converting..." message every time
        vim.g.jupytext_print_time = 0
    end
},
{
    "benlubas/molten-nvim",
    version = "^1.0.0", -- Use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
        -- 1. Tell Neovim exactly where your Python environment is
        vim.g.python3_host_prog = "/home/xaver/miniconda3/bin/python3"

        -- 2. Visual settings for the output window
        vim.g.molten_output_win_max_height = 20
        vim.g.molten_wrap_output = true

        -- 3. (Optional) Image support - Uncomment this when you switch to Kitty!
        vim.g.molten_image_provider = "image.nvim"

-- Push text down so it doesn't cover the next block
        vim.g.molten_output_virt_lines = true
        
        -- Keep output pinned to the cell even when you move the cursor
        vim.g.molten_virt_text_output = true
        
        -- Pin images to the virtual text so they stay visible
        vim.g.molten_image_location = "virt"
    end,

},

{
    "3rd/image.nvim",
    opts = {
        backend = "kitty", -- Explicitly tell it to use Kitty's graphics protocol
        max_width = 100,
        max_height = 12,
        max_height_window_percentage = math.huge,
        max_width_window_percentage = math.huge,
        window_overlap_clear_enabled = true,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
}
}
