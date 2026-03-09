# Infra

Ansible playbook for (crudely) configuring machines in my homelab.

### Requirements

* Needs passlib for adguard role
* Run `just reqs` to install additional roles/collections

### Usage

After cloning run `scripts/git-init.sh` or `just init` to configure a pre-commit
hook to hopefully avoid committing secrets!

#### Vault password
Vault password lookup is handled by `vault-pass.sh` it will check for the
following:

* A .vault-password file containing the password
* A `$OP_ANSIBLE_VAULT_PASSWORD_REF` env variable containing an `op://`
  reference
* A `$BW_ANSIBLE_VAULT_PASSWORD_ITEM` env variable containing an `id` or string
  for a BitWarden object

Environment variables can be set using a .env file which mise will load
