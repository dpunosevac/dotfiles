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

- Configure Yabai, Skhd, and Sketchybar for macOS tiling WM setup using the following commands:
    ```bash
    ~/dotfiles/dotfiles-util.sh --yabai-install
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

- To install Iosevka Nerd Font (for terminal emulators and text editors) and CaskayadiaCove Nerd Fonts (for window managers) using Homebrew:
    ```bash
    brew tap homebrew/cask-fonts &&
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
    - `trash`, `trash_cd`, `trash_empty`, `trash_print`: trash related functions.
        The trash directory is located in `~/.theoshell/trash`. This directory will be used again for LF
    - `theoshell_plug <github-username>/<repo-name>`: installs Zsh plug-in from a GitHub repository (to `~/.theoshell/zsh-plugins`) and/or source it
        - I only install [zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete) by default
    - `theoshell_upgrade`: Upgrade all Zsh plug-ins in `~/.theoshell/zsh-plugins`

## Terminal Emulators and Multiplexers

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

## File Manager

### lf

> My favorite terminal file manager

When I see a CLI file manager with Vim keybindings and a minimalistic feature set, I like it. I use it.

- Usage:
    - `~` : Go to the home directory
    - `ee`: Open a file in `$EDITOR`
    - `ec`: You choose what editor you want to open a file in
    - `DD`: Move a file to `~/.theoshell/trash` (it integrates with my Zsh trash functions)
    - `gs`: [g]it [s]tatus
    - `md`: mkdir
    - `mf`: Open a file with the supplied name in Neovim
    - `ml`, `mr`, `ms`: [m]ark [l]oad, [m]ark [r]emove, [m]ark [s]ave
    - `mo`: chmod
    - `sh`: Launch `$SHELL` at the current directory

## Other Tools

### Git

> Thanks Linus

No comments.

## Miscellaneous Configurations

> [!NOTE]
> These are single-file, minimal configurations that do not change very often.
> These are meant to be manually deployed as needed.
> Use the commands in `./misc/README.md` to deploy these configurations.

- `bashrc`: I prioritize simplicity and performance since Zsh and Fish take care of my interactive uses and most of my scripts are written in Bash.
    Thus, my `.bashrc` is kept minimal with a simple prompt, some aliases, and variables
- `ideavimrc`: Sorry to disappoint you, but I code in Java sometimes
- `neofetch.conf`: It includes a prompt inspired by "insert name" from [Neofetch Themes](https://github.com/Chick2D/neofetch-themes)

## macOS Tiling WM Setup

I use these [Yabai](https://github.com/koekeishiya/yabai), [Skhd](https://github.com/koekeishiya/skhd), and [Sketchybar](https://github.com/FelixKratz/SketchyBar) to make a Tokyo-Night-themed tiling WM setup for my macOS environment.

To begin, modify the macOS settings as follows:

- "Desktop & Dock" (Mission Control) -> "Displays have separate Spaces" -> On
- "Desktop & Dock" (Menu Bar) -> "Automatically hide and show the menu bar" -> "Always"
- Make shortcuts for switching desktops using a built-in macOS key modifier (if you are to use Skhd for this, it requires disabling SIP)
    - Create 5 Mission Control desktops
    - "Keyboard" -> "Keyboard Shortcuts" -> "Mission Control" -> "Mission Control" -> Turn on "Switch to Desktop n" (where "n" is the number 1 - 5)
    - Set the shortcut to `^n` (`Ctrl n`) or `⌥n` (`Opt n`)
    - While you are at it, go to "Modifier Keys" and switch "Caps Lock key" and "Control key". Your pinky will thank you

Install and start utilities:

- Install Yabai, Skhd, and Sketchybar:
    ```bash
    brew install koekeishiya/formulae/skhd koekeishiya/formulae/yabai FelixKratz/formulae/sketchybar
    ```
- Start Skhd:
    ```bash
    skhd --start-service
    ```
- Use `ctrl + alt - s` keybinding (ctrl + opt + s) to start sketchybar and Yabai.
- Use `ctrl + alt - q` keybinding (ctrl + opt + q) to stop sketchybar and Yabai.

Keybindings:

- The `opt`/`alt` (`⌥`) key is the modifier
- `mod + ret`: Open Wezterm
- `mod + hjkl`: Navigate windows
- `mod + f`: Toggle fullscreen
- `mod + shift + r`: Rotate tree
- `mod + shift + y/x`: Mirror x-axis/y-axis
- `mod + shift + SPC`: Toggle floating
- `mod + shift + e`: Balance all window size
- `mod + shift + hjkl`: ~~Resize window (h to shrink left, j to grow above, k to shrink below, l to grow right)~~ Swap window (use mouse for resizing)
- `mod + ctrl + hjkl`: Move window and tile with what was already there
- `mod + shift + 1-5`: Move to WS 1-5

Yabai is a fantastic tool, but because it's running on top of Aqua (macOS default WM), there are a few limitations.
Here are some bugs I encountered, all to blame Apple for not letting users change Aqua.

- Layout not persisting after exiting a full-screen video play in Firefox
- Windows with minimum width (e.g., Apple Calendar, Spotify, Discord) not tiling nicely
- Emacs not tiling (even with `(menu-bar-mode t)`)
- Kitty not tiling (with the window decorations removed)
- Being unable to delete a Mission Control desktop with Yabai running
- High CPU usage of `WindowServer` process

Use `cat /tmp/yabai_$USER.err.log` and `cat /tmp/skhd_$USER.err.log` to view the Yabai and Skhd log messages.

Because of Yabai's limitations, I prefer using [Rectangle](https://github.com/rxhanson/Rectangle) and manually tiling windows when using a small laptop screen.
After installing Rectangle, execute the following command to make Rectangle aware of Sketchybar:

```bash
defaults write com.knollsoft.Rectangle screenEdgeGapTop -int 30 # 0 to reset
```

My Vim-inspired Rectangle keybindings (restore them using ./macos/vimtangle.json):

- `control + command` (`⌃⌘`) is the modifier
- `mod + h/l`: Left/right half
- `mod + j/k`: First thirds/last two thirds
- `mod + n/m`: Almost maximize/maximize
- `mod + -/=`: Smaller/larger

## macOS

### Homebrew

Bolded items are in `Brewfile_core`, and other items are in `Brewfile_optional`, either because I don't want them to be installed on every machine or are too large.

Formulae:

- ffmpeg: `ffmpeg -i in.xxx out.yyy`
- figlet: ASCII art generator
- **fish**: De facto default shell
- **fzf**: Command line fuzzy finder
- **htop**: System monitor
- hugo: Static website generator
- imagemagick: Command line image manipulation
- **lf**: My favorite CLI file manager
- **lua**
- **neofetch**: Happy ricing!
- **neovim**: Where I live
- **node**
- rclone: Cloud storage management
- **rust**
- **tmux**: Universal terminal multiplexer
- tree: Tree-like directory view
- **wget**: Be careful with what you download

| Type            | Casks                                                                                                 |
|-----------------|-------------------------------------------------------------------------------------------------------|
| Development     | - Docker<br> - IntelliJ CE<br> - kitty<br> - MacTex (No GUI)<br> - **MacVim**<br> - **Wezterm**       |
| Fun             | - Discord<br> - Minecraft<br> - Spotify                                                               |
| Productivity    | - **Emacs**<br> - **Itsycal**<br> - Notion<br>                                                        |
| System (macOS)  | - AppCleaner<br> - **Maccy**<br> - **Rectangle**<br> - **Stats**<br> - **Spaceman**                   |
| Tools           | - **Bitwarden**<br> - Cryptomator<br> - GIMP<br> - OBS<br> - **Skim**<br> - VLC                       |
| Web             | - **Firefox**<br> - Thunderbird                                                                       |

### Settings

Remove Dock unhide animation, add a Dock spacer, show hidden files in Finder, change screenshot format and location (I like having every temporary file in `~/Downloads/`), etc.
