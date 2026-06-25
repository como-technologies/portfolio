# Playbook authoring

Co-creation of an opinionated playbook tailored to your context: *decisions*
recorded as ADRs, *guidance* as step-by-step guides, published as a
self-hosted static site your teams can extend. This is the human wrapper
around the loop's [Prescribe](../loop/prescribe.md) stage, and its artifact
is the portfolio's flagship product — [the playbook](../products/playbook.md).

**Inputs.** The assessment export from an
[Assessment engagement](./assessment.md) (or your own equivalent — the seam
is a schema, not a lock-in). Plus the client's existing conventions: a
playbook is opinionated where you need a jumpstart and flexible where you
already have your own shape.

**Tool.** [adroit](../loop/prescribe.md) *(dogfooding)* — the ADR authoring
CLI. `adroit import --from-assessment` mechanically seeds one Proposed ADR
per assessed practice; AI authoring assists (on Anthropic or local ollama)
draft the prose; `adroit check` and `adroit index` gate the corpus in CI.

**Artifact out.** A living playbook repo: an adroit-managed ADR corpus plus
guides, built as an mdBook and delivered as a self-hosted static site. For
decisions headed into [agentic delivery](./agentic-delivery.md), acceptance
includes `adroit plan --save` — the implementation plan is stored inside the
ADR, so the corpus leaves the engagement Adopt-ready.

**Human gates.** Acceptance. Seeding and linting are mechanical, but no ADR
becomes Accepted except by a human decision — status transitions are
governance, run with the client's own architects in the review process the
playbook itself documents. The corpus you end up with is the set of
decisions your people actually made.

**Measure hooks.** Accepted ADRs are the unit everything downstream is keyed
to: the Adopt stage works them, and the Measure stage attributes engineering
hours back to them by reference. The playbook isn't just prose — it's the
ledger the rest of the loop reports against.
