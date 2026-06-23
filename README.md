# Dusan's dotfiles

> [!NOTE]
> Inspired by awesome [Theo's Dotfiles](https://github.com/theopn/dotfiles)

Dotfiles for my MacBook Pros (Intel, M2, M4) running the latest macOS.

Tools in this repository are mostly open-source utilities for development.

> [!IMPORTANT]
> You are welcome to take inspiration from any files in this repository. Still, I do not claim any responsibility for any of the contents of the configurations (licensed under the MIT License).
> **Read the code before you use it!**

## Installation

**1. Clone**
```bash
git clone https://github.com/dpunosevac/dotfiles.git ~/dotfiles
```

**2. Install Homebrew and all packages**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off
~/dotfiles/dotfiles-util.sh --macos-install
```

**3. Symlink configs**
```bash
~/dotfiles/dotfiles-util.sh --install
~/dotfiles/dotfiles-util.sh --delete-backup # Optional
```

**4. Set up tiling WM** (packages already installed by step 2)
```bash
~/dotfiles/dotfiles-util.sh --aerospace-install
open -a AeroSpace
brew services start sketchybar
brew services start borders
```
See [macOS Tiling WM Setup](#macos-tiling-wm-setup) for required macOS settings.

**5. Install fonts**
```bash
brew install --cask font-caskaydia-cove-nerd-font font-fantasque-sans-mono-nerd-font
```

**6. Create machine-specific config**

Create `~/.zshrc.local` for anything machine-specific — tokens, cloud SDKs, language runtimes. Sourced automatically, never committed.

```bash
# Example ~/.zshrc.local
export GH_ACCESS_TOKEN=$(gh auth token 2>/dev/null)
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
```


## Shells

### Zsh

> The shell

- Usage:
    - Prompt:
        ```
        [vi-mode]` ➜ /current/path/ git-branch(* for unstaged, + for staged changes) | last-exit-code ❱
        ```
    - Aliases: `cl` clear, `l` ls list view, `histgrep` search history, `gs/gp/gpl/gc` git shortcuts, `lzd` lazydocker, `lzg` lazygit
    - I only install [zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete) by default

## Terminal Emulator

### Wezterm

> Over-engineered terminal emulator, nailed the fundamental features, and it is configured in Lua!

WezTerm is my primary terminal emulator.
- Usage:
    - `LDR` = `C-a`
    - `LDR c`: Copy mode
    - `LDR s/v`: Create a split pane
    - `LDR hjkl`: Navigate pane
    - `LDR q`: Close pane
    - `LDR z`: Zoom pane
    - `LDR o`: Rotate pane
    - `LDR r`: `resize_pane` mode. Use `hjkl` to resize pane and `ESC` or `Enter` to confirm
    - `LDR t`: New tab
    - `LDR [/]` Navigate tab
    - `LDR 1-9`: Navigate tab by index
    - `LDR n`: Launch tab navigator
    - `LDR e`: Rename tab title
    - `LDR m`: `move_tab` mode. Use `hj`/`kl` to move tabs and `ESC` or `Enter` to confirm
        - `LDR {/}`: Move tab without entering the `move_tab` mode
    - `LDR w`: Workspace launcher
    - `$ wezterm show-keys --lua` to get the Lua table of all keybindings available

## Other Tools

### Git

> Thanks Linus

No comments.


## macOS Tiling WM Setup

I use [AeroSpace](https://github.com/nikitabobko/AeroSpace) and [Sketchybar](https://github.com/FelixKratz/SketchyBar) for a Tokyo-Night-themed tiling WM setup. AeroSpace does not require disabling SIP.

Setup:

- "Desktop & Dock" (Menu Bar) -> "Automatically hide and show the menu bar" -> "Always"
- "Keyboard" -> "Keyboard Shortcuts" -> "Mission Control" -> disable all "Switch to Desktop n" shortcuts (AeroSpace manages its own workspaces)
- Grant AeroSpace Accessibility and Input Monitoring permissions in System Settings → Privacy & Security
- Symlink config and start:
    ```bash
    ~/dotfiles/dotfiles-util.sh --aerospace-install
    open -a AeroSpace
    brew services start sketchybar
    brew services start borders
    ```

Keybindings (`alt` = `⌥`):

- `alt + enter`: Open WezTerm
- `alt + hjkl`: Focus window
- `alt + shift + hjkl`: Move window in layout
- `alt + f`: Toggle fullscreen
- `alt + shift + space`: Toggle floating
- `alt + e`: Balance window sizes
- `ctrl + 1-5`: Switch workspace
- `ctrl + alt + 1-5`: Move window to workspace
- `ctrl + alt + s`: Restart Sketchybar

## macOS

### Homebrew

Bolded items are in `Brewfile_core`, and other items are in `Brewfile_optional`, either because I don't want them to be installed on every machine or are too large.

Formulae:

- ffmpeg: `ffmpeg -i in.xxx out.yyy`
- **fzf**: Command line fuzzy finder
- **htop**: System monitor
- hugo: Static website generator
- imagemagick: Command line image manipulation
- **jq**: JSON processor
- **lazydocker**: Docker TUI
- **lazygit**: Git TUI
- **lua**
- **neofetch**: Happy ricing!
- **neovim**: Where I live
- **node**
- **ripgrep**: Fast grep
- tree: Tree-like directory view
- **wget**: Be careful with what you download

| Type            | Casks                                          |
|-----------------|------------------------------------------------|
| Development     | - Docker<br> - **Wezterm**                     |
| Productivity    | - **Itsycal**                                  |
| System (macOS)  | - **AeroSpace**<br> - **Borders**<br> - **Maccy**<br> - **Sketchybar** |

### Settings

Applied by `~/dotfiles/dotfiles-util.sh --macos-install` via `macos/macos-settings.sh`:

**Dock:** autohide with zero delay, spacer between pinned/open apps, translucent hidden app icons

**Finder:** show hidden files, show all extensions, full POSIX path in title, path bar, folders first, list view, no animations

**Screenshots:** save to `~/Downloads/` as JPG

**Window animations** (run once manually, then log out/in):
```bash
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g NSWindowResizeTime -float 0.001
```
