{...}: {
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
      ];
    };
  };
}
