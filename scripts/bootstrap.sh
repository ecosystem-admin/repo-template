#!/usr/bin/env bash
#
# Apply the Ecosystem Admin repository conventions to a GitHub repository:
#   - labels (scripts/labels.json)
#   - repository settings: squash commit uses the PR title and body,
#     head branches are deleted after merge
#   - the "main protection" ruleset (scripts/ruleset-main.json)
#
# Safe to run more than once: labels and the ruleset are created or updated.
# Other labels and rulesets are left alone.
#
# Usage: scripts/bootstrap.sh [owner/repo]
#   Without an argument, the repository of the current directory is used.
#
# Requires: gh (authenticated, with admin access to the repository) and jq.

set -euo pipefail

dir="$(cd "$(dirname "$0")" && pwd)"
repo="${1:-$(gh repo view --json nameWithOwner --jq .nameWithOwner)}"

echo "Bootstrapping $repo"

echo "Syncing labels"
"$dir/sync-labels.sh" "$repo"

echo "Updating repository settings"
gh api "repos/$repo" --method PATCH --silent \
  -F delete_branch_on_merge=true \
  -F allow_squash_merge=true \
  -f squash_merge_commit_title=PR_TITLE \
  -f squash_merge_commit_message=PR_BODY

echo "Applying ruleset"
ruleset_file="$dir/ruleset-main.json"
ruleset_name="$(jq -r .name "$ruleset_file")"
ruleset_id="$(gh api "repos/$repo/rulesets" --jq ".[] | select(.name == \"$ruleset_name\") | .id")"
if [[ -n "$ruleset_id" ]]; then
  gh api "repos/$repo/rulesets/$ruleset_id" --method PUT --input "$ruleset_file" --silent
else
  gh api "repos/$repo/rulesets" --method POST --input "$ruleset_file" --silent
fi

echo "Done"
