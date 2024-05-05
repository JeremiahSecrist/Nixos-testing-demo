{
  config,
  lib,
  pkgs,
  ...
}: {
  myCaddy.enable = true;
  system.stateVersion = "24.05";
  boot.loader.grub.devices = ["/dev/disk/by-diskseq/1"];
  fileSystems."/" = {
    device = "/dev/disk/by-diskseq/1";
    fsType = "ext4";
  };
}
