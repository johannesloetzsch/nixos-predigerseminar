# Nixos Predigerseminar

Example Nixos-setups based on [nixos-containers](https://github.com/johannesloetzsch/containers).

## Install

Using `NixOS ≥ 21.11`, the host system only requires one config option to run the examples from this repo:

```nix
programs.extra-container.enable = true;
```

For other systemd-based Linux distros: [RTFM](https://github.com/erikarvstedt/extra-container#install) ;)


## Examples

### Nextcloud

#### [nextcloud-simple-insecure](./nix/nextcloud-simple-insecure)

Minimal Nextcloud setup based on [https://nixos.wiki/wiki/Nextcloud](https://nixos.wiki/wiki/Nextcloud).

This trivial setup contains a cleartext admin-password in the configuration 🤦

```bash
nix run .#buildContainer_nextcloud0
# or
nix run github:johannesloetzsch/nixos-predigerseminar#buildContainer_nextcloud0
```

[http://192.0.2.20](http://192.0.2.20)

User: `root`

Password: `nix`
