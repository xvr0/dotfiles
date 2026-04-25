-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}




vim.lsp.config("*", { capabilities = capabilities })

-- --- ADD THIS BLOCK FOR MATLAB ---
vim.lsp.config("matlab_ls", {
  -- 1. Explicitly tell Neovim what command to run
  cmd = { "matlab-language-server", "--stdio" },

  -- 2. Restrict it to only attach to MATLAB files
  filetypes = { "matlab" },

  -- 3. Pass a RAW STRING for the root directory (Native Neovim requirement)
  root_dir = vim.fn.getcwd(),

  -- 4. Pass your custom installation path
  settings = {
    matlab = {
      installPath = vim.fn.expand("~") .. "/usr/local/MATLAB/R2024b"
    }
  }
})
--
-- --- ADD THIS BLOCK FOR MATLAB ---
-- vim.lsp.config("matlab_ls", {
--   -- Point EXACTLY to where Mason installed the binary
--   cmd = { vim.fn.stdpath("data") .. "/mason/bin/matlab-language-server", "--stdio" },
--
--   filetypes = { "matlab" },
--
--   root_dir = vim.fn.getcwd(),
--
--   settings = {
--     matlab = {
--       -- The root directory of your R2024b installation:
--       installPath = "/usr/local/MATLAB/R2024b", 
--       indexWorkspace = true,
--       telemetry = false,
--     }
--   }
-- })
-- ---------------------------------
-- -- ---------------------------------
-- ---------------------------------

-- Add 'matlab_ls' to your table of servers:
local servers = { "pyright", "html", "cssls", "lua_ls", "matlab_ls" }
vim.lsp.config("pyright", {
  -- Tell Pyright to attach to both standard Python files AND Notebooks
  filetypes = { "python", "ipynb" },
})
vim.lsp.enable(servers)
