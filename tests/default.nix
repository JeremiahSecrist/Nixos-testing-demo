{
  pkgs,
  nixosModules,
  ...
}:
pkgs.testers.runNixOSTest {
  name = "test-name";
  nodes = {
    myNixos = {
      pkgs,
      config,
      lib,
      ...
    }: {
      imports = [
        nixosModules.myCaddy
        nixosModules.myNixos
      ];
    };
  };
  testScript = {nodes, ...}: ''
    myNixos.wait_for_unit("default.target")
    myNixos.succeed("systemctl is-active --quiet caddy.service")
  '';
}
