vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local opts = { buffer = ev.buf }

    -- Navigation
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)

    -- Information
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set({"n", "i"}, "<C-k>", vim.lsp.buf.signature_help, opts)

    -- Actions
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({"n", "v"}, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<space>fm", function()
      vim.lsp.buf.format { async = true }
    end, opts)

    -- Workspace management (Less commonly used day-to-day)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
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

vim.filetype.add({
  extension = {
    m = "matlab",
  },
})

vim.lsp.config("matlab_ls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/matlab-language-server", "--stdio" },
  filetypes = { "matlab" },
  root_markers = { ".git" },
  workspace_required = false,
  settings = {
    matlab = {
      installPath = vim.fn.expand("~/matlab_latest"),
      telemetry = false,
    }
  }
})

vim.lsp.enable("matlab_ls")

vim.lsp.config("pyright", {
  filetypes = { "python", "ipynb" },
})

-- Define the absolute path to the Mason binary
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/vhdl_ls"

-- Configure the server directly in Neovim
vim.lsp.config("vhdl_ls", {
  cmd = { mason_bin },
  filetypes = { "vhdl" },
  -- Use root_markers instead of a root_dir function. 
  -- The native client handles the upward search automatically.
  root_markers = { "vhdl_ls.toml", ".git" },
})

-- Enable it so it attaches when a matching filetype is opened
vim.lsp.enable("vhdl_ls")
-- 1. Configure the server (merge your custom settings)
vim.lsp.config('tinymist', {
  -- Add your standard capabilities or on_attach functions here if you use them
  capabilities = capabilities,
})

-- 2. Enable the server
vim.lsp.enable('tinymist')
vim.lsp.config("clangd", {
  cmd = { 
    "clangd", 
    -- "--query-driver=/opt/riscv-gnu-toolchain-multi/bin/riscv64-unknown-elf-*" 
  }
})
-- Configure jdtls for Java
vim.lsp.config("jdtls", {
  -- Recognize Maven (pom.xml), Gradle, or Git as the root of the Java project
  root_markers = { "pom.xml", "gradlew", "build.gradle", ".git" },
})
-- Enable your servers (julials will use the official nvim-lspconfig runner)
-- Enable your servers (julials will use the official nvim-lspconfig runner)
local servers = { "pyright", "clangd", "lua_ls", "matlab_ls", "julials", "jdtls" }
vim.lsp.enable(servers)
