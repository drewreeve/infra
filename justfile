#!/usr/bin/env -S just --justfile

# List available tasks
default:
    just --list

# Setup pre-commit hook to ensure secrets.yml is encrypted
init:
  #!/usr/bin/env bash
  if [ -d .git/ ]; then
    rm .git/hooks/pre-commit
    cp -v scripts/hooks/pre-commit .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
  fi

dns args='':
  ansible-playbook dns.yml {{args}}

# Run playbook
run args='':
  ansible-playbook run.yml {{args}}

# just vault (encrypt/decrypt/edit/view)
vault ACTION:
  ansible-vault {{ACTION}} group_vars/secrets.yml

# optionally use --force to force reinstall all requirements
reqs *FORCE:
	ansible-galaxy install -r requirements.yml {{FORCE}}
