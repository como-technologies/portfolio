# The playbook

A living book that holds two things for an engineering team: *decisions*,
recorded as ADRs with an explicit lifecycle (Proposed → Accepted / Rejected /
Superseded / Deprecated), and *guides* — the how-to material that turns
those decisions into daily practice. The premise: the most valuable artifact
a team can maintain is not a wiki that slowly rots, but a small, honest
record of what was decided, why, and what it cost.

**Maturity: self-serve** — a fresh copy initializes and passes its full
gate without Como in the room: `just template-check` rehearses the
documented first-clone steps in a temp copy and requires `just ci` green.
Scoped by playbook ADR-0014: self-serve covers the content product, adroit
is recommended-not-required; the corpus ships an 11-record
Proposed starter backlog beyond the five accepted worked examples.

## What ships

The product is a generic, client-name-free **template repository** — a
working playbook, not a blank one:

- **An adroit-managed ADR corpus** (by-status layout) with an ADR template
  and starter accepted decisions a team can keep, supersede, or replace —
  superseding a starter opinion *is* the process working.
- **Guides**: the decision review process, the adoption path
  ("copy, rename, make it yours"), and the Adopt read path (below).
- **The book**: everything publishes as a self-hosted mdBook static site,
  so the playbook lives where the team already operates.
- **A CI gate**: corpus validation and index check (`adroit check`,
  `adroit index --check`), a banned-terms scan that keeps the artifact
  generic, and the book build — one `just ci`, green from the first clone.

Nothing in it assumes a vendor, cloud, language, or CI system. The decisions
it prescribes are about how a team decides and works; every concrete tool in
the starter content is an example slot, not a prescription.

## Machine-readable by design

A playbook's accepted ADRs aren't just documentation — they are the
[Adopt](../loop/adopt.md) stage's work queue. The corpus is consumed
entirely over [adroit](../loop/prescribe.md)'s CLI (`list`, `show`, `plan`,
all `-o json`), and accepted decisions can carry **stored implementation
plans** persisted inside the ADR itself. The template's own
`adopt-read-path` guide documents that seam with JSON captured against this
very corpus — the proof travels with the product. Working a client
playbook's decisions to merged PRs is the
[Agentic delivery](../services/agentic-delivery.md) pilot.

## Dogfood, not demo

The portfolio runs its own loop on this template's corpus: five accepted
engineering ADRs (trunk-based development, ADR governance, dependency
pinning and audit, a shared glossary, automated testing), three carrying
stored plans, validated by the CI gate every iteration. The [Prescribe](../loop/prescribe.md)
chapter describes how it sits in the loop.

## The delivered proof point

The pattern has shipped once as a client engagement: **palette-playbook**, a
playbook built for an enterprise cloud and Kubernetes platform team —
twenty-one ADRs across the lifecycle statuses plus six guides, delivered as
a self-hosted static site (mdBook + Docker + nginx) running where the team
operates. It predates the generic template and is the engagement the
template's structure and process patterns were distilled from — content
written fresh, with a CI-enforced rule that no client material enters the
product.

One delivered instance is the honest count. The template exists so the
second one starts from a working repo on day one.
