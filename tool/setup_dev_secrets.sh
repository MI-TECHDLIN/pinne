#!/usr/bin/env bash
# Creates pinne_server/config/passwords.yaml and pinne_server/.env with fresh
# random development secrets. Refuses to overwrite existing files unless
# --force is given. Neither file is committed.
# Optional provider keys such as geminiApiKey and SMTP remain commented;
# add them only to the generated private passwords.yaml. Demo-account
# passwords are randomized along with the other development/test secrets.
set -euo pipefail

server_dir="$(cd "$(dirname "$0")/../pinne_server" && pwd)"
example="$server_dir/config/passwords.yaml.example"
passwords="$server_dir/config/passwords.yaml"
env_file="$server_dir/.env"

if [[ "${1:-}" != "--force" ]] && [[ -e "$passwords" || -e "$env_file" ]]; then
  echo "passwords.yaml or .env already exists; rerun with --force to replace." >&2
  exit 1
fi

random_secret() {
  head -c 32 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c 32
}

db_password="$(random_secret)"
tmp="$(mktemp)"
section=""
while IFS= read -r line || [[ -n "$line" ]]; do
  if [[ "$line" =~ ^([a-z]+):[[:space:]]*$ ]]; then
    section="${BASH_REMATCH[1]}"
  fi
  if [[ "$line" == *"<random>"* ]]; then
    if [[ "$section" == "development" && "$line" =~ ^[[:space:]]+database: ]]; then
      value="$db_password"
    else
      value="$(random_secret)"
    fi
    line="${line/<random>/$value}"
  fi
  printf '%s\n' "$line" >>"$tmp"
done <"$example"

mv "$tmp" "$passwords"
chmod 600 "$passwords"
printf 'PINNE_DEV_DB_PASSWORD=%s\n' "$db_password" >"$env_file"
chmod 600 "$env_file"
echo "Wrote $passwords and $env_file"
