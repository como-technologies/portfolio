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

# the consuming side of the seam (run in the Prescribe stage; adroit is
# KB-only, so the target is a fresh space, not a bare directory)
SPACE=$(mktemp -d)
printf 'name = "adrs"\n' > "$SPACE/wiki.toml" && mkdir -p "$SPACE/wiki/decisions"
ADROIT_DIR=$SPACE adroit import \
  --from-assessment assessment.yaml --dry-run -o json
```

The seam is proven from both ends. Live: the three-step rehearsal in the
assessments repo's dogfood page (author → validate → dry-run import into a
fresh space) — the recorded run authored four domains, eight practices,
and sixty questions in one pass; eight practices in, eight Proposed-ADR
seeds out. Mechanically, in CI on both sides: assessments' golden-export
contract test gates the producer's shape, and adroit vendors that same
golden export as its ingest-contract fixture and pins the seeded backlog
against it — contract drift on either side fails that repo's `just ci`
without needing a model.

**Where its evidence lives.** In the assessments repo:
`docs/src/dogfood.md` (the captured Assess → Prescribe seam run),
`docs/src/authoring.md` (the headless pipeline and its bounded corrective
retries), and `contract/golden-assessment.yaml` (the golden export that
`seam-check` runs against on every CI pass).
