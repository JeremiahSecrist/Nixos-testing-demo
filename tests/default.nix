{
  pkgs,
  nixosModules,
  ...
}:
pkgs.testers.runNixOSTest {
  name = "test-name";
  nodes = {
    # we bring in the relevant modules and configurations needed to test as a full functioning system
    # do note some options involving hardware are ignored here to make the vm work
    myNixos = {
      # pkgs,
      # config,
      # lib,
      ...
    }: {
      # the same as the real nixos config more or less
      imports = with nixosModules; [
        myCaddy
        myNixos
      ];
    };
  };
  # This section we run validation on the running environment
  # We usually want to wait for default.target as most services wait for it
  # systemctl is-active --quiet caddy.service" should pass given our current config
  testScript = {
    # nodes,
     ...
    }: ''
    myNixos.wait_for_unit("default.target")
    myNixos.succeed("systemctl is-active --quiet caddy.service")
  '';
}
