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
  # and session-picker are local plugins vendored in this repo; the rest are
  # fetched from upstream and pinned in flake.lock (bump with `nix flake update`).
  #
  # annotate runs its tools with `bun`, which comes from
  # environment.systemPackages in darwin/system.nix. It also needs a
  # plannotator-tui binary staged into its plugin root, which upstream does with
  # a build step we can't use — annotate.nix explains why and does it at build
  # time instead.
  herdrPlugins = {
    "repo-workspace-name" = ./plugins/repo-workspace-name;
    "session-picker" = ./plugins/session-picker;
    "vim-herdr-navigation" = inputs.vim-herdr-navigation;
    "annotate" = annotate;
  };

  annotate = import ./plugins/annotate.nix {
    inherit pkgs;
    src = inputs.herdr-annotate;
  };

  # The plugin keeps its copy as bin/plannotator-tui.exe, where only herdr looks.
  # The plannotator-tui skill tells agents to run `plannotator-tui herdr open
  # <file>` from their own pane, so put the same binary on PATH under the name
  # the skill uses.
  #
  # HERDR_PLUGIN_ID is the reason this is a wrapper and not a bare symlink. To
  # open its pane the binary asks herdr for a plugin by id, defaulting to
  # "plannotator-tui" — the id in plannotator-tui's own development manifest.
  # herdr-annotate ships it under the id "annotate" instead, so the bare command
  # fails with plugin_not_found. herdr sets the variable itself when it runs the
  # plugin's actions, which is why prefix+o never hit this; a run started from
  # an agent's own pane has to set it. Exported, not just prefixed, so the value
  # survives into the pane the binary asks herdr to spawn.
  #
  # The wrapper execs the store path in place rather than copying the binary
  # forward: it is a self-contained Rust build whose ad-hoc macOS signature does
  # not survive being rewritten.
  plannotator-tui = pkgs.writeShellScriptBin "plannotator-tui" ''
    export HERDR_PLUGIN_ID="''${HERDR_PLUGIN_ID:-annotate}"
    exec ${annotate}/bin/plannotator-tui.exe "$@"
  '';
in {
  home.packages = [plannotator-tui];

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

      # Read by the plannotator-tui binary the annotate plugin stages, not by
      # herdr, so it lives outside the herdr/ tree.
      "plannotator-tui/config.toml" = {
        source = ./plannotator-tui.toml;
      };
    }
    // lib.mapAttrs' (name: src:
      # recursive: a real directory of file symlinks rather than one symlink to
      # the store, so a plugin that looks for a sibling file finds a normal tree.
      # herdr canonicalizes herdr-plugin.toml before recording plugin_root, so
      # the root it stores is the store path either way — nothing may write there.
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
