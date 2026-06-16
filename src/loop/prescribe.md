# Prescribe

The assessment drives an opinionated playbook: *decisions* recorded as ADRs
(Architecture Decision Records) and *guidance* as step-by-step guides. The
stage's tool is adroit; its artifact is the playbook. The hand-off in is
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
19-ADR self-managed corpus (`adroit check` clean); and three full-loop
runs of live `import --from-assessment --ai` plus stored-plan determinism
— plans persist inside the ADR document and are read back provider-free,
byte-identically. Build from source remains the install path.

**What it is.** A Rust CLI for authoring, linking, and managing ADRs: one
binary with three surfaces (CLI, optional TUI, read-only web dashboard),
AI authoring assists (interview drafting, implementation planning, corpus
Q&A) on Anthropic or local ollama, forge/tracker integration, and a
machine-readable agent seam — `manifest`, `-o json` on every read verb, and
a read-only MCP projection.

**How it enters the loop.** adroit consumes the Assess export and produces
the decision corpus the Adopt stage works from. The write side — assessment
to accepted, planned decision:

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
portfolio: adroit manages the ADR corpora of conduit, pulse, tuesday, the
playbook, assessments — and this book's own `adr/`, where the decisions
behind this restructure are recorded.

## The playbook

**Maturity: self-serve** — a fresh copy initializes and passes its full
gate without Como in the room: `just template-check` rehearses the
documented first-clone steps in a temp copy and requires `just ci` green.
Scoped by playbook ADR-0014: self-serve covers the content product, adroit
is recommended-not-required; the corpus ships an 11-record
Proposed starter backlog beyond the five accepted worked examples.

**What it is.** The playbook is the Prescribe artifact: an adroit-managed
ADR corpus plus guides, published as a self-hosted static site (mdBook).
The portfolio dogfoods the pattern on its own generic playbook repo — five
accepted engineering ADRs (trunk-based development, ADR governance,
dependency pinning and audit, a shared glossary, automated testing), three
of them carrying stored implementation plans. [palette-playbook](../products/README.md), the
client-delivered instance of the same pattern, is described with the
products.

**How it enters the loop.** A playbook's accepted ADRs are not just
documentation — they are the Adopt stage's work queue. The corpus is
consumed entirely over adroit's CLI, no scraping and no human in the read
path:

```sh
ADROIT_DIR=src/adrs adroit list --status accepted -o json   # enumerate the queue
ADROIT_DIR=src/adrs adroit show 4 -o json                   # read one decision
ADROIT_DIR=src/adrs adroit plan 4 -o json                   # read its stored plan
```

**Where its evidence lives.** In the playbook repo:
`src/guides/adopt-read-path.md` documents the Adopt read path with JSON
captured against that very corpus, and the stored plans live inside the
accepted ADR documents under `src/adrs/accepted/`. The repo's CI gate runs
the corpus check and a banned-terms scan on every build.
