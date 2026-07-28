# Starter content

The content a fresh knowledge base starts from — so a client's day one
begins with a working corpus, not a blank space. It ships with the
authoring kit in the llm-wiki repo (`kit/starter/`):

- **Five accepted engineering decisions** — trunk-based development, ADR
  governance, dependency pinning and audit, a shared glossary, automated
  testing — three of them carrying **stored implementation plans**, so a
  fresh space is Adopt-ready from the first hour. Starter decisions are
  examples a team keeps, supersedes, or replaces — superseding a starter
  opinion *is* the process working.
- **An 11-record Proposed starter backlog** — CI, code reviews,
  refactoring, unit and integration testing, monitoring, incident
  management, feature flags, runbooks, secrets handling, library
  versioning — a decision pipeline with ideas already in it.
- **Ten glossary entries and the ADR review process guide** as typed KB
  pages: the decision-lifecycle vocabulary defined once, and the
  governance mechanics (quorum, review window, roles) as daily practice.

Nothing in it assumes a vendor, cloud, language, or CI system; every
concrete tool named in the starter content is an example slot, not a
prescription.

## How it enters a space

One rehearsed sequence, gates and all — decisions bootstrap through
`adroit seed` (each space gets its own page identities), typed pages go
straight through strict ingest, and the sequence ends with
`adroit check` clean and lint at zero errors. The kit's
`starter/README.md` carries the exact commands; the
[Prescribe](../loop/prescribe.md) chapter shows the read side the Adopt
engine consumes.

## Where it came from — and where the template went

The starter content is distilled from the pattern's one delivered client
engagement: a decision corpus and guides built for an enterprise cloud
and Kubernetes platform team — twenty-one ADRs across the lifecycle
statuses plus six guides, delivered as a self-hosted static site running
where that team operates. Content was written fresh, with a CI-enforced
rule that no client material enters the product. One delivered instance
remains the honest count.

Between that engagement and today, this content shipped as a clonable
**template repository** — a self-serve product with its own gate. The
harness-first decision (this book's ADR-0010) retired that workflow:
content is born in the KB through a conversation, not maintained in a
cloned repo, so the template's repository is **archived** (read-only,
2026-07-28) and its **self-serve badge retired with it** — the rung was
earned by the template's own evidence and doesn't transfer; the
harness-first offering will earn its own rung on its own evidence. The
corpus lives on as this starter content, whose new home of record is the
kit.
