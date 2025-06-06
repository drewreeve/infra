#!/usr/bin/env bash

# Setup pre-commit hook to ensure secrets.yml is encrypted
if [ -d .git/ ]; then
  rm .git/hooks/pre-commit
  cp -v scripts/hooks/pre-commit .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit
fi
