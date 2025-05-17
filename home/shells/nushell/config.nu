# env-vars
source ~/.config/nushell/style.nu
$env.PATH = $env.PATH
| split row (char esep)
| append '/usr/local/bin'
| append ($env.HOME | path join ".elan" "bin")
| append ($env.HOME | path join ".cargo" "bin")
| prepend ($env.HOME | path join ".local" "bin")
| uniq
$env.FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git --exclude .cache --max-depth 9"
$env.CARAPACE_LENIENT = 1
$env.CARAPACE_BRIDGES = 'zsh'
$env.MANPAGER = "col -bx | bat -l man -p"
$env.MANPAGECACHE = ($nu.default-config-dir | path join 'mancache.txt')
$env.RUST_BACKTRACE = 1

use /home/jr/flake/home/shells/nushell/fzf.nu [
  carapace_by_fzf
  complete_line_by_fzf
  update_manpage_cache
  atuin_menus_func
]
use /home/jr/flake/home/shells/nushell/sesh.nu sesh_connect
source /home/jr/flake/home/shells/nushell/themes/tokyonight_night.nu

# Source Starship initialization
source ~/.cache/starship/init.nu

$env.config.completions.external.completer = {|span| carapace_by_fzf $span }
$env.config.edit_mode = "vi"
$env.config.highlight_resolved_externals = true
$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 10000
$env.config.show_banner = false
$env.config.table.header_on_separator = true
$env.config.table.index_mode = 'auto'
$env.config.render_right_prompt_on_last_line = true

$env.config.cursor_shape = {
  vi_insert: line
  vi_normal: block
}

$env.config.explore = {
  status_bar_background: {bg: $extra_colors.explore_bg fg: $extra_colors.explore_fg}
  command_bar_text: {fg: $extra_colors.explore_fg}
  highlight: {fg: "black" bg: "yellow"}
  status: {
    error: {fg: "white" bg: "red"}
    warn: {}
    info: {}
  }
  selected_cell: {bg: light_blue fg: "black"}
}

$env.config.menus ++= [
  {
    name: my_history_menu
    only_buffer_difference: false
    marker: ' '
    type: {layout: ide}
    style: {}
    source: (atuin_menus_func ' ')
  }
  {
    name: completion_menu
    only_buffer_difference: false
    marker: " "
    type: {
      layout: columnar
      columns: 4
      col_width: 20
      col_padding: 2
    }
    style: {
      text: $extra_colors.menu_text_color
      selected_text: {attr: r}
      description_text: yellow
      match_text: {attr: u}
      selected_match_text: {attr: ur}
    }
  }
  {
    name: history_menu
    only_buffer_difference: false
    marker: " "
    type: {
      layout: list
      page_size: 30
    }
    style: {
      text: $extra_colors.menu_text_color
      selected_text: light_blue_reverse
      description_text: yellow
    }
  }
]

$env.config.keybindings ++= [
  {
    name: history_menu
    modifier: control
    keycode: char_h
    mode: [emacs vi_insert vi_normal]
    event: {send: menu name: my_history_menu}
  }
  {
    name: sesh
    modifier: control
    keycode: char_s
    mode: [emacs vi_insert vi_normal]
    event: {
      send: executehostcommand
      cmd: sesh_connect
    }
  }
  {
    name: vicmd_history_menu
    modifier: shift
    keycode: char_k
    mode: vi_normal
    event: {send: menu name: my_history_menu}
  }
  {
    name: cut_line_to_end
    modifier: control
    keycode: char_k
    mode: [emacs vi_insert]
    event: {edit: cuttoend}
  }
  {
    name: cut_line_from_start
    modifier: control
    keycode: char_u
    mode: [emacs vi_insert]
    event: {edit: cutfromstart}
  }
  {
    name: fuzzy_complete
    modifier: control
    keycode: char_t
    mode: [emacs vi_normal vi_insert]
    event: {
      send: executehostcommand
      cmd: complete_line_by_fzf
    }
  }
]

# load scripts
use /home/jr/flake/home/shells/nushell/scripts/extractor.nu extract
use /home/jr/flake/home/shells/nushell/auto-pair.nu *
set auto_pair_keybindings
use /home/jr/flake/home/shells/nushell/matchit.nu *
set matchit_keybinding
source /home/jr/flake/home/shells/nushell/zoxide.nu
source /home/jr/flake/home/shells/nushell/nix.nu
source /home/jr/flake/home/shells/nushell/atuin.nu

# alias
alias vim = nvim
alias boc = brew outdated --cask --greedy
alias ll = ls -al
alias c = zi
alias less = less -R
