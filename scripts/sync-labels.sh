#!/usr/bin/env bash
#
# Create or update the labels defined in labels.json on a GitHub repository.
# Existing labels with the same name are updated; other labels are left alone.
#
# Usage: scripts/sync-labels.sh [owner/repo]
#   Without an argument, the repository of the current directory is used.
#
# Requires: gh (authenticated) and jq.

set -euo pipefail

labels_file="$(dirname "$0")/labels.json"
repo_args=()
if [[ $# -gt 0 ]]; then
  repo_args=(--repo "$1")
fi

jq -r '.[] | [.name, .color, .description] | @tsv' "$labels_file" |
  while IFS=$'\t' read -r name color description; do
    gh label create "$name" --color "$color" --description "$description" --force "${repo_args[@]}"
  done
