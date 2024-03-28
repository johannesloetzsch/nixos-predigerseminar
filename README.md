# Nixos Predigerseminar

Example Nixos-setups based on [nixos-containers](https://github.com/johannesloetzsch/containers).

## Install

Using `NixOS ≥ 21.11`, the host system only requires one config option to run the examples from this repo:

```nix
programs.extra-container.enable = true;
```

For other systemd-based Linux distros: [RTFM](https://github.com/erikarvstedt/extra-container#install) ;)


## Usage

### Ephemeral

Using `nix run .#buildContainer_$NAME` starts the container and provides an interactive shell, allowing to run commands in the container.
Once the shell is closed, the container will be stopped and it's state will be deleted.


```bash
nix run .#buildContainer_$NAME
```

### Persistant

To create a persistant container, use `nix run .#buildContainer_$NAME -- create --start`.

To create all defined containers, you can use:


```bash
nix run . -- create --start
```

The state of the created machines will be stored at `/var/lib/nixos-containers`.

You can control the machines with `machinectl`:


```bash

machinectl list

machinectl start $NAME
machinectl poweroff $NAME

machinectl --help
```

For other features of `extra-container` see:

```bash
nix run . -- --help
```


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
