# The loop, run for real

The loop chapters state what each stage does; these pages are the
receipts. Once per iteration the entire TAPS loop runs end to end on one
machine — the iteration's capstone — and every run gets its own evidence
page here, accumulating run by run rather than overwriting the last:

- [Run 1 — the iteration-1 capstone](./dogfood/run-1.md) (2026-06-12):
  the first full-loop proof. Pulse sentiment steered an authored
  assessment, the assessment seeded ADRs, an accepted ADR became a merged
  contract-tagged PR, and the measurement side independently recovered
  that decision's identity, effort, and hours — all on localhost, every
  step exit 0.
- [Run 2 — the iteration-2 capstone](./dogfood/run-2.md) (2026-06-12):
  the same loop, a third faster at Assess with zero retries and zero
  context leakage, prescribing into the **real** playbook corpus instead
  of a throwaway one, with a kill-mid-Coding restart folded into the main
  thread, a live-engine encore whose merged PR was harvested back into
  the playbook, and the loop-closure cross-check passing twice.

Every excerpt on a run page is extracted **mechanically** from that run's
captured artifacts by `just refresh-evidence` — nothing is
hand-transcribed. The full artifact sets — `transcript.md` with every
command and exit code, plus every seam JSON the pages quote — live in the
workspace evidence ledger beside the portfolio checkouts, one directory
per run: `docs/iteration-N/run-N/`.

## How these pages regenerate

The excerpts on each run page sit between
`<!-- evidence:NAME-start/end -->` anchor comments and are owned by
`scripts/refresh-evidence`, which re-extracts them from a captured run
directory into that run's page:

```sh
just refresh-evidence                             # every committed run dir
just refresh-evidence ../docs/iteration-2/run-2   # one run, once its evidence lands
```

A captured run directory `docs/iteration-N/run-N` regenerates exactly one
page, `src/loop/dogfood/run-N.md`. When a new run's evidence lands, the
script creates that run's page beside the existing ones — anchors filled
mechanically, surrounding prose left to a human — so run 2 lands **beside**
run 1 and no earlier run is ever overwritten. The no-argument default
discovers whatever run directories have been committed, picking new ones
up as they appear without breaking while they don't exist yet.

The script is deterministic and idempotent — running it twice produces
byte-identical pages — and each committed page is its verbatim output.
Artifacts are never fabricated: if a stage hasn't run, its missing
artifact is a hard error rather than a silent skip, and the gate in
`just ci` keeps the claims that *are* pinned honest.

What each run *meant* — the badge moves it gated, the corrections it
forced, what shipped around it — is recorded per iteration in the
[iteration changelog](../changelog.md).
