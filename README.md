# NixOS Predigerseminar

Example NixOS-setups based on [nixos-containers](https://github.com/johannesloetzsch/containers).

![church of nixos logo](.img/church-of-nixos.png)


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

machinectl shell $NAME
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

#### [nextcloud-sops](./nix/nextcloud-sops)

This setups differs from `nextcloud-simple-insecure` by using an [sops-encrypted](./sops/README.md) password 🤩

Only the users and hosts with the keys defined at `.sops.yaml` are able to decrypt `sops/secrets/nextcloud/root-password`.

To use this example:
```bash
## 1. create your own key
mkdir -p ~/.config/sops/age
nix shell nixpkgs#age --run age-keygen -o ~/.config/sops/age/keys.txt

## 2. copy it to the container
sudo cp ~/.config/sops/age/keys.txt /var/lib/nixos-containers/nextcloud1/root/sops.age

## 3. add the public key to `.sops.yaml`

## 4. change and reencrypt the password file
nix run nixpkgs#sops sops/secrets/nextcloud/root-password
```


```bash
nix run .#buildContainer_nextcloud1
# or
nix run github:johannesloetzsch/nixos-predigerseminar#buildContainer_nextcloud1
```

[http://192.0.2.21](http://192.0.2.21)

#### [nextcloud-apps](./nix/nextcloud-sop)

Like [nextcloud-sops](#nextcloud-sops), but with some Nextcloud-Apps.

This configuration shows, how to use arbitrary Apps from the [Nextcloud App Store](https://apps.nextcloud.com).

For this demo we use nextcloud as a `Solid pod server` 🤩


```bash
nix run .#buildContainer_nextcloud2
# or
nix run github:johannesloetzsch/nixos-predigerseminar#buildContainer_nextcloud2
```

[http://192.0.2.22/apps/solid](http://192.0.2.22/apps/solid)
