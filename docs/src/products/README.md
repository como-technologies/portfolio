# Products

Productized offerings in the Como Technologies portfolio. Products are the
durable artifacts and patterns clients adopt — what the
[Prescribe](../loop/prescribe.md) stage produces, and the substrate it
produces it on.

The portfolio has two products, deliberately paired:

- **The knowledge base** — the substrate itself: [llm-wiki](../kb-spec.md),
  Como's KB product. One headless, git-backed Rust binary with typed,
  schema-validated pages, strict admission gates, search, a concept graph,
  and 23 MCP tools — and no LLM inside, so every AI step around it stays
  auditable. It is the substrate every Como tool runs against today
  (ephemeral, disposable spaces — this book's ADR-0009); a persistent
  client KB is a deliberate future step, not a current offer.
- **[The playbook](./playbook.md)** — the ready-to-adopt content product:
  a generic template repository holding an adroit-managed ADR corpus plus
  guides, published as a self-hosted mdBook, CI-gated, and readable by the
  Adopt stage's engine over a machine seam. *Maturity: self-serve* — a
  team clones it and runs it without Como in the room.

The pattern has shipped once as a client engagement — a playbook built for
an enterprise cloud and Kubernetes platform team, described as the product
page's [proof point](./playbook.md#the-delivered-proof-point).

Each engagement produces a tailored variant — opinionated where the client
needs a jumpstart, flexible where they have their own conventions. The
[Knowledge base authoring](../services/kb-authoring.md) service is how a
variant gets made; the [Agentic delivery](../services/agentic-delivery.md)
pilot is how its decisions get worked.
