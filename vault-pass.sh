#!/usr/bin/env bash

set -euo pipefail

print_password() {
  printf '%s\n' "$1"
  exit 0
}

try_plaintext_file() {
  local password_file
  password_file="${ANSIBLE_VAULT_PASSWORD_FILE_PATH:-.vault-password}"

  local password
  password="$(cat "$password_file" 2>/dev/null)" || return 1

  if [ -n "$password" ]; then
    print_password "$password"
  fi

  printf 'Vault password file exists but is empty: %s\n' "$password_file" >&2
  exit 1
}

try_1password() {
  local secret_ref
  secret_ref="${OP_ANSIBLE_VAULT_PASSWORD_REF:-op://Private/ansible-vault/password}"

  if ! command -v op >/dev/null 2>&1; then
    return 1
  fi

  local password
  if password="$(op read "$secret_ref" 2>/dev/null)" && [ -n "$password" ]; then
    print_password "$password"
  fi
  return 1
}

try_bitwarden() {
  local item
  item="${BW_ANSIBLE_VAULT_PASSWORD_ITEM:-}"

  if [ -z "$item" ]; then
    return 1
  fi

  if ! command -v bw >/dev/null 2>&1; then
    return 1
  fi

  local password
  if password="$(bw get password "$item" 2>/dev/null)" && [ -n "$password" ]; then
    print_password "$password"
  fi
  return 1
}

try_plaintext_file || true
try_1password || true
try_bitwarden || true

printf '%s\n' \
  "No vault password source resolved. Use .vault-password, 1Password, Bitwarden, or run Ansible with --ask-vault-pass." >&2
exit 1
