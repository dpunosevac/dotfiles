# Migration Plan: WezTerm -> Alacritty + tmux

Goal: replace WezTerm with Alacritty (rendering) + tmux (multiplexing, sessions,
status bar). Config lives in `~/dotfiles`, deployed via `dotfiles-util.sh`, portable
to other machines. WezTerm stays installed until everything is verified, then gets
removed. Finally: Tailscale on iPad + remote access test from phone and iPad.

Why this split: Alacritty draws text fast and does nothing else. tmux owns panes,
tabs (windows), workspaces (sessions), scrollback, and the status bar. Bonus: the
same tmux session is reachable remotely via Moshi (phone/iPad), which WezTerm
could never give us.

---

## Status

- Phase 0: DONE — tmux 3.7b, Alacritty 0.17.0, JetBrainsMono Nerd Font installed
- Phase 1: DONE — configs written, symlinked, and verified (see Verified below)
- Phase 2: DONE — visual pass and all keybindings confirmed
- Phase 3: DONE — WezTerm uninstalled and purged from the repo
- Phase 4: Tailscale up; two Mac-side items left, see Phase 4

### Verified automatically

- Both config files parse; Alacritty loads `alacritty.toml` + `themes/tokyo_night.toml`
- Font `JetBrainsMono Nerd Font` style `Medium` resolves (no fallback warning)
- GPU path OK on Radeon Pro 555X, `supports_transparency: true`
- `tmux` resolves to `/usr/local/bin/tmux` in a login zsh
- Inside tmux: `TERM=tmux-256color`, 256 colors; `terminal-features` carries
  `alacritty:RGB` and `xterm-256color:RGB`
- All prefix bindings, both sticky key tables, and vi copy bindings registered
- `status-right` expands correctly (cwd basename, foreground command, clock)
- End to end: Alacritty launches, runs `zsh -lc`, and attaches session `main`
  (`tmux list-clients` shows `[103x50 alacritty]`)
- `status-left` verified against the live client in all three states: session name
  at rest, `resize` and `movetab` inside their key tables

## Phase 0: Install (WezTerm untouched)

```sh
brew install --cask alacritty
brew install tmux
brew install --cask font-jetbrains-mono-nerd-font
```

Font note: WezTerm bundles JetBrains Mono; Alacritty bundles nothing. Without the
cask font, Alacritty silently falls back to a default font. The Nerd Font variant
also covers the icons the status bar uses (WezTerm had built-in nerdfonts, tmux
needs them in the font itself).

---

## Phase 1: New dotfiles structure

```
dotfiles/
  alacritty/
    alacritty.toml
    themes/
      tokyo_night.toml
  tmux/
    tmux.conf
```

Symlink targets:

| Repo file                              | Symlink                                |
|----------------------------------------|----------------------------------------|
| `alacritty/alacritty.toml`             | `~/.config/alacritty/alacritty.toml`   |
| `alacritty/themes/`                    | `~/.config/alacritty/themes/`          |
| `tmux/tmux.conf`                       | `~/.tmux.conf`                         |

### 1a. `alacritty/alacritty.toml`

Ports the WezTerm visual settings. What maps where:

| WezTerm setting                          | Alacritty equivalent                       |
|------------------------------------------|--------------------------------------------|
| `color_scheme = "Tokyo Night"`           | `general.import` of `themes/tokyo_night.toml` |
| JetBrains Mono, scale 1.24 (~15pt)       | `font.normal` + `font.size = 15`           |
| Iosevka fallback                         | none — Alacritty has no fallback chain, macOS system fallback covers gaps |
| `window_background_opacity = 0.9`        | `window.opacity = 0.9`                     |
| `window_decorations = "RESIZE"`          | `window.decorations = "Buttonless"`        |
| `window_close_confirmation`              | not needed — tmux session survives window close anyway |
| `scrollback_lines = 3000`                | moves to tmux `history-limit` (tmux owns scrollback now) |
| everything else (keys, tabs, status)     | moves to tmux                               |

```toml
[general]
import = ["~/.config/alacritty/themes/tokyo_night.toml"]
live_config_reload = true

[window]
opacity = 0.9
decorations = "Buttonless"

[font]
size = 15.0

[font.normal]
family = "JetBrainsMono Nerd Font"
style = "Medium"

[terminal.shell]
program = "/bin/zsh"
args = ["-lc", "tmux new-session -A -s main"]
```

The `[terminal.shell]` block is the glue: every Alacritty launch attaches to the
`main` tmux session (creates it if missing) — same behavior as WezTerm
`default_workspace = "main"`, and the same session Moshi will attach to remotely.

`themes/tokyo_night.toml`: take from the official theme collection
(github.com/alacritty/alacritty-theme, file `themes/tokyo_night.toml`) and commit
it into the repo — no runtime dependency on the theme repo.

### 1b. `tmux/tmux.conf`

Everything keyboard/tabs/status from `wezterm.lua`, translated. Keybinding map
(prefix = `C-a`, same as WezTerm leader):

| Action                     | WezTerm      | tmux binding                                  |
|----------------------------|--------------|-----------------------------------------------|
| Send literal C-a           | LDR C-a      | `bind C-a send-prefix`                         |
| Copy mode                  | LDR c        | `bind c copy-mode` (rebound; default `c` was new-window) |
| Split below                | LDR s        | `bind s split-window -v -c "#{pane_current_path}"` |
| Split right                | LDR v        | `bind v split-window -h -c "#{pane_current_path}"` |
| Navigate panes             | LDR h/j/k/l  | `bind h select-pane -L` (etc.)                 |
| Close pane (confirm)       | LDR q        | `bind q confirm-before -p "kill pane? (y/n)" kill-pane` |
| Zoom pane                  | LDR z        | default, keep                                  |
| Rotate panes               | LDR o        | `bind o rotate-window`                         |
| Resize mode (sticky)       | LDR r        | `resize` key table, see below                  |
| New tab                    | LDR t        | `bind t new-window -c "#{pane_current_path}"`  |
| Prev/next tab              | LDR [ / ]    | `bind [ previous-window` / `bind ] next-window` |
| Tab navigator              | LDR n        | `bind n choose-window`                         |
| Rename tab                 | LDR e        | `bind e command-prompt -I "#W" "rename-window '%%'"` |
| Move tab mode (sticky)     | LDR m        | `movetab` key table, see below                 |
| Move tab left/right        | LDR { / }    | `bind { swap-window -d -t -1` / `bind } swap-window -d -t +1` |
| Workspace picker           | LDR w        | `bind w choose-tree -Zs` (sessions view)       |
| Tab by index               | LDR 1-9      | default with `base-index 1`                    |

Sticky key tables (WezTerm `ActivateKeyTable` with `one_shot = false`):

```tmux
bind r switch-client -T resize
bind -T resize h resize-pane -L 1 \; switch-client -T resize
bind -T resize j resize-pane -D 1 \; switch-client -T resize
bind -T resize k resize-pane -U 1 \; switch-client -T resize
bind -T resize l resize-pane -R 1 \; switch-client -T resize
bind -T resize Escape switch-client -T root
bind -T resize Enter  switch-client -T root

bind m switch-client -T movetab
bind -T movetab h swap-window -d -t -1 \; switch-client -T movetab
bind -T movetab j swap-window -d -t -1 \; switch-client -T movetab
bind -T movetab k swap-window -d -t +1 \; switch-client -T movetab
bind -T movetab l swap-window -d -t +1 \; switch-client -T movetab
bind -T movetab Escape switch-client -T root
bind -T movetab Enter  switch-client -T root
```

Rebind fallout (defaults displaced by the WezTerm-style keys):

- `c` no longer creates windows -> `t` does (matches WezTerm habit)
- `[` no longer enters copy mode -> `c` does
- `]` no longer pastes -> `bind p paste-buffer`

Core settings:

```tmux
set -g prefix C-a
unbind C-b

set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:RGB"
set -g history-limit 10000
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
set -g mouse on
set -g set-clipboard on          # OSC 52 -> works locally AND through Moshi
set -g mode-keys vi
set -g escape-time 0
set -g focus-events on
setw -g aggressive-resize on     # multi-device attach: no letterboxing
```

Dim inactive panes (WezTerm `inactive_pane_hsb` equivalent, approximation):

```tmux
set -g window-style 'fg=#787c99,bg=#16161e'
set -g window-active-style 'fg=#c0caf5,bg=#1a1b26'
```

Status bar — ports the WezTerm status: left shows session name, `LDR` while
prefix is held, key table name when in resize/movetab mode; right shows cwd
basename, current command, clock. Tokyo Night colors (`#f7768e` red, `#bb9af7`
purple, `#7dcfff` cyan, `#e0af68` yellow):

See `tmux/tmux.conf` for the final version. Two things the obvious formulation
gets wrong, both found by expanding the format against a live client:

- Comparing `client_key_table` against `root` fails when the value is empty, which
  it is in any non-client context. Test positively for `resize`/`movetab` instead.
- `client_prefix` is reported as set for *any* non-root key table, so testing it
  before the key table makes the table name unreachable — the bar would read
  `LDR` where WezTerm read `resize`. The key table has to be tested first.

```tmux
set -g status-left "#{?#{||:#{==:#{client_key_table},resize},#{==:#{client_key_table},movetab}},#[fg=#7dcfff] #{client_key_table},#{?client_prefix,#[fg=#bb9af7]#[bold] LDR,#[fg=#f7768e] #S}} #[none]#[fg=#3b4261]| "
```

`status-style` uses `bg=default` rather than a literal colour: an explicit
background makes those cells opaque and cancels Alacritty's window opacity.
The same reasoning applies to `window-style`, which sets only `fg`.

The status bar embeds Nerd Font private-use glyphs — U+F0CE (table, left
segment), U+F07B (folder), U+F121 (code), U+F017 (clock). They are invisible in
any font without Nerd Font patching, and they fail *silently* as blank space
rather than as tofu boxes, so a font change that drops them is easy to miss.
Check coverage with `fc-list ":charset=f07b" family` before switching fonts.

### 1c. `dotfiles-util.sh` changes

Add to `install()` (next to the existing Wezterm block; that block stays until
Phase 3):

```bash
if selection_prompt 'Alacritty'; then
  mkdir -p ~/.config/alacritty/
  backup_then_symlink ${DOT_DIR}/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
  backup_then_symlink ${DOT_DIR}/alacritty/themes ~/.config/alacritty/themes
fi

if selection_prompt 'Tmux'; then
  backup_then_symlink ${DOT_DIR}/tmux/tmux.conf ~/.tmux.conf
fi
```

### 1d. `homebrew/Brewfile_core` changes

Add now:

```ruby
brew "tmux"
cask "alacritty"
cask "font-jetbrains-mono-nerd-font"
```

`cask "wezterm"` stays until Phase 3.

---

## Gatekeeper, and a deadline on the Alacritty cask

First launch from Finder is blocked with *"Apple could not verify Alacritty.app is
free of malware."* The cause is not a damaged download:

- Alacritty ships **ad-hoc signed** (`Signature=adhoc`, `TeamIdentifier=not set`).
  There is no Apple Developer ID and no notarization. That is the upstream
  project's normal release state, not a sign of tampering — Homebrew verified the
  download's SHA-256 against the cask before installing it.
- `spctl -a -t exec` therefore reports `rejected`, and always will.

Unblocked by clearing the quarantine flag Homebrew attached:

```sh
xattr -d com.apple.quarantine /Applications/Alacritty.app
```

The app launches normally after that (`spctl` still says `rejected`; that is
expected and no longer matters once the quarantine attribute is gone).

**The deadline:** `brew info --cask alacritty` reports it as *deprecated because it
does not pass the macOS Gatekeeper check*, and **disabled on 2026-09-01**. After
that date the cask stops working, which breaks the portability goal — a fresh
machine running `brew bundle` against `Brewfile_core` will fail on this line, and
there will be no `brew upgrade` path for Alacritty.

**Decision: staying on Alacritty.** Consequences to handle before 2026-09-01:
the `cask "alacritty"` line in `Brewfile_core` will start failing, so it needs a
comment or removal by then, and Alacritty updates become manual (download, replace
the app, re-run the `xattr -d` above, since every fresh download is quarantined
again).

Options considered:

| Option | Cost |
|---|---|
| Stay on Alacritty | Pin the current build; manual updates, re-clear quarantine each time; `brew bundle` needs the cask line removed |
| **Ghostty 1.3.1** | Signed, notarized, auto-updating, actively developed, native macOS UI; config syntax differs from Alacritty but the tmux layer is untouched |
| kitty 0.48.2 | Signed and notarized; heavier, has its own multiplexing that would overlap tmux |

The tmux half of this migration is unaffected either way — it is the terminal
emulator underneath that would swap, and `tmux/tmux.conf` carries over verbatim.

## Phase 2: Verify (run both side by side a few days)

Checklist — all in Alacritty:

- [ ] Launch drops straight into tmux session `main`; relaunch reattaches (no duplicate sessions: `tmux ls` shows one `main`)
- [ ] Tokyo Night colors correct, `echo $TERM` is `tmux-256color`, 24-bit color works (`nvim` themes look right)
- [ ] Font renders, nerd icons in status bar render (not boxes)
- [ ] All prefix keys from the table above behave like WezTerm did
- [ ] Resize mode sticks until Escape/Enter; status shows table name
- [ ] Copy mode + mouse selection copy to macOS clipboard
- [ ] Scrollback works via prefix+c and mouse wheel
- [ ] Close Alacritty window, reopen -> session and running processes intact
- [ ] `claude` runs fine inside tmux
- [ ] Second attach from another Alacritty window doesn't letterbox (aggressive-resize)

---

## Phase 3: Remove WezTerm (only after Phase 2 all green)

Done:

1. `brew uninstall --cask wezterm` (the old app was backed up to the Caskroom)
2. Removed `~/.config/wezterm/wezterm.lua` and its directory
3. Dropped `cask "wezterm"` from `homebrew/Brewfile_core`
4. Dropped the Wezterm block from `dotfiles-util.sh` `install()`
5. Deleted `wezterm/` from the repo (git history still has it)
6. **`aerospace/aerospace.toml`** — `alt-enter` still launched WezTerm and would
   have become a dead keybinding. Now `open -a Alacritty`; config reloaded live.
7. `README.md` — the Terminal Emulator section rewritten for Alacritty + tmux,
   plus the `alt + enter` line and the casks table

A `grep -ri wezterm` over the repo returns nothing outside this plan. Changes are
left unstaged for review; nothing was committed.

---

## Phase 4: Tailscale on iPad + remote test

### Mac-side blockers (measured, all three currently fail)

1. ~~**Tailscale is stopped.**~~ FIXED — brought up with
   `tailscale up --accept-routes` (that flag was already part of this node's
   settings and had to be repeated, otherwise `tailscale up` refuses to run).
   Backend is now `Running` and the Mac reports online.
2. ~~**Remote Login is off.**~~ It is on. `launchctl list | grep sshd` is a
   misleading check — sshd is an on-demand launchd job and only appears once a
   connection is active. Verify with `lsof -nP -iTCP:22 -sTCP:LISTEN` (listening
   on tcp4 and tcp6) or `launchctl print system/com.openssh.sshd`.
3. ~~**The Mac sleeps after 1 minute on AC power.**~~ FIXED — AC profile now reads
   `sleep 0`, `displaysleep 10`, `womp 1`. The machine stays reachable while
   plugged in.

   For lid-closed operation without an external display, additionally
   `sudo pmset -a disablesleep 1` — and remember to set it back to `0` before
   running on battery, or it will never sleep in a bag.

### Mac side: validated end to end

| Check | Result |
|---|---|
| Tailscale backend | `Running`, self online at `100.124.178.90` |
| sshd | listening on tcp4 + tcp6 port 22 |
| SSH over the tailnet IP | reaches auth, offers `publickey,password,keyboard-interactive` |
| Auth available | password (no `sshd_config` override, macOS default) |
| SSH user restriction | none — `com.apple.access_ssh` has no members, so all users |
| AC sleep | `sleep 0` |
| `tmux` on a **non-interactive** SSH PATH | `/usr/local/bin/tmux` found — `/usr/local/bin` is in `/etc/paths`, so the Moshi remote command resolves |

There is no `~/.ssh/authorized_keys` yet, so the first Moshi connection uses the
account password. Key auth is Step 10 below and is optional, since port 22 is only
reachable inside the tailnet.

### Use the Tailscale IP in clients, never the short hostname

This Mac answers to the same short name from two different systems:

| Resolver | Name | Address | Reachable from |
|---|---|---|---|
| Bonjour / mDNS | `dusans-macbook-pro.local` | 192.168.1.220 | the LAN only |
| Tailscale MagicDNS | `dusans-macbook-pro.tail8facb3.ts.net` | 100.124.178.90 | anywhere |

Given a bare hostname, the client **appends `.local`**, which forces the lookup
down mDNS/Bonjour instead of MagicDNS. So `dusans-macbook-pro` becomes
`dusans-macbook-pro.local` and only ever resolves to the LAN address. The result
is a host entry that *works on home Wi-Fi and fails on cellular*: on Wi-Fi it
connects over the LAN without touching Tailscale at all, and on cellular there is
no Bonjour responder, so it fails with
`Connection failed: DNS resolution failed`. That reads like a network or firewall
problem and is not one — the tunnel is up the whole time.

**Configure clients with `100.124.178.90`.** No DNS is involved, so it behaves
identically on any network. The FQDN `dusans-macbook-pro.tail8facb3.ts.net` also
works; only the short name is ambiguous.

Confirmed working over 4G with the phone: `tailscale ping` returns
`pong from iphone-12-pro-max via DERP(fra) in 87ms`. Traffic is relayed rather
than direct (`MappingVariesByDestIP: false` on this side, but no port mapping),
which is fine for a terminal — and Mosh's local echo hides the ~85ms anyway.

### Connection details

| | |
|---|---|
| Tailnet | `tail8facb3.ts.net` |
| Mac Tailscale IP | `100.124.178.90` |
| Mac MagicDNS | `dusans-macbook-pro.tail8facb3.ts.net` (short: `dusans-macbook-pro`) |
| SSH user | `dpunosevac` |
| Remote command | `tmux new-session -A -s main` |

Devices already on the tailnet: the Mac, and `iphone-12-pro-max` (registered, last
seen 5 days ago — it only needs its VPN toggle switched back on, not a fresh setup).
The iPad is **not** enrolled yet.

iPad:

1. App Store -> Tailscale -> log in with the same account as the Mac -> VPN toggle ON
2. App Store -> Moshi -> add host: Mac's Tailscale IP / MagicDNS name, port 22, macOS username
3. Moshi remote command: `tmux new-session -A -s main`
4. Connect -> should land in the SAME session Alacritty uses on the Mac

Test matrix:

| Test                                        | Phone | iPad |
|---------------------------------------------|-------|------|
| Connect over home Wi-Fi                     |  [ ]  | [ ]  |
| Connect over cellular / different network   |  [ ]  | [ ]  |
| Attach shows same session as Mac (run `ls` on Mac, see it remotely) | [ ] | [ ] |
| Lock device 2 min, unlock -> session resumes|  [ ]  | [ ]  |
| Start `claude` from device, detach, verify still running from Mac | [ ] | [ ] |
| Q1 HE paired to iPad: prefix keys work in tmux | n/a | [ ]  |

Multi-device note: simultaneous attach from Mac + iPad is fine with
aggressive-resize; if a smaller client ever pins the view, attach with
`tmux attach -d -t main` to kick other clients.

---

## Rollback

Any point before Phase 3: just keep using WezTerm, nothing was touched.
After Phase 3: `brew install --cask wezterm`, restore `dotfiles/wezterm/` from git
history, re-add the symlink. Cheap either way.
