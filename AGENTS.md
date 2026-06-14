# AGENTS.md

## Overview
This repository is a personal dotfiles setup managed by Dotbot. The root `install` script runs the Dotbot submodule with `install.conf.yaml`.

## Essential commands
- Install / bootstrap dotfiles: `./install`
- Homebrew bundle (used by install): `./setup_homebrew.sh`
- Node setup (uses `n` and installs global npm packages): `./setup_node.sh`
- SSH setup (creates `~/.ssh/id_ed25519` if missing): `./setup_ssh.sh`
- Finalization step: `./setup_finalize.sh`

## Repository layout
- `install` / `install.conf.yaml`: Dotbot entrypoint + configuration.
- `zshrc`, `zshenv`, `zprofile`: shell setup and PATH configuration.
- `karabiner/`, `ghostty/`, `popclip/`: app configs.
- `wezterm.lua`: WezTerm terminal config (workspaces, keybindings, theme).
- Neovim configs:
  - `NirusuVim/`, `HENKVim/`, `NirusuAstro/`, `NeoNirusu/` each have `init.lua` and `lua/`.
- `dotbot/`: Dotbot submodule (Python project with its own tooling).

## Install behavior and gotchas
- `install.conf.yaml` runs several shell steps in order, including cloning Kickstart/LazyVim starter repos into `~/.config` and `~/dotfiles/*` if missing, and starting the `borders` service via `brew services`.
- The config creates and links many directories under `~/.config`, `~/Library`, and `~/Pictures`.
- `setup_homebrew.sh` installs Homebrew if missing and runs `brew bundle --verbose` (uses `Brewfile`).
- `setup_node.sh` uses `n` and installs global npm packages (see file for list).

## Dotbot submodule (development)
From `dotbot/DEVELOPMENT.md`:
- Tests: `hatch test`
- Type checking: `hatch run types:check`
- Formatting/lint: `hatch fmt` (or `hatch fmt --check`)

## Conventions and patterns
- Shell scripts are mostly `zsh` and use helper `exists()` from `zshenv`.
- Neovim configs follow LazyVim/Kickstart-style structure and use `require("config.*")` modules.
