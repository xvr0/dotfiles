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
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
        require('kanagawa').setup({
            compile = false,             -- enable compiling the colorscheme
            undercurl = true,            -- enable undercurls
            commentStyle = { italic = true },
            functionStyle = {},
            keywordStyle = { italic = true},
            statementStyle = { bold = true },
            typeStyle = {},
            transparent = true,          -- do not set background color
            dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
            terminalColors = true,       -- define vim.g.terminal_color_{0,17}
            
            colors = {                   
                palette = {},
                theme = { 
                    wave = {}, 
                    lotus = {}, 
                    dragon = {}, 
                    all = {
                        ui = {
                            bg_gutter = "none" -- Removes the distinct background from line numbers
                        }
                    } 
                },
            },
            
            overrides = function(colors) 
                local theme = colors.theme
                return {
                    -- Dark completion (popup) menu fixes (autocomplete, snippets)
                    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
                    PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                    PmenuSbar = { bg = theme.ui.bg_m1 },
                    PmenuThumb = { bg = theme.ui.bg_p2 },

                    -- Transparent Floating Windows (Lazy, Mason, Hover documentation)
                    NormalFloat = { bg = "none" },
                    FloatBorder = { bg = "none" },
                    FloatTitle = { bg = "none" },
                    NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
                    LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                    MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

                    -- Borderless Telescope[cite: 2]
                    TelescopeTitle = { fg = theme.ui.special, bold = true },
                    TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                    TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                    TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                    TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                    TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                    TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
                    
                    -- Bufferline backgrounds
                    BufferLineFill = { bg = theme.ui.bg },
                    BufferLineBackground = { bg = theme.ui.bg_m3 },
                }
            end,
            
            theme = "wave",              -- Load "wave" theme
            background = {               -- map the value of 'background' option to a theme
                dark = "wave",           
                light = "lotus"
            },
        })

        -- setup must be called before loading
        vim.cmd("colorscheme kanagawa")
    end,
},

{
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
init = function()
  vim.g.vimtex_view_method = "zathura"
  
  -- 1. Tell Vimtex to use lualatex as the default engine globally
  vim.g.vimtex_compiler_latexmk_engines = {
    _ = '-lualatex'
  }
  
  -- 2. Restore defaults alongside your custom -shell-escape flag
  vim.g.vimtex_compiler_latexmk = {
    build_dir = '',
    callback = 1,
    continuous = 1,
    executable = 'latexmk',
    hooks = {},
    options = {
      '-verbose',
      '-file-line-error',
      '-synctex=1',
      '-interaction=nonstopmode',
      '-shell-escape',
    },
  }

  vim.g.vimtex_quickfix_mode = 0
  vim.g.vimtex_spell_enabled = 1
  
  vim.opt.conceallevel = 2
  vim.g.tex_conceal = "abdmg"
end
},
  { "nvim-tree/nvim-web-devicons", opts = {} },
  { "echasnovski/mini.statusline", opts = {} },
  { "lewis6991/gitsigns.nvim", opts = {} },


--   { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = function()
--     require "plugins.configs.gruvbox"
--   end
-- },
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
    require("luasnip.loaders.from_vscode").lazy_load({
      exclude = { "vhdl" }
    })
    
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
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    image = { 
      enabled = true,
      doc = {
        enabled = false, -- Disables automatic inline rendering for Typst, Markdown, and LaTeX
      },
    }, 
  }
},
  
  -- -- 2. The LaTeX previewer itself
  -- {
  --   "sonv/latex-preview.nvim",
  --   dependencies = { "folke/snacks.nvim" },
  --   ft = { "tex" }, -- Only load when editing LaTeX files
  --   keys = {
  --     { "lp", "LatexPreview toggle", desc = "Toggle LaTeX Preview" },
  --   },
  --   opts = {
  --     render = {
  --       -- Default is usually 300. 
  --       -- If the math pops up too small on your i3 setup, increase this to 600.
  --       density = 300, 
  --     }
  --   }
  -- },

-- {
--   "chomosuke/typst-preview.nvim",
--   lazy = false,
--   version = "1.*",
--   build = function() require("typst-preview").update() end,
--   keys = {
--     { "<leader>tp", "<cmd>TypstPreview<cr>", desc = "Typst Preview" },
--     { "<leader>ts", "<cmd>TypstPreviewSync<cr>", desc = "Typst Preview Sync" },
--     { "<leader>tt", "<cmd>TypstPreviewToggle<cr>", desc = "Typst Preview Toggle" },
--   },
--   opts = {
--     live_as_you_type = true,
--
--     -- ADD THIS LINE:
--     -- Forces Brave to open without tabs or a search bar.
--     -- (If 'brave' command isn't found, try 'brave-browser --app=%s')
--     -- open_cmd = "brave --app=%s", 
--   },
-- },

{
    "jmbuhr/otter.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      -- Automatically activate Otter for Typst files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "typst",
        callback = function()
          local otter = require("otter")
          -- Tell Otter to look for embedded Python and activate its LSP
          otter.activate({ "python","julia","matlab" }, true, true, nil)
        end,
      })
    end,
  }


}
