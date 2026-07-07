{...}: {
  xdg.configFile = {
    "herdr/config.toml" = {
      source = ./config.toml;
    };
    "herdr/session-picker.sh" = {
      source = ./session-picker.sh;
      executable = true;
    };
  };
}
