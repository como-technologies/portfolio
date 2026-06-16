# How this book stays true

This book describes six sibling repos that all move, and prose rots silently
when reality does. So the book's truthfulness is mechanical, not
aspirational: a scripted gate, `scripts/verify-claims`, runs first in
`just ci` and goes **red** when a sibling repo no longer matches what the
book says. The decision is recorded as ADR-0003 in this repo's own
adroit-managed `adr/` corpus; the gate is its implementation.

## What the gate asserts

Every assertion pins **both sides**: the claim must still appear in the book
(a rewrite that drops a pinned claim fails the gate until the script is
updated with it), and reality — read from the sibling repos, resolved as
described [below](#how-the-gate-finds-the-siblings) — must match it. The
checks, pinned to drift-resistant anchors:

1. **The conduit → tuesday contract table** ([Adopt](./loop/adopt.md#the-conduit--tuesday-contract))
   string-matches the constants in conduit's `src/contract.rs`: the closed
   five-value `effort:*` label set (in order, and no book page may mention a
   label outside it), the `adr:<reference>` label, the `[ADR-NNNN] <title>`
   title prefix, the `Adr-Reference:` body trailer, the
   `conduit/<ref-lower>/<slug>` branch shape, and the count of six fixed
   `verify` checks.
2. **Every CLI invocation the book quotes exists.** adroit's quoted
   subcommands (`manifest`, `list`, `show`, `plan`, `import`, `lint`,
   `set-status`, `mcp`, `check`, `index`) and the import seam's
   `--from-assessment` / `--dry-run` flags are asserted against the real
   `adroit --help`; conduit's `plan` / `run --once` / `verify` against
   `conduit --help`; tuesday's headless head against the `tuesday-report`
   binary's `--help` (`--strict`, `adr_totals`, `MonthlyReport`, gitea) with
   its crate manifest as the always-on anchor; assessments' `author` /
   `validate` / `export` verbs against `assessments --help`, falling back to
   its clap definitions when the binary isn't built.
3. **pulse sanity.** The checked-in dogfood survey
   (`dogfood/iteration-retro.toml`) exists, and the
   `pulse.measure-report/v1` schema id the book quotes appears in both
   pulse's accepted ADR-0008 and its source; ADR-0009 (seeded determinism)
   and ADR-0010 (dogfooding parked at M0 accepted as the suite-done state)
   exist as accepted because the book cites them.
4. **Badge sanity — the dogfooding floor.** Any app this book badges
   **spike** or higher must have a non-empty adroit-managed ADR corpus in
   its repo's working tree — merged main, not a side branch — and the
   introduction's TAPS table must agree with each chapter's badge line.
5. **Evidence-ledger discipline.** The [iteration changelog](./changelog.md)
   is a first-class SUMMARY page, and every per-run evidence page under
   the [dogfood chapter](./loop/dogfood.md) is listed in SUMMARY, states a
   captured-run pointer that resolves in the workspace ledger
   (`docs/iteration-N/run-N`), and has a matching per-iteration changelog
   entry.

A failure prints the claim, the book `file:line` that makes it, and what
reality returned instead.

## How the gate finds the siblings

Each sibling repo is resolved by the suite's uniform convention (recorded
as ADR-0004 in this repo's `adr/` corpus), self-contained in the script:

1. **`COMO_<REPO>_DIR`** — an explicit env override naming the checkout.
2. **The sibling checkout** — `../<name>` beside this repo.
3. **The clone cache** — a gitignored, read-only
   `git clone` under `.como/deps/<name>`, checked out at the exact rev the
   script declares in its `PINS` table, fetched from
   `${COMO_GIT_BASE:-https://github.com/como-technologies}/<name>.git`.
   `COMO_OFFLINE=1` uses an already-populated cache as-is and never
   fetches; a cache that lags its pin is re-pinned, never trusted blindly.
4. **Skip with a notice** naming all of those knobs.

The gate prints which source each assertion group actually validated — the
sibling and its HEAD sha (flagged when it differs from the declared pin:
local state, not the pinned contract) or the cache and its pinned rev — so
what "reality" meant in any given run is on the record, and pin drift is
visible rather than silent. Pin bumps to the `PINS` table are deliberate,
reviewed edits. The workspace docs ledger is the standing exception: it is
local-only by policy (no remote, ever), so its resolution stops at
env → sibling → skip, with no clone leg.

## What red means

A red `just ci` when a sibling drifts is the feature, not a bug: the fix is
to update the book (or the sibling), **never** to loosen the gate. Checks
against a sibling repo skip with an explicit `skip:` line when that repo
cannot be resolved at all or its binary isn't built — a fresh CI checkout
proves less than a full portfolio checkout, by design; the full proof runs
where all six siblings live side by side (or where `COMO_GIT_BASE` lets the
clone cache stand in for them).
