# Repo Template

Starting point for new Ecosystem Admin repositories. It holds the files every project needs and the script that applies the organization's conventions to GitHub.

## Starting a new project

1. Create the repository from this template.
2. Run `scripts/bootstrap.sh [owner/repo]` to apply labels, repository settings and the `main` ruleset (needs `gh` and `jq`).
3. Fill in the project description in `CLAUDE.md` and replace this README.

## What's included

- `CLAUDE.md`: guidance for AI agents, with the shared conventions
- `scripts/labels.json`: label definitions
- `scripts/sync-labels.sh`: creates or updates the labels on a repository
- `scripts/ruleset-main.json`: the `main` protection ruleset
- `scripts/bootstrap.sh`: applies labels, settings and the ruleset in one go

CONTRIBUTING and the issue and pull request templates come from the organization's [`.github`](https://github.com/ecosystem-admin/.github) repository, so they aren't copied here.
