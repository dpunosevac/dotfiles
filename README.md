# Dusan's dotfiles

> [!NOTE]
> Inspired by awesome [Theo's Dotfiles](https://github.com/theopn/dotfiles)

Here are dotfiles for my systems, M2 MacBook Pro and Intel MacBook Pro.
MBPs run the latest version of macOS.

Tools in this repository are mostly open-source utilities for development.

> [!IMPORTANT]
> You are welcome to take inspiration from any files in this repository. Still, I do not claim any responsibility for any of the contents of the configurations (licensed under the MIT License).
> **Read the code before you use it!**

## Installation

- Configure cross-platform utilities using the following commands:
    ```bash
    git clone https://github.com/dpunosevac/dotfiles.git ~/dotfiles
    ~/dotfiles/dotfiles-util.sh --install
    ~/dotfiles/dotfiles-util.sh --delete-backup # Optional
    ```

- Configure macOS-specific utilities and settings using the following commands:
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew analytics off

    ~/dotfiles/dotfiles-util.sh --macos-install
    ```

- Configure AeroSpace and Sketchybar for macOS tiling WM setup using the following commands:
    ```bash
    ~/dotfiles/dotfiles-util.sh --aerospace-install
    ```
    Don't forget to follow the further instructions in [the macOS tiling WM section](#macos-tiling-wm-setup)

- Choose configurations in the `misc` directory and manually copy them! Follow the commands in `./misc/README.md`.

### Post-Installation

- To install fonts via `fontconfig` and the included function in `dotfiles-util.sh`:
    1. Navigate to [NERD Fonts download](https://www.nerdfonts.com/font-downloads) website
    2. Right-click on the font download and copy the link
    3. Execute the following
        ```bash
        $FONT_URL=thing-you-just-copied
        ~/dotfiles/dotfiles-util.sh --install-font $FONT_URL
        ```

- To install CaskaydiaCove and Fantasque Sans Mono Nerd Fonts using Homebrew:
    ```bash
    brew install --cask font-caskaydia-cove-nerd-font font-fantasque-sans-mono-nerd-font
    ```

## Shells

### Zsh

> The shell

- Usage:
    - Prompt:
        ```
        [vi-mode]` ➜ /current/path/ git-branch(* for unstaged, + for staged changes) | last-exit-code ❱
        ```
    - Basic aliases: `cdf` to navigate directories quickly using `fzf`,
        `cl` to `clear`, `l` to `ls` with list view and other options, `histgrep` to look up previous commands
    - I only install [zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete) by default

## Terminal Emulator

### Wezterm

> Over-engineered terminal emulator, nailed the fundamental features, and it is configured in Lua!

Wezterm is my primary terminal emulator/multiplexer!
Watch my YouTube video [Configure Wezterm terminal emulator in Lua with me [ASMR Coding]](https://youtu.be/I3ipo8NxsjY) :)

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

## Miscellaneous Configurations

> [!NOTE]
> These are single-file, minimal configurations that do not change very often.
> These are meant to be manually deployed as needed.
> Use the commands in `./misc/README.md` to deploy these configurations.

- `bashrc`: Minimal config with a simple prompt, some aliases, and PATH variables. Zsh handles interactive use; Bash for scripts.

## macOS Tiling WM Setup

I use [AeroSpace](https://github.com/nikitabobko/AeroSpace) and [Sketchybar](https://github.com/FelixKratz/SketchyBar) for a Tokyo-Night-themed tiling WM setup. AeroSpace does not require disabling SIP.

Setup:

- "Desktop & Dock" (Menu Bar) -> "Automatically hide and show the menu bar" -> "Always"
- "Keyboard" -> "Keyboard Shortcuts" -> "Mission Control" -> disable all "Switch to Desktop n" shortcuts (AeroSpace manages its own workspaces)
- Install AeroSpace and Sketchybar:
    ```bash
    brew install --cask nikitabobko/tap/aerospace FelixKratz/formulae/sketchybar
    ```
- Grant AeroSpace Accessibility and Input Monitoring permissions in System Settings → Privacy & Security
- Symlink config and start:
    ```bash
    ~/dotfiles/dotfiles-util.sh --aerospace-install
    open -a AeroSpace
    brew services start sketchybar
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
| System (macOS)  | - **AeroSpace**<br> - **Maccy**<br> - **Sketchybar** |

### Settings

Remove Dock unhide animation, add a Dock spacer, show hidden files in Finder, change screenshot format and location (I like having every temporary file in `~/Downloads/`), etc.
