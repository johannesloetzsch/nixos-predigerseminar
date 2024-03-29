## [Add keys](https://github.com/Mic92/sops-nix#usage-example)

Write the public keys into `.sops.yaml`

Generation of new keypairs:

### host from ssh-key

```bash
ssh-keyscan localhost | nix run nixpkgs#ssh-to-age > sops/keys/hosts/${HOSTNAME}.age
```

### user (or host)

```bash
mkdir -p ~/.config/sops/age
nix shell nixpkgs#age --run age-keygen -o ~/.config/sops/age/keys.txt
```


After adding adding/deleting keys, you want reencrypt your secrets:

```bash
nix run nixpkgs#sops -- updatekeys sops/secrets/$FILE
```


## Edit secrets

```bash
# e.g.
nix run nixpkgs#sops sops/secrets/$FILE
```


## Further reading

Have a look at the wonderful [official documentation](https://github.com/Mic92/sops-nix)…
