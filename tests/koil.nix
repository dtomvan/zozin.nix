let
  httpPort = 80;
  websocketPort = 6970;
in
{
  name = "koil";

  nodes = {
    server =
      {
        config,
        pkgs,
        ...
      }:
      {
        imports = [ ../nixos-modules/koil.nix ];
        services.koil.enable = true;
        services.koil.port = httpPort;

        networking.firewall.allowedTCPPorts = [
          httpPort
          websocketPort
        ];
        networking.firewall.allowedUDPPorts = [ websocketPort ];
      };
    client =
      {
        config,
        pkgs,
        ...
      }:
      {
        imports = [ ../nixos-modules/koil.nix ]; # not used but eval will complain when removed
        environment.systemPackages = with pkgs; [
          curl
          websocat
          htmlq
        ];
      };
  };

  testScript = # python
    ''
      @polling_condition
      def koil_running():
          server.succeed("pgrep -x koil-server")

      start_all()

      with subtest("koil starts"):
          server.wait_for_unit("koil.service")
          server.wait_until_succeeds("pgrep -x koil-server")

          server.wait_for_open_port(${toString httpPort})
          # cannot do this or it'll break koil.... nice
          # server.wait_for_open_port(${toString websocketPort})

      with koil_running: # type: ignore[union-attr]
          with subtest("koil has a http endpoint serving an HTML canvas"):
              result = client.succeed("curl http://server:${toString httpPort}/ | htmlq canvas")
              assert "<canvas" in result

          # send nothing, but check if this is in fact a websocket
          # Let's not re-create Tsoding's entire message system here...
          with subtest("koil has a websocket endpoint"):
              client.succeed("websocat -q -uU ws://server:${toString websocketPort}/")
    '';
}
