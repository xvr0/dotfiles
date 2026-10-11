# Neovim keybinds

Leader is `<Space>`. Local leader is `\` (the default, used by vimtex).
Modes: **n** normal, **v** visual, **i** insert, **t** terminal.

## General

| Key | Mode | Action |
|---|---|---|
| `<leader><leader>` | n | Save |
| `<C-s>` | n | Save |
| `zz` | n | Save and quit (`ZZ`) |
| `<leader>nh` | n | Clear search highlight |
| `<leader>u` | n | Undo |
| `U` | n | Redo |
| `<C-c>` | n | Copy whole file to system clipboard |
| `<leader>s` | n | Substitute word under cursor (whole file) |
| `J` / `K` | v | Move selected lines down / up |
| `<leader>pd` | n | Open PDF path under cursor in zathura |

## Buffers & windows

| Key | Mode | Action |
|---|---|---|
| `<Tab>` | n | Next buffer |
| `<C-Tab>` | n | Previous buffer |
| `<C-h/j/k/l>` | n | Move between splits and tmux panes (vim-tmux-navigator) |
| `<C-\>` | n | Jump to previous split/pane (vim-tmux-navigator) |

## Terminal mode

| Key | Mode | Action |
|---|---|---|
| `<C-n>` | t | Leave terminal mode (normal mode) |
| `<S-Tab>` | t | Previous buffer |
| `<C-q>` | t | Close terminal buffer |
| `<C-h/j/k/l>` | t | Move to split left / down / up / right |

## Telescope

| Key | Mode | Action |
|---|---|---|
| `<leader>ff` | n | Find files |
| `<leader>fg` | n | Live grep |
| `<leader>fb` | n | Buffers |

## LSP (only when a language server is attached)

| Key | Mode | Action |
|---|---|---|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gi` | n | Go to implementation |
| `grr` | n | List references (Neovim built-in) |
| `<leader>D` | n | Go to type definition |
| `K` | n | Hover docs |
| `<C-k>` | n, i | Signature help |
| `<leader>rn` | n | Rename symbol |
| `<leader>ca` | n, v | Code action |
| `<leader>fm` | n | Format buffer |
| `<leader>wa` | n | Add workspace folder |
| `<leader>wr` | n | Remove workspace folder |
| `<leader>wl` | n | List workspace folders |

## Diagnostics

| Key | Mode | Action |
|---|---|---|
| `<leader>e` | n | Show diagnostics for current line |
| `<leader>q` | n | Send diagnostics to location list |

## Completion (blink.cmp, insert mode)

| Key | Action |
|---|---|
| `<CR>` | Accept completion |
| `<C-y>` | Select and accept |
| `<C-space>` | Open menu / toggle docs |
| `<C-e>` | Close menu |
| `<C-n>` / `<C-p>` or `<Down>` / `<Up>` | Next / previous item |
| `<C-f>` / `<C-b>` | Scroll docs down / up |
| `<Tab>` / `<S-Tab>` | Jump to next / previous snippet field |

## Tmux runner / REPL

| Key | Mode | Action |
|---|---|---|
| `<leader>x` | n | Run current file in tmux |
| `<leader>y` | n | Repeat last tmux command |
| `<leader>rr` | n | Send current cell to tmux REPL |

## Claude Code (claudecode.nvim)

| Key | Mode | Action |
|---|---|---|
| `<leader>ac` | n | Open / close Claude |
| `<leader>af` | n | Focus Claude window |
| `<leader>ar` | n | Resume a session (picker) |
| `<leader>aC` | n | Continue last session |
| `<leader>am` | n | Select model |
| `<leader>ab` | n | Add current file to context |
| `<leader>as` | v | Send selection |
| `<leader>aa` | n | Accept diff |
| `<leader>ad` | n | Reject diff |

## LaTeX

| Key | Mode | Action |
|---|---|---|
| `<leader>tx` | n | Launch TeXpresso on current file |
| `\ll` | n | vimtex: start/stop continuous compile |
| `\lv` | n | vimtex: forward search in zathura |
| `\lc` | n | vimtex: clean aux files |
| `\le` | n | vimtex: show errors |
| `\lt` | n | vimtex: table of contents |

## Notes

- Source of truth: `lua/mappings.lua`, `lua/plugins/init.lua` (`keys`),
  `lua/plugins/configs/lspconfig.lua` and `lua/plugins/configs/blink.lua`.
  Inside Neovim, `:map <leader>` or `:Telescope keymaps` shows what's actually bound.
