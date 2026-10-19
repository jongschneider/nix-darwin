{
  config,
  lib,
  pkgs,
  ...
}: let
  footswitch = {
    vendor_id = 13651;
    product_id = 45057;
  };

  footswitchRule = {
    # Matches any key so it works regardless of what the pedal is programmed to send.
    description = "PCsensor FootSwitch pedal sends control+delete_or_backspace (Handy dictation)";
    manipulators = [
      {
        type = "basic";
        from = {
          any = "key_code";
          modifiers = {optional = ["any"];};
        };
        to = [
          {
            key_code = "delete_or_backspace";
            modifiers = ["left_control"];
          }
        ];
        conditions = [
          {
            type = "device_if";
            identifiers = [footswitch];
          }
        ];
      }
    ];
  };

  # The pedal reports itself as a keyboard and a mouse, and Karabiner leaves
  # such combo devices unmodified by default, so the rule would never fire.
  footswitchDevices =
    map (isPointing: {
      identifiers =
        footswitch
        // {
          is_keyboard = true;
          is_pointing_device = isPointing;
        };
      ignore = false;
    })
    [true false];
in
  lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    xdg.configFile = {
      "karabiner/assets/complex_modifications/nix.json".text = builtins.toJSON {
        title = "CapsLock and Escape modifiers - Nix managed";
        rules = [
          {
            description = ''
              Change caps_lock to left_control if pressed with other keys,
              change caps_lock to escape if pressed alone.
            '';
            manipulators = [
              {
                type = "basic";
                from = {
                  key_code = "caps_lock";
                  modifiers = {optional = ["any"];};
                };
                to = [
                  {key_code = "left_control";}
                ];
                to_if_alone = [
                  {key_code = "escape";}
                ];
              }
            ];
          }
          {
            description = "Toggle caps_lock by pressing escape";
            manipulators = [
              {
                type = "basic";
                from = {
                  key_code = "escape";
                  modifiers = {optional = ["any"];};
                };
                to = [
                  {key_code = "caps_lock";}
                ];
              }
            ];
          }
          footswitchRule
        ];
      };
    };

    # karabiner.json stays writable so the Karabiner UI keeps working; this
    # merges just the foot pedal's rule and device settings into the selected
    # profile on every switch, so a fresh machine needs no manual setup.
    home.activation.karabinerFootswitch = lib.hm.dag.entryAfter ["writeBoundary"] ''
      f="${config.xdg.configHome}/karabiner/karabiner.json"
      if [ -z "''${DRY_RUN:-}" ]; then
        if [ ! -s "$f" ]; then
          mkdir -p "$(dirname "$f")"
          echo '{"profiles":[{"name":"Default profile","selected":true}]}' > "$f"
        fi
        new=$(${pkgs.jq}/bin/jq \
          --argjson rule ${lib.escapeShellArg (builtins.toJSON footswitchRule)} \
          --argjson devs ${lib.escapeShellArg (builtins.toJSON footswitchDevices)} \
          '.profiles |= map(if .selected then
             .devices = ([(.devices // [])[]
                          | select(.identifiers.vendor_id != $devs[0].identifiers.vendor_id
                                   or .identifiers.product_id != $devs[0].identifiers.product_id)] + $devs)
             | .complex_modifications.rules = ([$rule] + [(.complex_modifications.rules // [])[]
                                                          | select(.description != $rule.description)])
           else . end)' "$f")
        if [ "$new" != "$(cat "$f")" ]; then
          printf '%s\n' "$new" > "$f"
        fi
      fi
    '';
  }
