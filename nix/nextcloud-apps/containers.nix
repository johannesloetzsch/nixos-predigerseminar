{
  ## nextcloud-apps
  containers.nextcloud2 = rec {
    privateNetwork = true;
    hostAddress = "192.0.2.1";
    localAddress = "192.0.2.22";

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

        extraAppsEnable = true;
        autoUpdateApps.enable = true;
        extraApps = {
          inherit (config.services.nextcloud.package.packages.apps)
                  contacts calendar tasks deck bookmarks;
          solid = pkgs.fetchNextcloudApp {
            sha256 = "sha256-KxcBG2xTxWgRKBcgTajBRHEFf9iXtlrvkPzgxdQ8ZlE=";
            url = "https://github.com/pdsinterop/solid-nextcloud/releases/download/v0.8.1/solid-0.8.1.2.tar.gz";
            license = "agpl3";
          };
          timemanager = pkgs.fetchNextcloudApp {
            sha256 = "sha256-OvDyuiWR1/Cv4yPYgfnwxjnD+7a58ENSXRjxfNHfT3A=";
            url = "https://github.com/te-online/nextcloud-app-releases/raw/main/timemanager/v0.3.13/timemanager.tar.gz";
            license = "agpl3";
          };
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 ];
    };
  };
}
