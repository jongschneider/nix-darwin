{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # herdr installs plugins imperatively into ~/.config/herdr/plugins and tracks
  # them in a machine-local plugins.json, so they don't reproduce on their own.
  # We pin each source, symlink it to a stable path, and re-link it through
  # herdr on activation so a fresh machine converges to the same set. Keys are
  # the plugin id herdr reports; values are the source dirs. repo-workspace-name
  # is a local plugin vendored in this repo; vim-herdr-navigation is fetched from
  # upstream and pinned in flake.lock (bump with `nix flake update`).
  herdrPlugins = {
    "repo-workspace-name" = ./plugins/repo-workspace-name;
    "session-picker" = ./plugins/session-picker;
    "vim-herdr-navigation" = inputs.vim-herdr-navigation;
  };
in {
  # Let lazygit and fzf keep Ctrl+h/j/k/l for themselves instead of moving herdr
  # focus (vim-herdr-navigation passthrough; anchored exact match on the process
  # name). fzf is here so Ctrl+j/k move the selection in the session-picker.sh
  # pane (and any other fzf) — fzf binds those to down/up by default.
  home.sessionVariables.HERDR_NAV_PASSTHROUGH_RE = "^(lazygit|fzf)$";

  xdg.configFile =
    {
      "herdr/config.toml" = {
        source = ./config.toml;
      };
      "herdr/session-picker.sh" = {
        source = ./session-picker.sh;
        executable = true;
      };
    }
    // lib.mapAttrs' (name: src:
      # recursive: real directory of file symlinks, so the plugin_root path stays
      # stable across nix updates and herdr can still write its own config dir.
      lib.nameValuePair "herdr/managed-plugins/${name}" {
        source = src;
        recursive = true;
      })
    herdrPlugins;

  # Register the vendored plugins with herdr. `plugin link` is idempotent and
  # writes through the server socket, so it only lands when a herdr server is
  # running. It tolerates a down server (nothing to link against yet) and simply
  # re-links on the next switch once herdr has been launched at least once.
  home.activation.herdrLinkPlugins = lib.hm.dag.entryAfter ["writeBoundary"] ''
    herdrBin=${pkgs.herdr}/bin/herdr
    for name in ${lib.concatStringsSep " " (lib.attrNames herdrPlugins)}; do
      dir="${config.xdg.configHome}/herdr/managed-plugins/$name"
      if [ -e "$dir/herdr-plugin.toml" ]; then
        if $DRY_RUN_CMD "$herdrBin" plugin link "$dir" >/dev/null 2>&1; then
          :
        else
          echo "herdr: could not link plugin '$name' (is the herdr server running?); will retry on next switch"
        fi
      fi
    done
  '';
}
