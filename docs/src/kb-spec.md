# The Como KB specification

The knowledge base that makes the playbook evidenced: typed pages, stable
identity, mechanical anti-rot, and a git-native admission model. Produced by
the [kb-spike](https://github.com/como-technologies/kb-spike) evaluation
(ten findings, each closed with live-verified evidence) and adopted by
[ADR-0005](./adr/accepted/0005-adopt-llm-wiki-engine-como-fork-as-the-knowledge-base-substrate.md).
Substrate: [`llm-wiki-engine`, Como fork](https://github.com/como-technologies/llm-wiki)
(`como-main`). This chapter is the spec's interim home — once the production
KB exists, the spec migrates into it as typed pages and this page becomes a
projection.

---

## Part I — How content moves

The mental model: **git history is the admission log. Validation is the
pre-commit constraint. Everything downstream — the indexer, the LLM
librarian — is a consumer of that log with a per-instance cursor, catching
up idempotently.** The engine does zero inference; the librarian is a head.

### Admission: two paths, one gate

- **Structured writers (the normal case).** Every portfolio tool — adroit,
  tuesday, pulse — owns its page type(s) and writes typed pages straight
  into `wiki/`, then commits. No LLM in the admission path; tools never
  block on a model. The gate is the pre-commit hook: strict schema
  validation — **a failing page fails the commit**, so invalid data never
  enters history. One substrate: the ADR corpus lives *in* the space, and
  adroit operates on it there.
- **Capture (`evidence/`).** Unstructured material — conversation exports,
  assessment dumps, third-party docs — lands as files and commits. Bulk
  load is just many files in one commit: one atomic transaction, no
  debouncing, no half-written-file edge cases.

### Downstream consumers

Each consumer records "processed up to commit X" as a git ref
(`refs/kb/<consumer>/<instance>`) and catches up to HEAD when prompted — a
post-commit hook, the next engine command, or an explicit catch-up. Failure
just leaves the cursor behind; any later prompt retries. Index failure is
lag, never loss.

1. **The indexer** (mechanical, fast): index the committed delta, advance
   `refs/kb/index/<instance>`.
2. **The librarian** (semantic, batched) — two triggers, one loop:
   - **Enhancement policy, keyed on page type**: a new `measure-report`
     page arrives → policy says link concepts, refresh trend pages, check
     for contradictions against accepted decisions.
   - **Evidence processing**: work the uncited-evidence queue — an evidence
     file is *processed* when a wiki page cites it (a query, not a
     directory). Classify → extract claims → **reconcile** → author typed
     pages, each citing its sources as **pinned `path@commit` git refs**:
     the page extracted claims from *that version*, and the blob stays
     resolvable however tools reorganize evidence later.

### Reconcile is the ballgame

Before writing, the librarian queries the wiki (search + graph over MCP):
does this concept already exist (merge by id, not near-duplicate)? does a
claim contradict an accepted decision (surface it; perhaps propose
`supersedes`)? what should this page link to (never born an orphan)?
Contradiction and supersession judgments queue for human review; routine
extract→type→link runs unattended. The librarian's output goes through the
same admission gate as any tool — propose-then-verify, where the verifier is
deterministic (strict schema + lint), not another model.

### Invariants

- **Append-only history is law** — no rebase, no force-push, ever. It is
  what makes pinned citations and replay sound
  ([kb-spike#11](https://github.com/como-technologies/kb-spike/issues/11)
  tracks enforcement and the replay harness).
- **Idempotency** — pages upsert by declared id; consumers reprocess safely
  by cursor.
- **Confidence flow** — librarian pages are born `generated` with low
  `confidence` and promoted on review. Declared-low is down-ranked in
  search and stale-eligible; absent confidence is search-neutral and never
  stale — exactly the born-low → promoted lifecycle.
- **Replay** — resolve a page's pinned citations, re-run the pipeline on
  those exact blobs, diff the result.

---

## Part II — The contracts

Each contract cites its evidence in the spike's
[findings](https://github.com/como-technologies/kb-spike/tree/main/findings).

### 1. Identity & links

- A page carries a stable opaque **id**: a ULID, always tool-generated,
  never hand-authored.
- **Links resolve by id** — body `[[wikilinks]]` and typed edge fields
  alike; a page may be reorganized on disk with **zero link rewrites**.
  Slug/path is presentation and addressing convenience, not identity.
- **Id uniqueness is engine-enforced**: `duplicate-id` at error severity
  (CI-gating), `id-format` at warning. Resolution is slug-first, id-second;
  ids are opt-in by presence.
- Convention on top: immutable flat slugs for ADR paths
  (`decisions/adr-NNNN`, status in frontmatter only) — a naming convention,
  not a load-bearing constraint.
- Normative text: the fork's
  [`page-identity.md`](https://github.com/como-technologies/llm-wiki/blob/feat/stable-page-identity/docs/specifications/model/page-identity.md).
  Evidence: findings/issue-01.

### 2. Page types & schemas

- Bundled types do not express the `decision` class → **custom types via
  `schema add`**, one JSON Schema per type. Target classes: `decision`,
  `guide`, `glossary-entry`, `worked-example`, `plan`.
- The `decision` type is derived from adroit's `Adr`/`Status` model —
  tracked at
  [`kb-spike/schemas/decision.json`](https://github.com/como-technologies/kb-spike/blob/main/schemas/decision.json)
  until the production space exists. Schemas are authored outside a space's
  `schemas/` dir and installed via `schema add`.
- Custom types set **`additionalProperties: false`** — unknown keys fail
  loudly — and every field a head writes (e.g. adroit's `reference`) is
  declared.

### 3. Validation & strictness

- `validation.type_strictness = "strict"`, always, set at provisioning.
- **The CI gate**: every frontmatter violation class — missing required
  field, unknown type, out-of-enum value, failed `if/then` conditional,
  unknown key — fails `ingest` with exit 1 and a named rule. `lint` exits 1
  on errors, 0 on warnings-only: errors gate, warnings advise. Strict
  ingest bails on the first error (fix-and-rerun semantics).
- **Registry integrity is engine-enforced** (fork): a corrupt
  `schemas/*.json` refuses to mount the wiki, every command exits 1 naming
  the broken file. Evidence: findings/issue-02.

### 4. Status vocabulary

- **Two vocabularies, one substrate.** `decision` uses the adroit-aligned
  lifecycle `proposed | accepted | rejected | deprecated | superseded`;
  content types reuse the engine's `{active, draft, stub, generated}`.
- **State-coupled requirements live in the type schema**:
  `superseded ⇒ superseded_by` via `if/then` fails ingest when violated.
- **`[search.status]` carries both vocabularies** — custom keys rank
  exactly as configured (a superseded page scores 0.30× its accepted
  rival at the recommended weights); provisionable via
  `config set search.status.<key>` (fork). Evidence: findings/issue-03.
- Open sub-question, decided at adroit retrofit time: frontmatter as source
  of truth vs projection, and whether the ADR body keeps `## Status`.

### 5. Anti-rot / lint

- **`decision`: rot is structural, never temporal.** CI gates on strict
  ingest + lint errors (broken-link, duplicate-id, missing-fields,
  unknown-type); orphan stays advisory; review-due for `proposed` is
  head-side. Contradiction detection is semantic → the librarian's
  reconcile step, not deterministic lint.
- **Staleness fires only on explicitly low-confidence pages** (fork
  semantics, intentional): `stale` requires age AND declared
  `confidence < 0.4`. Decisions never declare confidence and are un-stale
  by design; guides get temporal staleness through the confidence flow
  (Part I). Evidence: findings/issue-04.

### 6. Substrate vs head

- **Numbering/sequence is the head's job.** The substrate stores exactly
  two identity fields per decision: `id` (stable ULID routing identity) and
  `reference` (head-owned display identity, `ADR-0006` — no resolution
  semantics). adroit owns allocation, gap/collision detection, and scheme
  choice. The engine never grows ADR-specific features.
- **The read contract**: typed pages addressable by ULID with full-fidelity
  `content read` (CLI and MCP both), plus the `export` machine seam. Heads
  own derived views — numbering/addressing, review-due, plan extraction
  from the marked `## Implementation` region, forge enrichment. Known gap:
  `export` drops custom frontmatter fields
  ([llm-wiki#11](https://github.com/como-technologies/llm-wiki/issues/11));
  interim, summary rows take N+1 reads. Evidence: findings/issue-10 (seam
  map); the numbering finding lives on
  [kb-spike#6](https://github.com/como-technologies/kb-spike/issues/6) itself.

### 7. Admission & evidence

- **The file is the API; a git commit is the unit of admission** — the
  transaction semantics of Part I, verified to run today with two git hooks
  (`ingest --dry-run` pre-commit; `ingest` post-commit) plus
  catch-up-on-read (`index.auto_rebuild`).
- **`evidence/` is the capture layer** (renaming the engine's `raw/`,
  [llm-wiki#10](https://github.com/como-technologies/llm-wiki/issues/10)):
  unstructured material only. Citations are **always pinned `path@commit`**;
  live references are for pages (ids), never evidence. Processed = cited;
  `inbox/` is not part of the contract. Interim rule until the citation
  link kind lands
  ([llm-wiki#8](https://github.com/como-technologies/llm-wiki/issues/8)):
  pinned refs live in a non-edge frontmatter key (`citations:`).
- Evidence: findings/issue-09 (including the hand-walked capture → cite →
  page round trip, with pinned resolution surviving reorganization).

### 8. Architecture: four layers
([ADR-0006](./adr/accepted/0006-package-kb-capability-as-lore-a-shippable-product-layer-between-the-engine-fork-and-kb-instances.md))

- **The fork** (`como-technologies/llm-wiki`, `como-main`): the generic
  engine — upstream plus an upstreamable patch series;
  `feat/stable-page-identity` stays the clean upstream-PR candidate.
  Nothing Como-specific enters the engine.
- **lore** (`como-technologies/lore`, portfolio#5): the Como KB **product**.
  Extends the engine **by dependency, never by patching** (the `llm_wiki`
  library + CLI); owns the Como schema library (starting with `decision`),
  provisioning (pinned engine install, strict validation, hooks, search
  weights), and the ops surface — packaging, deployment, shipping to
  clients, audit/compliance. **Engine pinning happens in lore**; the fork
  stays a moving tip. Routing rule: generic → fork; Como-shaped → lore.
- **KB instances**: near-pure data spaces (`wiki/`, `evidence/`,
  `schemas/` as installed) created, deployed, and managed *with* lore.
  Como's own KB is the first instance — the product's permanent dogfood.
- **The heads**: adroit, tuesday, pulse, and the librarian. Structured
  writers in; seam readers out — always against instances, via the seams.

Open engine work:
[llm-wiki#8–#13](https://github.com/como-technologies/llm-wiki/issues).
Future work (absorbed into
[portfolio#5](https://github.com/como-technologies/portfolio/issues/5)):
append-only enforcement + replay; snapshot-based index sync.
