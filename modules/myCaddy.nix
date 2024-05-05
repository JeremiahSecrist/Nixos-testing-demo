{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.myCaddy;
in {
  options.myCaddy = {
    enable = mkEnableOption "enables personal config for caddy";
  };
  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      virtualHosts."localhost".extraConfig = ''
        respond "Hello, world!"
      '';
    };
  };
}
