-------------------------------
-- Keymaps (only active in buffers with an attached LSP)
-------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local function map(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf })
    end

    -- navigation
    map("n", "gD", vim.lsp.buf.declaration)
    map("n", "gd", vim.lsp.buf.definition)
    map("n", "gi", vim.lsp.buf.implementation)
    map("n", "gr", vim.lsp.buf.references)
    map("n", "<leader>D", vim.lsp.buf.type_definition)

    -- information
    map("n", "K", vim.lsp.buf.hover)
    map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help)

    -- actions
    map("n", "<leader>rn", vim.lsp.buf.rename)
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
    map("n", "<leader>fm", function() vim.lsp.buf.format { async = true } end)

    -- workspace
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder)
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder)
    map("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)
  end,
})

-------------------------------
-- Capabilities (shared by all servers)
-------------------------------
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
    properties = { "documentation", "detail", "additionalTextEdits" },
  },
}
vim.lsp.config("*", { capabilities = capabilities })

-------------------------------
-- Server specific settings
-------------------------------
local mason_bin = vim.fn.stdpath "data" .. "/mason/bin/"

vim.lsp.config("matlab_ls", {
  cmd = { mason_bin .. "matlab-language-server", "--stdio" },
  filetypes = { "matlab" },
  root_markers = { ".git" },
  workspace_required = false,
  settings = {
    matlab = {
      installPath = vim.fn.expand "~/matlab_latest",
      telemetry = false,
    },
  },
})

vim.lsp.config("vhdl_ls", {
  cmd = { mason_bin .. "vhdl_ls" },
  filetypes = { "vhdl" },
  root_markers = { "vhdl_ls.toml", ".git" },
})

vim.lsp.config("pyright", {
  filetypes = { "python", "ipynb" },
})

vim.lsp.config("jdtls", {
  root_markers = { "pom.xml", "gradlew", "build.gradle", ".git" },
})

vim.lsp.enable {
  "clangd",
  "jdtls",
  "julials",
  "lua_ls",
  "matlab_ls",
  "pyright",
  "tinymist",
  "vhdl_ls",
}
