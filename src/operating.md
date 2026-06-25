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
corpus ships **inside its own published mdbook source** (`docs/src/adr/`, or
`book/src/adr/` for assessments), so the truthfulness gate in Ring 2 finds it in
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

**Local-only by policy.** Two inputs are deliberately kept on the owner's
machine and are not published; where either is absent the gate and the demo
**skip or stop with a notice that names the knob**, never silently:

- the **run-evidence ledger** (`COMO_DOCS_DIR`, else a sibling `../docs`) that
  the per-run pages and `just refresh-evidence` read — so the run-evidence
  claims below verify only where the ledger is checked out;
- the **playbook** corpus the Adopt demo seeds onto the throwaway forge (the
  fictional client's decisions). Provide it with `COMO_PLAYBOOK_DIR`, a sibling
  `../playbook`, or `COMO_GIT_BASE` / `COMO_PLAYBOOK_GIT` for the clone cache.
  It has no public remote yet (see [Publishing](#publishing)).

## Ring 1 — each app on its own

Run the house gate in each repo:

```sh
just ci      # fmt + clippy + tests + book build + adr-check (every repo)
```

Green in all of them means each app is internally sound — formatted, lint-clean,
tested, its mdbook builds, and its ADR corpus validates. This is the per-app
truth check and the fastest signal.

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
remote at the pinned rev, else a sibling `../adroit` (its HEAD, with a loud
local-dev notice, when that checkout doesn't carry the exact pin because it
hasn't been pushed yet). `demo-up` resolves the playbook and the sibling
binaries the same way and seeds the throwaway forge; it stops early with named
knobs if Docker isn't up or no playbook resolves (run `preflight` first).

Each beat prints its talking point and the machine evidence it just produced
(verify 6/6, byte-identical forge transcripts, `CROSS-CHECK PASS`). The
pre-baked path runs every beat in seconds and needs only Docker; `--live`
recomputes the two ollama lanes for real (timings in the [customer demo](https://github.com/como-technologies/conduit)
kit's narrated page). Deeper conformance is env-gated: `CONDUIT_E2E_GITEA=1`
(live forge), `CONDUIT_E2E_ADROIT=1`, `CONDUIT_E2E_GITHUB=1`.

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

Two of those owner actions remove the last local-only edges so a cold public
checkout runs the demo with no overrides:

- **Push the pinned adroit rev** (`conduit/adroit.rev`) — push the commit and
  its `v0.2.0` tag to the adroit remote. Until then `init-adroit` falls back to
  a sibling `../adroit` (HEAD, local-dev only).
- **Publish the playbook** corpus to a remote (or set `COMO_GIT_BASE` so the
  clone leg resolves it). Until then the demo needs `COMO_PLAYBOOK_DIR` or a
  sibling `../playbook`.
