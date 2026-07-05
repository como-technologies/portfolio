# Assess

The loop opens with evidence. Structured interviews with engineers,
architects, and platform owners become a consistent four-level maturity
model — Assessment → Domain → Practice → Question. Domains and practices
carry context, value, and risk; questions — the leaves — are binary checks
carrying text and polarity. The stage's output is not a deck: it is a
schema-validated document the Prescribe stage consumes mechanically.

## assessments

**Maturity: SME-usable** — moved up from dogfooding at the iteration-4
open, graded against the ladder (this book's ADR-0002): an external
subject-matter expert can co-author an assessment with a Como facilitator
alongside. The gating evidence, in the assessments repo: the facilitated
walkthrough (`docs/src/walkthrough.md`), every command on it run live
against a local 3B model before being written down; the recorded
operating model (its ADR-0009 — no in-app login at this rung, loopback
bind, facilitator-controlled tunnel for remote SMEs); the mechanical
quality gates proven under attack (an 18-scenario fault-injection harness
in CI) and live in run-3 (a misbehaving model produced a bounded failure,
not a placeholder artifact); uploads wired into prompts as never-cited
background behind those same gates; a provider-aware model picker with a
degraded-local-model banner; and `author --jobs N` with honestly-measured
parallel timing. Build from source remains the install path.

**What it is.** An AI-assisted authoring environment for structured maturity
assessments. SMEs co-create assessments with an AI assistant through a guided
five-phase workflow (scoping → structuring → questions → refining →
complete), and a headless `author` subcommand runs the same job end to end on
a local model — tool-call-free on ollama (`llama3.2` by default), no API key,
no network beyond localhost.

**How it enters the loop.** assessments is the loop's entry point: it
produces the schema-validated export (YAML/JSON/TOML, checked against a
published JSON Schema) that adroit consumes to seed Proposed ADRs in the
Prescribe stage.

```sh
# produce: author an assessment headlessly from a committed brief (local ollama)
amaker author --brief examples/dogfood/brief.md

# gate: re-check the export against the published JSON Schema
amaker validate assessment.yaml

# the consuming side of the seam (run in the Prescribe stage)
ADROIT_DIR=$(mktemp -d) adroit import \
  --from-assessment assessment.yaml --dry-run -o json
```

One command proves the seam end to end: `just dogfood` authors a fresh
assessment from the committed generic engineering-maturity brief, validates
it, dry-run-imports it into a fresh corpus, and asserts that every practice
produced a seed. The recorded run: four domains, eight practices, sixty
questions authored in one pass — eight practices in, eight Proposed-ADR
seeds out. `just seam-check` pins the same assertion in CI against a
committed golden export, so contract drift on either side of the seam fails
`just ci` without needing a model.

**Where its evidence lives.** In the assessments repo:
`docs/src/dogfood.md` (the captured Assess → Prescribe seam run),
`docs/src/authoring.md` (the headless pipeline and its bounded corrective
retries), and `contract/golden-assessment.yaml` (the golden export that
`seam-check` runs against on every CI pass).
