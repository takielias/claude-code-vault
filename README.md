# ccv -- Claude Code Vault

[![Downloads](https://img.shields.io/github/downloads/takielias/claude-code-vault/total?style=for-the-badge&label=downloads&color=8B5CF6)](https://github.com/takielias/claude-code-vault/releases)

A CLI tool that keeps private files (docs, prompts, notes) in a single private Git repo and symlinks them into your projects. Nothing leaks into public repos.

## Install

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/takielias/claude-code-vault/main/install.sh | sh
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/takielias/claude-code-vault/main/install.ps1 | iex
```

## How it works

1. A private Git repo at `~/.ccv/` stores all your files
2. `ccv add` moves files there and replaces them with symlinks
3. `.gitignore` is updated so nothing gets committed to public repos
4. `ccv push` / `ccv pull` syncs the vault across machines

## Usage

```bash
cd ~/projects/my-app
ccv init                    # register project (sets up vault on first run)
ccv add CLAUDE.md docs/     # move files to vault, replace with symlinks
ccv push                    # commit and push vault
ccv status                  # check what changed
ccv list                    # show all projects and files
```

On a new machine:

```bash
cd ~/projects/my-app
ccv init                    # prompts for vault remote on first run
ccv link                    # create symlinks for registered files
```

## Commands

| Command | What it does |
|---------|--------------|
| `ccv init` | Register project. Sets up vault if missing. |
| `ccv init --scan` | Register and pick files interactively |
| `ccv add <path>...` | Move files/folders to vault, create symlinks |
| `ccv remove <path>...` | Restore files from vault to project |
| `ccv link` | Create symlinks for all registered files |
| `ccv unlink` | Remove symlinks. Files stay in vault. |
| `ccv push` | Commit and push vault changes |
| `ccv push -m "msg"` | Push with a custom commit message |
| `ccv pull` | Pull latest vault from remote |
| `ccv list` | Show all projects and their files |
| `ccv status` | Show what changed in the vault |
| `ccv watch` | Auto-commit and push on file changes |
| `ccv reset` | Remove vault, all symlinks, all .gitignore entries |
| `ccv reset --force` | Same as above, skip confirmation |

## Platforms

Pre-built binaries for each release:

- Linux (amd64, arm64)
- macOS (amd64, arm64)
- Windows (amd64, arm64)

Download from the [releases page](https://github.com/takielias/claude-code-vault/releases).

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/takielias/claude-code-vault/main/uninstall.sh | sh
```

## License

Freeware -- free to use, no source code provided. See [LICENSE](./LICENSE) for details.
