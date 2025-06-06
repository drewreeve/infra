#!/usr/bin/env -S just --justfile

# Setup pre-commit hook to ensure secrets.yml is encrypted
init:
  #!/usr/bin/env bash
  if [ -d .git/ ]; then
    rm .git/hooks/pre-commit
    cp -v scripts/hooks/pre-commit .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
  fi

  # Run playbook
run:
  ansible-playbook run.yml

# just vault (encrypt/decrypt/edit/view)
vault ACTION:
  ansible-vault {{ACTION}} group_vars/secrets.yml
