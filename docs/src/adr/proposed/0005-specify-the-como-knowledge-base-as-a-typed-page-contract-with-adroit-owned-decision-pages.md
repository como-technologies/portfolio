# ADR-0005: Specify the Como knowledge base as a typed-page contract, with adroit-owned decision pages

> State: Proposed

## Status

Proposed

## Stakeholders

Portfolio owner (decides the new TAPS node and its ladder entry); adroit
maintainers (the decision page class is defined as their contract); conduit
maintainers (their read seam is the acceptance test); playbook authors (the
playbook becomes the first KB instance); prospective client readers (the
self-serve badge's evidence ultimately lives here).

## Context and Problem Statement

The portfolio needs a Como knowledge base as a first-class TAPS node: typed
page classes (decision, guide, glossary-entry, worked-example, plan),
JSON-Schema frontmatter per class, typed link kinds, an index contract, a
lint contract, and a machine-readable read seam. The playbook is the first
instance. Today only decisions have a real substrate (adroit's corpus);
guides and glossary pages have no schema, no link discipline, and no
staleness check — the "wiki that slowly rots" our own playbook chapter warns
against. A candidate substrate exists: llm-wiki-engine (crates.io v0.4.x —
git-backed Markdown wiki, per-type JSON-Schema frontmatter validation, typed
graph edges, deterministic lint, MCP/ACP read seam, BYO-LLM).

Two facts constrain the design, both spike-evidenced (local evidence ledger,
spikes/2026-07-04-kb-substrate-spike.md):

- adroit's frontmatter struct preserves NO unknown keys — a single adroit
  write silently destroys any foreign frontmatter field (demonstrated: one
  `set-status` dropped a foreign `type:` and `kb_links:`; adroit exits 0,
  the engine only warns). The playbook corpus additionally uses adroit's
  no-frontmatter markdown profile, where engine-required keys can never
  exist at all.
- The read seam that must survive is conduit's: adroit invoked with the
  allowlist {manifest, list, show, plan}, `-o json`. The spike ran this
  contract green over a KB-resident corpus copy — byte-identical stored-plan
  reads included (same sha256 the adopt-read-path guide documents).

## Decision Drivers

- The durable asset must be OUR specification, not a dependency on a
  ten-week-old single-maintainer crate.
- No second decision substrate: exactly one tool may write decision pages,
  or the corpus contract stops being a contract.
- The conduit read slice is a frozen seam; any layering that breaks it is
  wrong by definition.
- Anti-rot must be mechanical (lint in CI), matching the verify-claims
  culture (ADR-0003).

## Considered Options

- **Adopt llm-wiki-engine now, as a dependency.** Rejected: two structural
  clashes bar it today — (a) its link model is root-relative-slug-only while
  adroit maintains file-relative links, so a corpus inside the engine's
  content root carries permanent broken-link lint errors that adroit's own
  `relink` would re-create if "fixed"; (b) its base-class `status`/`type`
  keys collide with adroit's frontmatter fields (`Accepted` is not a valid
  engine lifecycle state).
- **Adapt (fork/patch the engine).** Rejected for now: a fork for link
  resolution and lint scoping is real maintenance for a node not yet
  specified; revisit once the spec is stable.
- **Extend adroit into the KB.** Rejected: crosses the adroit/conduit scope
  line and bloats a tool whose value is owning exactly one page class.
- **Spec-only entry with a pinned candidate substrate.** Chosen — the spike
  proved the read seam and the instance shape without taking the dependency.

## Decision Outcome

**Spec-only entry, at the "spec" rung of the maturity ladder** (ADR-0002):
we record the KB page-class contract as our specification; we do not adopt a
substrate as a dependency now.

1. **The inversion is normative.** The `decision` page class is DEFINED AS
   adroit's existing corpus contract (both profiles). adroit remains the
   only writer of decision pages. Class membership is by corpus location,
   never by a frontmatter `type:` key. KB metadata about a decision
   (kb-links, tags, class routing) lives outside the decision page — in
   KB-side pages that link INTO the corpus. Any decision→KB backlink is an
   adroit feature request, not a KB write.
2. **KB-owned classes** (`guide`, `glossary-entry`, later `worked-example`,
   `plan`) get JSON-Schema frontmatter contracts. The spike produced drafts
   for `guide` and `glossary-entry`, plus a `decision` schema derived
   field-by-field from adroit's frontmatter struct with source citations.
3. **Substrate posture: pinned candidate, not dependency.** llm-wiki-engine
   0.4.x is the reference substrate the spec is exercised against, pinned
   per the house pattern and forkable as plan B.
4. **The lint contract is two-lane.** adroit `check` gates the corpus; the
   engine (or successor) lints KB-owned pages. The KB gate must be path- or
   rule-scoped so neither lane's rules apply to the other lane's pages.

### Positive Consequences

- The decision class needs no migration — the playbook corpus is already
  conformant by definition, and conduit's contract is untouched.
- KB classes can evolve their schemas without touching adroit.
- "Is this a playbook" becomes a schema check a gate can enforce, the same
  move that made the Assess→Prescribe hand-off durable.

### Negative Consequences

- No single tool lints the whole KB; the two-lane gate is ours to wire and
  keep honest.
- Cross-lane links are asymmetric: KB→decision links are typed and checked;
  decision→KB links are plain prose links adroit already maintains.
- Substrate drift is a live risk — the spec must stay substrate-neutral
  enough that replacing the engine is a swap, not a rewrite.

## Implementation

The bounded spike (evidence in the local ledger) installed the candidate
substrate, stood a wiki space up over a copy of the playbook content (3
guides, 10 glossary entries, a section page — typed and schema-validated),
ran the engine's lint (0 errors on every KB-authored page; 10 invariant
corpus-side link-model errors, documented as the structural clash above),
proved the full adroit read slice over the KB-resident corpus, and ran
conduit's contract legs green against it. Next steps when this ADR is
accepted: write the spec chapter (page classes, link kinds, index and lint
contracts, read seam), then re-grade the playbook against it as instance
zero.
