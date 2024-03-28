{
  ## nextcloud-simple-insecure
  containers.nextcloud0 = rec {
    privateNetwork = true;
    hostAddress = "192.0.2.1";
    localAddress = "192.0.2.20";

    config = { pkgs, ... }: {
      environment.etc."nextcloud-admin-pass".text = "nix";  ## insecure!!!

      services.nextcloud = {
        enable = true;
        #package = pkgs.nextcloud28;
        hostName = "localhost";
        config = {
          #adminuser = "root";
          adminpassFile = "/etc/nextcloud-admin-pass";
          extraTrustedDomains = [ localAddress ];
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 ];
    };
  };
}
