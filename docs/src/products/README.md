# Products

Productized offerings in the Como Technologies portfolio. Products are the
durable artifacts and patterns clients adopt — what the
[Prescribe](../loop/prescribe.md) stage produces, and the substrate it
produces it on.

**The content product is the knowledge base** (this book's ADR-0010):
content is born in a KB space through the client's own AI harness over
MCP, typed and schema-validated at admission — not maintained in a cloned
doc repo.

- **The knowledge base** — [llm-wiki](../kb-spec.md), Como's KB product.
  One headless, git-backed Rust binary with typed, schema-validated
  pages, strict admission gates, search, a concept graph, and 23 MCP
  tools — and no LLM inside, so every AI step around it stays auditable.
  It ships with the **authoring kit** (skills, harness configs, the
  authoring contract, a captured worked example) and the **starter
  content** below. It is the substrate every Como tool runs against
  today (ephemeral, disposable spaces — this book's ADR-0009); a
  persistent client KB is a deliberate future step, not a current offer.
- **[Starter content](./starter-content.md)** — what a fresh space
  begins with: five accepted engineering decisions (three with stored
  implementation plans), an 11-record Proposed backlog, ten glossary
  entries, and the ADR review-process guide. Distilled from the
  pattern's one delivered engagement; formerly shipped as a clonable
  template repository, retired by ADR-0010 (repo archived, its
  self-serve badge retired with it — the honest ladder).

Each engagement produces a tailored knowledge base — opinionated where
the client needs a jumpstart, flexible where they have their own
conventions. The [Knowledge base authoring](../services/kb-authoring.md)
service is how a variant gets made; the
[Agentic delivery](../services/agentic-delivery.md) pilot is how its
decisions get worked.
