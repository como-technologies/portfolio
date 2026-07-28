# Prescribe

The assessment drives an opinionated knowledge base: *decisions* recorded as
ADRs (Architecture Decision Records) and *guidance* as step-by-step guides,
held as typed, schema-validated pages in a KB space (the
[Como KB specification](../kb-spec.md)). The stage's tool is adroit; its
artifact is the decision corpus in the knowledge base. The hand-off in is
mechanical — `adroit import --from-assessment` seeds Proposed ADRs straight
from the Assess export — and the hand-off out is machine-readable: accepted
decisions and their stored implementation plans, served as JSON to the Adopt
stage.

## adroit

**Maturity: SME-usable** — moved up from dogfooding at the iteration-4
open, graded against the ladder (this book's ADR-0002): an external
subject-matter expert can drive the Prescribe workflow with Como
alongside. The gating evidence, in the adroit repo: the v0.2.0 tagged
release (its ADR-0012 release discipline, changelog chapter in the book);
the recorded decision that build-from-source IS the install path at this
rung (its ADR-0013, published distribution retired for suite-done); the
20-ADR self-managed corpus (`adroit check` clean); and three full-loop
runs of live `import --from-assessment --ai` plus stored-plan determinism
— plans persist inside the ADR document and are read back provider-free,
byte-identically. Build from source remains the install path.

**What it is.** A Rust CLI for authoring, linking, and managing ADRs: one
binary with three surfaces (CLI, optional TUI, read-only web dashboard),
AI authoring assists at every step (interview drafting, instruction-driven
revision, implementation planning, corpus Q&A) on Anthropic or local
ollama, forge/tracker integration, and a machine-readable agent seam —
`manifest`, `-o json` on every read verb, and a guarded MCP projection:
read-only by default, with an opt-in write slice for MCP-only harnesses
(adroit ADR-0021 — destructive-annotated tools the human approves per
call, the same admission gates underneath).
Since its ADR-0020, adroit operates **exclusively against a KB space**:
`--dir` names a space (a directory holding `wiki.toml`), decision pages
live in the space's `wiki/decisions/`, and the space's admission hooks —
strict schema validation on every commit — sit under every write. One
command, `adroit seed --from <legacy-dir>`, bootstraps an existing ADR
corpus into a fresh space.

**How it enters the loop.** adroit consumes the Assess export and produces
the decision corpus the Adopt stage works from. The write side — assessment
to accepted, planned decision, with an AI assist available at each step and
a mechanical gate behind each one:

```sh
adroit import --from-assessment export.yaml --ai -o json  # seed Proposed ADRs
adroit lint 1 -o json                                     # mechanical authoring gate
adroit set-status 1 accepted
adroit plan 1 --save        # persist the implementation plan inside the ADR
```

The read side — the exact slice the Adopt engine issues (every read
`-o json`, every read provider-free):

```sh
adroit manifest -o json                  # tool discovery + schemas
adroit list --status accepted -o json    # the decision backlog
adroit show 1 -o json                    # one decision (carries its stored plan)
adroit plan 1 -o json                    # the stored plan — a deterministic read
```

The stored-plan read is byte-identical across invocations — the property the
Adopt engine's snapshotting relies on, proven in a recorded rehearsal (same
sha256 on consecutive reads).

**Where its evidence lives.** In the adroit repo:
`docs/src/dev/adopt-read-slice.md` — the recorded Adopt read-slice rehearsal
on a live local model, re-runnable as `just adopt-slice`. And across the
portfolio: adroit manages the ADR corpora of conduit, pulse, tuesday,
assessments, the kit's starter content — and this book's own `adr/`, where the decisions
behind this restructure are recorded. Every one of those repos' CI gates
seeds its committed corpus into an ephemeral KB space and validates it
there on every run (this book's ADR-0009) — the KB machinery is exercised
continuously, not demonstrated once.

## Starter content

A fresh knowledge base starts from the shipped
[starter content](../products/starter-content.md) — five accepted
engineering decisions (three carrying stored implementation plans), an
11-record Proposed backlog, ten glossary entries, and the ADR
review-process guide, all living in the llm-wiki kit (`kit/starter/`)
and bootstrapped into a space by one rehearsed, gate-clean sequence.
Starter decisions are examples a team keeps, supersedes, or replaces —
superseding a starter opinion *is* the process working.

**How it enters the loop.** A knowledge base's accepted ADRs are not just
documentation — they are the Adopt stage's work queue. The corpus is
consumed entirely over adroit's CLI, no scraping and no human in the read
path — stood up in a space, then read:

```sh
SPACE=$(mktemp -d)
printf 'name = "adrs"\n' > "$SPACE/wiki.toml" && mkdir -p "$SPACE/wiki/decisions"
adroit seed --from kit/starter/decisions --dir "$SPACE"     # corpus -> KB space
ADROIT_DIR=$SPACE adroit list --status accepted -o json     # enumerate the queue
ADROIT_DIR=$SPACE adroit show 4 -o json                     # read one decision
ADROIT_DIR=$SPACE adroit plan 4 -o json                     # read its stored plan
```

The same sequence works for any legacy corpus a client brings — `seed`
exists precisely so an existing ADR history bootstraps into a space
without re-keying.

**Where its evidence lives.** In the llm-wiki repo: `kit/starter/README.md`
records the rehearsed bootstrap (seed 16, strict ingest, `adroit check`
clean, lint at zero errors) and is re-rehearsed whenever the content
changes. The template repository that formerly shipped this corpus is
archived — the retirement story is on the
[starter content](../products/starter-content.md) page.
