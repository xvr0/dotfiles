# dotfiles

Personal configs for i3, Neovim, tmux, zsh, kitty, dunst, zathura and yazi.
They are symlinked into place, e.g. `~/.config/nvim -> ~/dotfiles/nvim`,
`~/.config/i3 -> ~/dotfiles/i3`, `~/.tmux.conf`, `~/.zshrc`.

# Changelog

## 2026-10-10 — config cleanup

Cleanup of nvim, tmux, i3 and zsh: sorted, deduplicated, dead/commented-out
code removed. Behaviour was verified to be unchanged (nvim keymaps, highlights,
options and plugin count; `i3 -C`; tmux syntax check; zsh PATH, aliases,
functions and keybindings) except for the bug fixes listed below.

### Reverting

The state before the cleanup is commit `69e2334` ("backup").

```sh
git diff 69e2334 -- <file>            # see what changed
git checkout 69e2334 -- <file>        # restore a single file
git checkout 69e2334 -- nvim i3 .tmux.conf .zshrc   # restore everything
```

Files that were added (`nvim/lua/tmux_runner.lua`,
`nvim/lua/plugins/configs/kanagawa.lua`) must be deleted manually when
restoring the old `mappings.lua` / `plugins/init.lua`.

### Neovim

- `init.lua`: only loads modules and bootstraps lazy.nvim now.
  - removed debug `print("hi")`
  - removed a second `require('kanagawa').setup({...})` (README copy with
    `sumiInk0 = "#000000"`, `fujiWhite = "#FFFFFF"`). It ran after the
    colorscheme was loaded and had no effect.
  - `vim.o.background = "dark"` and the `.m -> matlab` filetype moved to `options.lua`
  - `vim.loop` → `vim.uv`
- `lua/options.lua`: grouped into UI / indenting / folding / search /
  behaviour / filetypes. The three `vim.filetype.add` calls (here, `init.lua`,
  `lspconfig.lua`) are merged into one. The Windows PATH separator check was removed.
- `lua/mappings.lua`: grouped by topic (general, telescope, diagnostics,
  terminal, tmux runner, misc). Removed the duplicate `mapleader`. `<space>` maps
  are written as `<leader>` (same key). Some descriptions were added or renamed.
- `lua/tmux_runner.lua` (new): the tmux "run file" / "repeat last command" /
  "send cell to REPL" logic moved out of `mappings.lua` into a module.
  `_G.last_tmux_cmd` is now a local variable. The keymaps are unchanged
  (`<leader>x`, `<leader>y`, `<leader>rr`).
- `lua/plugins/init.lua`: plugins are grouped (UI, navigation, treesitter/LSP,
  completion, LaTeX). Removed the commented-out gruvbox, latex-preview and
  typst-preview specs.
  - **bug fix:** the `vim-tmux-navigator` entry was missing its `{}`, so its
    `cmd`/`keys` were silently attached to the outer list. It is now a plain
    eager plugin using its default `<C-h/j/k/l/\>` mappings, which is what
    was effectively active before.
- `lua/plugins/configs/kanagawa.lua` (new): kanagawa setup moved here from
  `plugins/init.lua`; the empty `palette`/`wave`/`lotus`/`dragon` tables were removed.
- `lua/plugins/configs/lspconfig.lua`: servers were enabled in four places
  (some twice). They are now one `vim.lsp.enable { ... }` list. The `clangd` and
  `tinymist` configs were identical to the defaults and were removed (the old
  commented riscv `--query-driver` hint is in git history). LSP keymaps use a
  local `map` helper.
- `lua/plugins/configs/treesitter.lua`: the two `FileType` autocmds are merged
  into one (treesitter folding for every filetype, highlighting except tex). The
  old `nvim-treesitter.configs` setup comment was removed.
- `lua/plugins/configs/conform.lua`: reindented, `.vsg.yaml` path via
  `stdpath("config")`, comment leftovers removed.
- `lua/plugins/configs/blink.lua`: stray comment / trailing whitespace removed.
- deleted: `lua/plugins/configs/gruvbox.lua` (unused), `test.py`,
  `lua/test.py`, `lua/mappings.lua.bak` (old toggle-terminal version of the
  mappings).

### tmux (`.tmux.conf`)

- Grouped into general / keybindings / plugins. Removed the comments about
  "previous" settings. `bind-key` → `bind`. Same options and bindings.

### i3 (`i3/config`)

- 652 → ~280 lines. Removed the EndeavourOS header and all commented-out
  alternatives (compositor options, xautolock, xscreensaver, second bar,
  tray apps, rofi/ranger launchers, ...).
- New order: variables → appearance → keybindings (system, apps, media,
  windows, workspaces) → window rules → bar → autostart.
- `$scripts` variable for `~/.config/i3/scripts`.
- Removed the duplicate `Blueberry.py` floating rule and the trailing `&` on
  `nm-applet`. `$mod+shift+z` → `$mod+Shift+z`.
- **bug fix:** `$mod+numpad` (numlock off) switched to workspaces named `1`,
  `2`, ... instead of `$ws1`, `$ws2`, ... (`"1:"`, `"2:www"`). It now uses the
  `$wsN` variables like all other bindings.

### zsh (`.zshrc`)

- Grouped into environment / oh-my-zsh / PATH / aliases / fzf / yazi. Removed
  the oh-my-zsh template comments, the commented `rg()` ranger function and
  old MATLAB paths.
- PATH was built in 7 places. It is now one `path=(...)` list plus one block
  after conda (riscv, `~/bin`, `~/.local/bin`). Resulting PATH order is identical.
  The juliaup and conda blocks are untouched (managed by those tools).
- `fz()`: preview selection is a `case` statement and the duplicate kitty wipe is merged.
  Same behaviour.
- **typo fix:** `cb` alias `-selection cipboard` → `clipboard`.

### Known leftovers / TODO

- nvim: `<leader>r` (redo) and `<leader>rr` (send cell) overlap, so redo waits
  for `timeoutlen` (400ms).
- i3: `$mod+n` runs `ranger` without a terminal (does nothing visible; ranger
  was replaced by yazi).
- i3: `alacritty` config was removed but `$mod+c` still uses it. All
  `Alacritty` windows float. `assign [class="alacritty"]` never matches (the
  class is `Alacritty`). The `firefox` focus rule is unused (brave is used).
- `kitty/kitty.conf.bak` is untracked and probably obsolete.
- Not yet cleaned: kitty, dunst, zathura, yazi.

### Machine-specific things to check on a new computer

- absolute `/home/xaver/...` paths (i3 wallpaper, zsh juliaup/conda blocks)
- `~/matlab_latest`, texlive `2024`, intelFPGA, PLECS, `~/nes/...`, `/opt/riscv...`
- `~/.screenlayout/monitor.sh`, `/usr/local/bin/switch-audio-port`,
  `sudo logid` (needs a sudoers rule)
- HiDPI settings: font size 24, `--force-device-scale-factor=2`, dpi-toggle script
- `.zshrc` replaces PATH rather than extending it, so anything `/etc/profile`
  adds is dropped
- oh-my-zsh + `zsh-autosuggestions` + `zsh-syntax-highlighting`, and tpm for
  tmux (`~/.tmux/plugins/tpm`) need to be installed separately
