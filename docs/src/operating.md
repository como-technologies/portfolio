# Operating the suite

How to stand the whole TAPS suite up from a cold checkout and verify it, in
three widening rings — then the end-to-end engagement demo. Everything here
runs locally; nothing is pushed.

## Prerequisites

The suite is a set of sibling repositories that resolve each other by the
uniform convention (each repo's ADR records it): an explicit `COMO_<REPO>_DIR`
env override, else a sibling checkout `../<repo>`, else a pinned git clone into
a gitignored cache. The simplest layout is all repos checked out under one
parent (`assessments`, `adroit`, `conduit`, `tuesday`, `pulse`, `playbook`,
`portfolio`) — then everything resolves with no configuration. Each app's ADR
corpus ships **inside its own published mdbook source** at the suite's uniform
`docs/src/adr/` path, so the truthfulness gate in Ring 2 finds it in
any checkout — no separate corpus download.

**Toolchain.** A Rust toolchain with `cargo`, `just`, and `mdbook`; `git`;
Docker with its daemon up and the `docker compose` plugin (the Adopt demo runs a
throwaway Gitea forge in it); `gh` is optional (GitHub read-only legs). The AI
lanes are **optional**: only the demo's `--live` variants call a local `ollama`
serving `llama3.2` (no API key, nothing phones home) — the pre-baked fast path
needs neither. conduit builds its pinned adroit itself with `just init-adroit`.

Verify the demo's runtime prerequisites (and pull the model, if `ollama` is
installed and you want the live lanes) with one command:

```sh
conduit/demo/kit/preflight        # checks docker; pulls llama3.2 if ollama is up
```

**Commit signing.** Nothing here asks you to change your git config. The suites
that spin up throwaway git repos in their tests disable commit signing *in those
disposable repos*, so a global `commit.gpgsign = true` (with no key for the
throwaway identity) can't fail them.

**Sandbox-external inputs.** Two inputs resolve from outside a single
checkout; where one is absent the gate and the demo **skip or stop with a
notice that names the knob**, never silently:

- the **run-evidence ledger** (`COMO_DOCS_DIR`, else a sibling `../docs`) that
  the per-run pages and `just refresh-evidence` read — so the run-evidence
  claims below verify only where the ledger is checked out;
- the **playbook** corpus the Adopt demo seeds onto the throwaway forge (the
  fictional client's decisions). It is published at
  [como-technologies/playbook](https://github.com/como-technologies/playbook),
  so a sibling `../playbook` clone resolves it like any other suite repo;
  `COMO_PLAYBOOK_DIR` and `COMO_GIT_BASE` / `COMO_PLAYBOOK_GIT` remain as
  overrides.

## Ring 1 — each app on its own

Run the house gate in each repo:

```sh
just ci      # fmt + clippy + tests + book build + ADR-corpus check, per repo
```

Every repo's gate validates its ADR corpus: the five Rust apps each carry an
`adr-check` leg in `just ci`, and the playbook — a corpus, not a Rust app —
gates its content scan, corpus/index validation (`check`), and book build
instead of code legs. Green in all of them means each app is internally
sound — the Rust apps formatted, lint-clean, and tested; every mdbook builds;
every corpus validates. This is the per-app truth check and the fastest
signal.

The Rust repos also gate dependency advisories with `cargo audit` — a
`crate-audit` leg in `just ci` (conduit runs it as a dedicated CI job
instead). A red audit on a cold checkout is not automatically a code
failure: a freshly published advisory reddens an unchanged tree. Accepted
advisories live in each repo's `.cargo/audit.toml` as dated, documented
ignores (what was accepted, why, and the removal trigger), so a new red is
a decision to make — update the dependency or record the acceptance there —
never a reason to bypass the gate.

## Ring 2 — does the suite still cohere

```sh
cd portfolio && just ci
```

That runs `scripts/verify-claims` — assertions that pin *this book's* claims
against every sibling repo's actual reality: the conduit→tuesday contract
strings against `conduit/src/contract.rs`, every CLI invocation the book quotes
against the real `--help`, the forge-neutrality claim against the adapters
conduit actually offers, each maturity badge against its repo's ADR corpus and
the intro table, and each run-evidence page against the captured artifacts. A
red here means the book and a sibling disagree — fix one of them, never the
gate. This is the single command that answers "do the apps still agree with
each other." (See [How this book stays true](./truthfulness.md).)

## Ring 3 — the whole loop, live, end to end

The customer demo kit stands the entire engagement up against a throwaway
forge, runs all four loop stages with machine evidence at each seam, and tears
everything down:

```sh
cd conduit
demo/kit/preflight               # verify docker (+ pull llama3.2 for --live)
just init-adroit                 # build the pinned adroit into .conduit/bin
demo/kit/demo-up                 # throwaway Gitea + seeded playbook + all binaries
demo/kit/beat-1-measure-prior    # pulse's prior-iteration signal
demo/kit/beat-2-assess           # brief + signal -> assessment   (--live for ollama)
demo/kit/beat-3-prescribe        # assessment -> accepted ADR + stored plan  (--live)
demo/kit/beat-4-adopt            # stored plan -> human-gated PR -> merge -> verify 6/6
demo/kit/beat-5-measure          # tuesday --strict + Adopt<->Measure cross-check
demo/kit/demo-down               # destroys the forge; leaves nothing
```

`init-adroit` resolves the pinned adroit by the suite convention — the adroit
remote at the pinned rev (reachable there today), else a sibling `../adroit`
when the remote is unreachable (its HEAD, with a loud local-dev notice, if
that checkout lacks the exact pin). `demo-up` resolves the playbook and the sibling
binaries the same way and seeds the throwaway forge; it stops early with named
knobs if Docker isn't up or no playbook resolves (run `preflight` first).

Each beat prints its talking point and the machine evidence it just produced
(verify 6/6, byte-identical forge transcripts, `CROSS-CHECK PASS`). The
pre-baked path runs every beat in seconds and needs only Docker; `--live`
recomputes the two ollama lanes for real (timings in the [customer demo](https://github.com/como-technologies/conduit)
kit's narrated page). Deeper conformance is env-gated: `CONDUIT_E2E_GITEA=1`
(live forge), `CONDUIT_E2E_ADROIT=1`, `CONDUIT_E2E_GITHUB=1`.

## The pre-review cold gate — `scripts/cold-sim`

The three rings above are what a cold reviewer runs; `scripts/cold-sim` (in
this repo) rehearses exactly that before a review, as one command. It clones
the suite side by side into a fresh sandbox and runs the runbook verbatim
under a contributor-default environment a warm workspace never exercises: a
hostile global git config (`commit.gpgsign = true` with a throwaway
identity, `/dev/null` system config) and every `COMO_*` knob scrubbed from
the child environment.

```sh
portfolio/scripts/cold-sim                            # all three rings, fresh /tmp sandbox
portfolio/scripts/cold-sim --ring 3 --leg preflight   # stepwise: one ring, one leg
```

- `--from local` (default) clones each repo from its sibling working copy
  via `file://` — the future *pushed* state of any unpushed local commits
  (a clone carries committed history only, never the dirty tree).
  `--from github` clones `https://github.com/como-technologies/<repo>`
  instead — the published reality.
- The sandbox clones the **playbook** like every other suite repo (it is
  published), so ring 3's `demo-up` must fully stand up — the old documented
  stop at beat `[1/6]` is now a real `FAIL`. Only the `../docs` ledger stays
  out by default (local-only by policy); `--with-docs` opts it in from the
  local sibling.
- What it cannot simulate it records instead of faking: ollama-on-PATH and
  docker-daemon reachability are printed as env facts, and a down daemon
  degrades the docker-dependent ring-3 legs to `ENV-LIMITED` — preflight
  still runs regardless, because its honest reporting is part of the check.
- Per-leg logs land under `<sandbox>/logs/`, the last output line is one
  JSON result object for tooling, and the exit is nonzero only on a `FAIL`.
  Stepwise runs (`--ring`, `--repo`, `--leg`, `--soak N`) reuse a `--dir`
  sandbox. The caller's cargo registry cache is reused — fresh clones
  already force cold `target/` builds.

## The validation record

The loop has been run end to end three times, with every seam machine-checked
and the artifacts captured:

- [Run 1 — the iteration-1 capstone](./loop/dogfood/run-1.md)
- [Run 2 — the iteration-2 capstone](./loop/dogfood/run-2.md)
- [Run 3 — the iteration-3 capstone](./loop/dogfood/run-3.md)

Each page is regenerated mechanically from its captured run (`just
refresh-evidence`), so the evidence on the page is the evidence from the run.

## Publishing

Standing the suite up locally needs no remotes. Publishing each app to its
canonical remote — and reconciling the two repos whose origins carry separate
owner-side work — is a deliberate set of owner actions, kept out of the loop's
automation; the current per-repo procedure lives in the workspace ledger at
`docs/iteration-4/owner-actions.md`.

The formerly outstanding actions are done: the pinned adroit rev in
`conduit/adroit.rev` resolves from the adroit remote, and the **playbook is
published** at
[como-technologies/playbook](https://github.com/como-technologies/playbook)
(2026-07-05, a fresh-history cut of the template — its content gate ships a
generic example term list; a real engagement list stays in a gitignored
local file). A cold checkout that clones the suite side by side now runs
the demo with no overrides. The only remaining local-only input is the
`../docs` run-evidence ledger, by policy.
