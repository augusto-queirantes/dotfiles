# Auto mode

How the permission classifier is configured on this machine, and why the org-specific half of it deliberately lives outside this repo.

## The constraint

`autoMode` is only honoured from three settings sources:

```js
AUTO_MODE_TRUSTED_SOURCES = ["userSettings", "flagSettings", "policySettings"]
```

`projectSettings` (`.claude/settings.json`) and `localSettings` (`.claude/settings.local.json`) are ignored, with a warning — a repo must not be able to grant itself trust. That is the right call, and it is also the problem here: `userSettings` is `~/.claude/settings.json`, which in this setup is `stow/claude/.claude/settings.json` — tracked, and in a **public** repo.

So the one file allowed to hold classifier rules is the one file that must not hold JustiFi-internal detail.

The escape hatch: all four `autoMode` arrays (`allow`, `soft_deny`, `hard_deny`, `environment`) **concatenate** across trusted sources rather than overriding. `flagSettings` is trusted and points at an arbitrary path. So the config splits cleanly in two.

## The split

| Half | File | Tracked | Holds |
| --- | --- | --- | --- |
| Generic | `stow/claude/.claude/settings.json` | yes (public) | machine-shape rules, nothing org-identifying |
| Org | `~/.claude/auto-mode.local.json` | no | JustiFi hosts, clusters, namespaces, registries, domains |

Same pattern as `~/.zshenv.local` for secrets: the wiring is public, the contents are not.

## Wiring the local overlay

1. Create the overlay from the template in the next section.
2. Add to `stow/zsh/.zshrc` near the other aliases:

```sh
# Org-specific auto-mode classifier rules — untracked, never in this repo.
claude() {
  local overlay="$HOME/.claude/auto-mode.local.json"
  if [[ -f "$overlay" ]]; then
    command claude --settings "$overlay" "$@"
  else
    command claude "$@"
  fi
}
```

3. `exec zsh`, then confirm with `/config` that the rules are loaded.

## Overlay template

Fill in only what is real; delete the rest. Every string is natural language — the classifier reads them, nothing parses them.

```json
{
  "autoMode": {
    "environment": [
      "**Organization**: justifi-tech (github.com/justifi-tech)",
      "**Cloud provider(s)**: FILL IN",
      "**Sensitive remote targets**: FILL IN — exact prod hostnames, clusters, namespaces",
      "**Trusted internal domains**: FILL IN",
      "**Internal package registry**: FILL IN",
      "**Key internal services**: FILL IN"
    ],
    "hard_deny": [
      "Any write, migration, or restart against a JustiFi production database, cluster, or namespace."
    ]
  }
}
```

## Generic half — apply by hand

Replace the last line of the existing `autoMode.environment` array in `stow/claude/.claude/settings.json` (currently `"**Org-specific CLIs**: None configured"`) and add the three rule arrays after it:

```json
      "**Org-specific CLIs**: aws, kubectl, docker, gh, stow, brew, mise — installed on this machine; no org account, cluster, or registry detail is recorded in this file (it is public). Org-specific rules load from an untracked overlay via `--settings`; see docs/auto-mode.md."
    ],
    "allow": [
      "Read-only inspection anywhere on this machine: listing files, reading source, `git log` / `git diff` / `git status`, `rg` / `fd` / `bat` / `jq`, and `gh api GET` requests.",
      "Any edit, build, test, lint, or format command scoped to files inside the git repo the session is working in.",
      "Local dev-environment management that touches only this machine's own tooling: `stow`, `brew bundle`, `mise`, `tmux`, and re-running install scripts from the trusted repo.",
      "Creating branches, staging, and committing in any repo."
    ],
    "soft_deny": [
      "Any write to `~/.claude/settings.json`, `~/.claude/settings.local.json`, or a shell rc file (`.zshrc`, `.zshenv`, `.zprofile`) — these change what future sessions are permitted to do, so they stay a manual step.",
      "`git push`, opening or merging a PR, and any other action that publishes to a remote.",
      "Uninstalling or unlinking managed tooling: `brew uninstall`, `stow -D`, `mise uninstall`, or deleting files under `~/.config` or `~/.claude`.",
      "Any command targeting a host, namespace, cluster, or container whose name carries `prod` or `production` as a whole word or name segment.",
      "Destructive git operations — force push, `--no-verify`, amending pushed commits, `reset --hard`, `clean -f`. No hook guards these; ask before running any of them."
    ],
    "hard_deny": [
      "Writing credentials, tokens, API keys, or any content read from `~/.zshenv.local`, `~/.ssh`, or `~/.aws` into the trusted repo — it is public (github.com/augusto-queirantes/dotfiles).",
      "Sending repo contents, file listings, or command output to public paste, gist, or snippet services.",
      "Recording JustiFi-internal identifiers — infrastructure names, hostnames, account IDs, cluster or namespace names, internal domains — into any file tracked by the trusted repo, since it is public."
    ]
```

## Why the generic half has no `allow` for settings writes

Writes to `~/.claude/settings.json`, `settings.local.json`, and shell rc files are under `soft_deny` on purpose. They change what *future* sessions may do, so a session that could auto-approve them could widen its own permissions. Editing them stays a manual step — which is why changes to this repo's Claude config arrive as a docs patch plus an instruction, not an applied edit.

## Re-deriving the trusted-sources list

Claude Code ships as a single binary. To re-check after an upgrade:

```sh
B=~/.local/share/claude/versions/$(readlink ~/.local/bin/claude | xargs basename)
rg -o -a 'AUTO_MODE_TRUSTED_SOURCES:\(\)=>\w+' "$B"
rg -o -a 'pgn=\[[^]]*\]' "$B"   # substitute the minified name from the line above
```
