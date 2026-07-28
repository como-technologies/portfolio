# Knowledge base authoring

Co-creation of an opinionated knowledge base tailored to your context:
*decisions* recorded as ADRs, *guidance* as step-by-step guides — typed,
schema-validated pages with AI assistance at every authoring step and a
mechanical gate behind each one. This is the human wrapper around the
loop's [Prescribe](../loop/prescribe.md) stage. The target interaction is
harness-first (this book's ADR-0010): your people work in the AI harness
of their choice, configured with Como's tools over MCP, and the content
lands in the KB in the right shape. Today — said plainly — Como drives
that loop with your SMEs alongside; the authoring kit that hands it to
your harness is in flight
([portfolio#7](https://github.com/como-technologies/portfolio/issues/7)),
and [the playbook](../products/playbook.md) provides starter content.

**Inputs.** The assessment export from an
[Assessment engagement](./assessment.md) (or your own equivalent — the seam
is a schema, not a lock-in). Plus the client's existing conventions: a
knowledge base is opinionated where you need a jumpstart and flexible where
you already have your own shape.

**Tool.** [adroit](../loop/prescribe.md) *(SME-usable)* — the ADR authoring
CLI, operating exclusively against a KB space (its ADR-0020) so strict
schema validation gates every write. `adroit import --from-assessment`
mechanically seeds one Proposed ADR per assessed practice; AI authoring
assists (on Anthropic or local ollama) draft the prose, revise it to
instruction, plan implementations, and answer questions over the corpus;
`adroit check` gates the corpus in CI. An SME can drive every step with
Como alongside — that is what the maturity badge means.

**Artifact out.** A living knowledge base: an adroit-managed decision
corpus plus guides, built as an mdBook and delivered as a self-hosted
static site. For decisions headed into
[agentic delivery](./agentic-delivery.md), acceptance includes
`adroit plan --save` — the implementation plan is stored inside the ADR,
so the corpus leaves the engagement Adopt-ready.

**Human gates.** Acceptance. Seeding, validation, and linting are
mechanical, and drafting is AI-assisted — but no ADR becomes Accepted
except by a human decision. Status transitions are governance, run with
the client's own architects in the review process the knowledge base
itself documents. The corpus you end up with is the set of decisions your
people actually made.

**Measure hooks.** Accepted ADRs are the unit everything downstream is keyed
to: the Adopt stage works them, and the Measure stage attributes engineering
hours back to them by reference. The knowledge base isn't just prose — it's
the ledger the rest of the loop reports against.
