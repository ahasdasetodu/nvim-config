# Learning Neovim with this config

This repo is a [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) base you own.
Config lives here and is linked as `~/.config/nvim`.

## How to practice (first 1–2 weeks)

Do short sessions (20–30 minutes), not marathons.

1. **Motions** — stay in Normal mode by default. Practice `hjkl`, `w`/`b`/`e`, `0`/`^`/`$`, `gg`/`G`, `f`/`t`, `%`.
2. **Edits** — `i`/`a`/`o`, `x`, `dd`/`dw`, `yy`/`p`, `u`/`Ctrl-r`, `ciw`/`di"`.
3. **Search** — `/pattern`, `n`/`N`, `*` on a word.
4. **Windows** — `Ctrl-h/j/k/l` (mapped in this config) to move between splits.

Ignore most plugins until motions feel less fragile.

## What this config already gives you

| Need | How |
| --- | --- |
| Find files | `<leader>sf` (space + s + f) — Telescope |
| Live grep | `<leader>sg` — needs `rg` |
| LSP (Python) | `pyright` (types) + `ruff` (lint/format) |
| LSP (C/C++) | `clangd` |
| Completions | blink.cmp (automatic) |
| Key hints | which-key — press space and wait |
| Format | `<leader>f` (conform) |

Leader key is **space**.

Useful LSP keys (when a language server is attached): `gd` goto definition, `grr` references, `K` hover, `<leader>ca` code action.

## Read the config (week 2+)

Open `init.lua` and skim one section at a time:

1. Options + keymaps (top)
2. Telescope
3. LSP / Mason (`servers` table — where `clangd`, `pyright`, `ruff` are enabled)
4. Completions
5. Treesitter

Rule: **change one thing per week** (a keymap, colorscheme, or one plugin). Re-read that section first.

## Python tips

- Prefer project envs via `uv`; Pyright will pick up the active environment in many cases.
- Open a `.py` file and run `:LspInfo` to confirm servers attached.

## C++ tips

- `clangd` works best with a `compile_commands.json` in the project root (or build dir).
- With CMake:

  ```bash
  cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build
  ln -sf build/compile_commands.json .
  ```

## WSL notes

- Clipboard is wired to Windows via `clip.exe` / PowerShell (see `init.lua`).
- Tools were installed under `~/.local` (no sudo). `PATH` should include `~/.local/bin` via `~/.local/bin/env` in your bashrc.
- Optional later (if you have sudo): `sudo apt install unzip xclip` — we already ship a small `unzip` shim and WSL clipboard, so this is not required to start.

## Sanity checks

```bash
nvim --version          # expect 0.10+
node -v && npm -v       # Node 22 LTS
rg --version && fd --version && clangd --version
```

Inside Neovim: `:Mason` (installed tools), `:checkhealth`.
