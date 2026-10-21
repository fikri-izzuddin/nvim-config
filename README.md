# Neovim config

Fikri Izzuddin's personal Neovim config, written from scratch for Neovim 0.12.
Plugins are managed by the built-in `vim.pack`, and `nvim-pack-lock.json` pins
each one to an exact commit.

## Requirements

- Neovim 0.12 or newer, and Git.
- A Nerd Font for icons.
- `tree-sitter-cli` and a C compiler, so nvim-treesitter can build parsers.
- Python: `basedpyright` (default) or `ty`, plus `ruff`.
- Lua: `lua-language-server` and `stylua`.
- `fzf`, `ripgrep`, and `fd` for the fuzzy finder, search and replace.

```sh
uv tool install basedpyright ty ruff
sudo pacman -S tree-sitter-cli gcc lua-language-server stylua fzf ripgrep fd
```

## Install

Back up your current config, then clone:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/fikri-izzuddin/nvim-config ~/.config/nvim
nvim
```

The first start installs every plugin at its locked commit, and the treesitter
parsers build in the background.

To try it next to your own config:

```sh
git clone https://github.com/fikri-izzuddin/nvim-config ~/.config/nvim-fikri
NVIM_APPNAME=nvim-fikri nvim
```

## Layout

```text
├── init.lua      leader, then requires each module in order
├── lua
│   ├── config    options, keymaps, autocmds, vim.pack helpers, terminal
│   └── plugins   one file per area: ui, editor, treesitter, lsp, completion,
│                 format, navigation
├── after
│   ├── lsp       per-server overrides (basedpyright, ruff)
│   └── ftplugin  per-filetype settings (gitcommit)
└── snippets      custom snippets for blink.cmp
```

## Keymaps

Leader is <kbd>Space</kbd>. Press it and pause to see every group.

| Key                      | Action                                  |
| ------------------------ | --------------------------------------- |
| `<SPACE>w`               | Save                                    |
| `<SPACE>qq`              | Quit all                                |
| `<SPACE>qx`              | Save and exit                           |
| `<SPACE>qX`              | Save and exit all                       |
| `<SPACE>Q`               | Quit all without saving                 |
| `<C-h/j/k/l>`            | Move to window or tmux pane             |
| `<A-h/j/k/l>`            | Resize window (normal)                  |
| `<C-/>`                  | Toggle floating terminal                |
| `<SPACE>uu`              | Undo tree                               |
| `<SPACE>\|` / `<SPACE>-` | Split right / below                     |
| `<S-h>` / `<S-l>`        | Previous / next buffer                  |
| `<SPACE>1` to `<SPACE>9` | Go to buffer 1 to 9                     |
| `<SPACE>bx`              | Close buffer                            |
| `gd`                     | Go to definition                        |
| `<SPACE>ca`              | Code action                             |
| `<SPACE>cr`              | Rename                                  |
| `<SPACE>cf`              | Format                                  |
| `<SPACE>co`              | Organize imports (Python)               |
| `<SPACE>cp`              | Switch Python type checker              |
| `<SPACE>uh`              | Toggle inlay hints                      |
| `]f` / `[f`              | Next / previous function                |
| `]c` / `[c`              | Next / previous class                   |
| `<A-j>` / `<A-k>`        | Move line or selection (insert, visual) |

Completion (blink.cmp):

| Key               | Action                                     |
| ----------------- | ------------------------------------------ |
| `<Tab>`           | Accept the selected item, or the first one |
| `<CR>`            | Accept the selected item                   |
| `<C-n>` / `<C-j>` | Next item                                  |
| `<C-p>` / `<C-k>` | Previous item                              |
| `<C-space>`       | Open the menu or docs                      |
| `<C-e>`           | Close the menu                             |

Navigation (fzf-lua, nvim-tree, grug-far):

| Key                       | Action                                |
| ------------------------- | ------------------------------------- |
| `<SPACE>ff`               | Find file                             |
| `<SPACE>/`                | Grep project                          |
| `<SPACE>fw`               | Grep word under cursor                |
| `<SPACE>fb` / `<SPACE>fr` | Buffers / recent files                |
| `<SPACE>f.`               | Resume last picker                    |
| `<SPACE>e` / `<SPACE>E`   | Toggle explorer / reveal current file |
| `<SPACE>sr` / `<SPACE>sf` | Replace in project / file             |
| `<SPACE>xd` / `<SPACE>xD` | Diagnostics in file / workspace       |
| `grr` / `gri`             | References / implementations          |

## Python

The type checker is basedpyright by default. Switch it with `:PyLsp ty`,
`:PyLsp basedpyright`, or `<SPACE>cp`. The statusline shows which one is
running. If the project root has `.venv/bin/python`, basedpyright uses it. On
save, ruff organizes imports and then formats.

## Updating

| Key         | Action                                                      |
| ----------- | ----------------------------------------------------------- |
| `<SPACE>pu` | Review updates, then `:write` to apply or `:quit` to cancel |
| `<SPACE>pc` | Plugin status, without fetching                             |
| `<SPACE>pl` | List plugins and open one's folder                          |
| `<SPACE>px` | Delete plugins no longer in the config                      |

After an update, commit the lockfile. To roll back a bad update, restore the old
lockfile and restart Neovim:

```sh
# after an update
git add nvim-pack-lock.json
git commit -m "chore: update plugins"

# to roll back a bad update
git checkout HEAD~1 -- nvim-pack-lock.json
```

## License

[MIT](LICENSE)
