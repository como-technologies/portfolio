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
`portfolio`) — then everything resolves with no configuration.

Toolchain: a Rust toolchain with `cargo`, `just`, and `mdbook`; Docker (for the
throwaway Gitea forge the Adopt demo uses); `ollama` with the `llama3.2` model
(the only thing the AI lanes need — no API key, nothing phones home); `gh` is
optional (GitHub read-only legs). conduit builds its pinned adroit itself with
`just init-adroit`.

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
just init-adroit                 # build the pinned adroit into .conduit/bin
demo/kit/demo-up                 # throwaway Gitea + seeded playbook + all binaries
demo/kit/beat-1-measure-prior    # pulse's prior-iteration signal
demo/kit/beat-2-assess           # brief + signal -> assessment   (--live for ollama)
demo/kit/beat-3-prescribe        # assessment -> accepted ADR + stored plan  (--live)
demo/kit/beat-4-adopt            # stored plan -> human-gated PR -> merge -> verify 6/6
demo/kit/beat-5-measure          # tuesday --strict + Adopt<->Measure cross-check
demo/kit/demo-down               # destroys the forge; leaves nothing
```

Each beat prints its talking point and the machine evidence it just produced
(verify 6/6, byte-identical forge transcripts, `CROSS-CHECK PASS`). The
pre-baked path runs every beat in seconds; `--live` recomputes the two ollama
lanes for real (timings in the [customer demo](https://github.com/como-technologies/conduit)
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
