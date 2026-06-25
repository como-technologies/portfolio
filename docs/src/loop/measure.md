# Measure

Adoption is observed, not assumed — on two axes. tuesday quantifies where
engineering capacity actually goes and attributes it to the decisions that
spent it; pulse captures the qualitative signal people won't volunteer in a
town hall. Both produce machine-readable artifacts, because the loop's last
hand-off is the next assessment's input.

## tuesday

**Maturity: SME-usable** — moved up from dogfooding at the iteration-3
close, graded against the ladder (this book's ADR-0002): an external
subject-matter expert can drive it with Como alongside. The gating
evidence, in the tuesday repo: the SME quickstart
(`docs/src/usage/quickstart.md`) takes a fresh clone to a capacity report
over the SME's *own* forge, both command shapes verified against live
forges (GitHub, and Gitea 1.24); the `--from`/`--to` multi-month range
landed (its ADR-0007); and the retirement decisions (its ADR-0008–0010:
GCP machinery, built-in scheduling, Gitea OAuth) cut the surface to the
generic, local-first self-host story (`docs/src/running.md`). Build from
source remains the install path.

**What it is.** Team capacity analysis from merged-PR effort. Developers
self-report relative effort on PRs; tuesday turns that into monthly capacity
breakdowns. It is a Cargo workspace around a forge-neutral core:
`tuesday-core` (the effort calculator and a read-only `PrSource` trait with
GitHub and Gitea providers), a web head (the interactive report), and
`tuesday-report` — the headless CLI head that emits the one canonical
MonthlyReport JSON; over a multi-month range it emits one unchanged
per-month report in an additive envelope.

**How it enters the loop.** tuesday is the consuming side of the
[conduit → tuesday contract](./adopt.md#the-conduit--tuesday-contract), and
the loop's independent second verifier: conduit's `verify` and tuesday's
report are two codebases agreeing about the same merged PR's markers. The
proving command, against conduit's dogfood forge (Measure reads with the
reviewer identity — it is read-only by construction):

```sh
tuesday-report --source gitea --owner como --repo conduit-dogfood \
    --year 2026 --month 6 \
    --token-file ../conduit/.secrets/reviewer.token \
    --strict -o json
```

It produces the canonical MonthlyReport JSON, including the `adr_totals`
rollup: a PR's **full** allocated hours are credited to the ADR named by its
`adr:*` label — attribution answers "what did this decision cost?", so it is
never split the way categories are. `--strict` enforces the allocation
ruling with a nonzero exit: every merged PR must carry exactly one
`effort:N-*` label **and** (a category label **or** an `adr:*` label).
Structural labels (`adr:*`, `conduit:*`) are machinery, never categories.
Two caveats are accepted and documented rather than engineered around:
post-merge label edits can make conduit's at-merge view and tuesday's
at-report view disagree, and the report is keyed to a calendar month, so
runs pass the year and month explicitly.

**Where its evidence lives.** In the tuesday repo:
`docs/src/dogfood-contract.md` (the consumer-side contract statement and the
allocation ruling), `crates/tuesday-cli/tests/cli.rs` (the CLI driven end to
end against a stub Gitea forge), a live test leg in `tuesday-core` that
reads conduit's dogfood forge, and the SME-facing pages
(`docs/src/usage/quickstart.md`, `docs/src/running.md`) whose
live-verification note travels with the quickstart.

## pulse

**Maturity: dogfooding (parked)** — development intentionally frozen at the
protocol proof by a recorded decision; the dogfood run is kept green each
iteration. No production client; respondents are simulated. Parked **is**
pulse's recorded suite-done state: its accepted ADR-0010 sets the bar —
gate green and the deterministic dogfood artifact re-proven each iteration
— and un-parking requires a superseding ADR naming a real deployment
driver (a committed pilot with real respondents, or a funded SME-pilot
decision).

**What it is.** Verified-anonymous sentiment polling built on cryptographic
blind signatures (RFC 9474): employees can respond honestly because the math
guarantees they can't be identified, even by the operator. Under the hood:
an 8-crate workspace with compile-enforced identity/signal zone isolation,
envelope encryption with crypto-shredding, and k-anonymity suppression on
every aggregate.

**How it enters the loop.** pulse produces the loop's qualitative Measure
artifact — a file contract, not a live service:

```sh
just dogfood    # full blind-signature protocol over real HTTP against an
                # in-process multi-zone cluster → out/pulse-report.json
```

The report identifies itself with the schema id `pulse.measure-report/v1`,
labels its data source as seeded simulation (there are no employees in the
dogfood loop), and is deterministic: the same seed produces a byte-identical
report, which turns the demo into a regression test. The survey itself is
data — a checked-in TOML file each iteration edits without recompiling.

**Where its evidence lives.** In the pulse repo:
`docs/src/development/dogfood.md` (the Measure-report contract and the
determinism check), with the decisions behind it recorded as ADR-0008 (the
report-v1 file contract), ADR-0009 (seeded determinism), and ADR-0010
(dogfooding parked at M0 accepted as the suite-done state, with the
deferred milestones retired by name) in its adroit-managed `adr/` corpus.
