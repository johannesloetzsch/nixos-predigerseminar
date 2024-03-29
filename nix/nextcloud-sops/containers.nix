{
  ## nextcloud-sops
  containers.nextcloud1 = rec {
    privateNetwork = true;
    hostAddress = "192.0.2.1";
    localAddress = "192.0.2.21";

    config = { config, pkgs, ... }@specialArgs:
    let
      sopsModule = if (builtins.hasAttr "sops-nix" specialArgs)
                   then specialArgs.sops-nix.nixosModules.sops
                   else "${builtins.fetchTarball "https://github.com/Mic92/sops-nix/archive/master.tar.gz"}/modules/sops";
    in {
      imports = [ sopsModule ];

      sops.age.keyFile = "/root/sops.age";
      sops.secrets."nextcloud-root-password" = {
        sopsFile = ../../sops/secrets/nextcloud/root-password;
        owner = "nextcloud";
        format = "binary";
      };

      services.nextcloud = {
        enable = true;
        hostName = "localhost";
        config = {
          #adminuser = "root";
          adminpassFile = "/run/secrets/nextcloud-root-password";
          extraTrustedDomains = [ localAddress ];
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 ];
    };
  };
}
