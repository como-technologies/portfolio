# KB substrate spike — llm-wiki-engine over playbook content (portfolio issue 3)

Date: 2026-07-04/05 (UTC). Bounded spike for the owner-ratified issue-3 proposal
(Como KB as a first-class TAPS node) **with the referee's INVERSION**: the KB
"decision" page class is defined AS adroit's existing corpus contract — adroit
keeps owning its format; the KB never writes decision pages.

- Substrate: **llm-wiki-engine v0.4.1** (crates.io), binary `llm-wiki`.
- adroit under test: **0.2.0 @ 683049b** (repo HEAD, clean tree,
  `target/release/adroit` built after the HEAD commit).
- conduit pin: **cc43754** (`conduit/adroit.rev` → `.conduit/bin/adroit`, also 0.2.0).
- Sandbox instance (session-scoped, not committed):
  `kb-spike/` — wiki repo `kb/` (space `comokb`), playbook content copied minus
  `.git` and minus `ci/banned-terms.txt` (never read, never copied).

## Verdict summary

| # | Gate | Verdict |
|---|------|---------|
| 1 | Install substrate | GREEN — `cargo install llm-wiki-engine --locked` → v0.4.1 in 3m05s |
| 2 | Stand up wiki over playbook content | GREEN — 3 guides + 10 glossary entries + section page typed & schema-validated; ADR corpus resident at `wiki/decisions/` |
| 3 | Engine lint | PARTIAL — 0 errors on every KB-authored typed page; 10 invariant `broken-link` errors, all inside the adroit corpus (file-relative links vs the engine's slug-only link model) |
| 4 | adroit read slice over KB-resident corpus | GREEN — check/manifest/list/show/plan all normal, stored-plan read byte-identical to the source-repo hash |
| 5 | Write round-trip + unknown-key destruction | GREEN (demonstrated) — one `set-status` on the frontmatter profile silently destroys `type:` + `kb_links:`; markdown profile preserves a foreign block (minimal-diff writes) but the engine then refuses the page; lint error set invariant across all adroit writes |
| 6 | conduit contract tests | GREEN — verbatim `CONDUIT_E2E_ADROIT=1` suite 5/5; exact chokepoint invocation replicated against the KB-resident corpus passes all contract assertions (corpus path in the E2E test itself is hardcoded — documented below) |

## Gate 1 — install

```
$ cargo install llm-wiki-engine --locked
    Finished `release` profile [optimized] target(s) in 3m 05s
   Installed package `llm-wiki-engine v0.4.1` (executable `llm-wiki`)
$ llm-wiki --version
llm-wiki 0.4.1
```

## Gate 2 — stand-up

```
$ llm-wiki spaces create <sandbox>/kb --name comokb --set-default
Created wiki "comokb" at <sandbox>/kb
Initial commit: create: comokb
```

Engine layout: repo root `kb/` (git-backed, engine commits on ingest),
content root `kb/wiki/`, type schemas at `kb/schemas/*.json`
(auto-discovered; `llm-wiki schema validate` → `ok`; `schema list` shows
`decision`, `guide`, `glossary-entry` registered beside the defaults).

Ported as typed pages (frontmatter per engine conventions, links rewritten to
root-relative slugs): `guides/adopt-read-path`, `guides/adopting-this-playbook`,
`guides/adr-review-process` (type `guide`), ten `glossary/*` pages (type
`glossary-entry`), `glossary/README` (type `section`). The real adroit-managed
corpus (`playbook docs/src/adr`, markdown/by-status profile) copied verbatim to
`kb/wiki/decisions/` — 18 ADRs + per-status READMEs, untouched.

### Draft schemas

- `guide.json` (KB-owned design): required `title`,`type`,`summary`; typed
  edges `decisions` (relation `operationalizes` → decision) and `terms`
  (`uses-term` → glossary-entry); `additionalProperties: true`.
- `glossary-entry.json` (KB-owned design): required `title`,`type`,`summary`;
  edge `defined_by` (`defined-by` → decision).
- `decision.json` — **derived from adroit's actual contract**, field by field:

| Field | Type | adroit source |
|-------|------|---------------|
| `id` | string uuid, required | `Frontmatter.id: AdrId` frontmatter.rs:16; `AdrId(Uuid)` adr.rs:16 |
| `number` | integer ≥1, required | frontmatter.rs:17; `Number(u32)` adr.rs:43; serialize refuses without it (frontmatter.rs:39,52) |
| `title` | string, required | frontmatter.rs:18 |
| `status` | enum Proposed/Accepted/Rejected/Deprecated/Superseded (PascalCase), required | frontmatter.rs:19; `Status` adr.rs:216-228, no serde rename |
| `created` | string RFC 3339, required | frontmatter.rs:20; `Created(OffsetDateTime, rfc3339)` adr.rs:69 |
| `supersedes` / `superseded_by` | AdrRef, optional | frontmatter.rs:21-24 |
| `relates_to` / `depends_on` / `refines` | AdrRef[], omitted when empty | frontmatter.rs:25-30 |
| `review_by` | string date YYYY-MM-DD, optional | frontmatter.rs:31-32; `ReviewBy(Date)` adr.rs:100-105 |
| (AdrRef) | untagged integer \| slug string | naming.rs:27-32 (`#[serde(untagged)]`) |

`additionalProperties: false` — deliberate: adroit's `Frontmatter` is a plain
serde derive with **no unknown-key preservation** (frontmatter.rs:14-33) and
`serialize` emits exactly the declared fields (frontmatter.rs:51-78), so
foreign keys are not merely unspecified, they are destroyed on write (gate 5).
The engine's `type:` routing key is allowed as a documented exception the KB
must never rely on. Note the playbook instance uses adroit's **markdown**
profile (no frontmatter at all — `format.rs`), so this schema describes the
frontmatter-profile variant; in the real instance decision pages are typed by
corpus location.

## Gate 3 — engine lint

`llm-wiki ingest .` validates and commits (exit 0). Every no-frontmatter corpus
page warns `no frontmatter found`; typed-edge targets inside the corpus warn
`has type '', expected ["decision"]` (warnings, not errors).

```
$ llm-wiki lint --format json     (after index rebuild, 39 pages)
errors: 10  warnings: 29
('broken-link','error') 10        ('orphan','warning') 29
```

**All 10 errors are inside `decisions/`** (verified: every error slug has the
`decisions/` prefix; zero errors on KB-authored pages). Each one is an
adroit-style *file-relative* markdown link (`../accepted/0001-….md`,
`../../guides/adr-review-process.md`): the engine's link model is
root-relative-slug-only (`links.rs` compares raw destinations against index
slugs; no relative resolution). Rule-scoped lint is clean:

```
$ llm-wiki lint --rules missing-fields,unknown-type,stale --format json
errors: 0  warnings: 0  total: 0
```

(Caveat discovered: `--rules broken-cross-wiki-link` re-activates the whole
shared broken-link pass — lint.rs:107 — so it cannot be used to scope the
within-wiki rule out.)

**Why not fix the 10:** the links belong to adroit — `relink`/`set-status`
maintain them in file-relative form, so rewriting them to engine slugs both
crosses the ownership line and gets reverted by the next adroit heal. v0.4.1
has no path-scoped lint exclusion (no exclude config in `config.rs` /
`index_manager.rs`). Honest conclusion: with the corpus **inside** the engine's
content root, full-default lint cannot reach 0 errors; the KB gate must either
scope lint by rule/path on the consumer side or house the corpus in the KB
repo *outside* the content root (losing slug-addressable links INTO decisions,
which currently resolve and are the useful half of the graph).

## Gate 4 — adroit read slice over the KB-resident corpus

adroit 683049b `--dir kb/wiki/decisions`:

```
check -o json     → {"checked": 18, "problems": []}                (exit 0)
manifest -o json  → {"tool":"adroit","version":"0.2.0","manifest_schema":1}
list --status accepted -o json → 7 rows (ADR-0001..5, 13, 14), superseded_by null
show 4 -o json    → full 16-key shape, status Accepted, body 6463 B, plan present
plan 4 -o json    → {"reference":"ADR-0004", stored:true, plan 2061 B}
```

Determinism: `plan 4 -o json` twice → sha256
`d33936ca1e9a914c6a817e544b42615738e4637b56c389f7c7cdf18ab14578fa` both runs —
**the same hash the playbook's Adopt-Read-Path guide documents against the
original corpus** (adopt-read-path.md §3). KB residence changes nothing on the
read slice.

## Gate 5 — write round-trip + unknown-key destruction

**A. Real write, lint invariance.** `set-status 6 accepted` (moved
`proposed/0006-continuous-integration.md` → `accepted/`; `check` stays 18/0).
Engine re-ingest commits the move; lint before/after: errors 10→10,
**new errors: none, resolved: none** (warning delta later in the run: 2 new
`orphan` warnings — the moved 0006 slug and the gate-5B2 pilot page).

**B1. Markdown profile (the playbook's actual profile).** Prepended a KB
frontmatter block (`type: decision`, `kb_links: [glossary/decision-record]`)
to KB-resident `accepted/0002…`. adroit `check`: still 18/0. adroit write
(`set-review 2 2026-08-01`): the block **survives** — diff shows only
`+ Review by: 2026-08-01` (markdown-profile writes are minimal-diff and never
touch a leading block). But the engine now refuses the page:

```
$ llm-wiki ingest decisions/accepted/0002-….md --dry-run
Error: title is required          (exit 1)
```

— once ANY frontmatter exists, the engine validates it against the routed
class; adroit's markdown profile will never supply the class's required keys.
So even in the profile where foreign keys happen to survive, tagging
adroit-owned pages with engine keys is a dead end. (Page restored afterwards.)

**B2. Frontmatter profile — the destruction, concretely.** Fresh corpus
`kb/wiki/decisions-fm` via `new --format frontmatter --no-edit`; added foreign
keys exactly as a KB agent would; then ONE adroit write:

```
$ adroit --dir …/decisions-fm --format frontmatter set-status 1 accepted
$ diff before after
5c5
< status: Proposed
---
> status: Accepted
7,10d6
< type: decision
< kb_links:
<   - glossary/decision-record
<   - guides/adr-review-process
```

`type:` and `kb_links:` are **gone** — exactly what frontmatter.rs:14-33
predicts (no flatten/extra map; serialize emits only the 11 declared fields).
The failure is **silent on both sides**: adroit exits 0, and the engine's
follow-up ingest only *warns* (`missing field: type (defaulting to "page")`,
`"type" is a required property`, and a bonus collision —
`"Accepted" is not one of "active", "draft" …`: the engine's base-class
`status` enum and adroit's `status` field fight over the same key). The page
silently drops out of its class; no lint ERROR fires. This is the load-bearing
evidence for the inversion: **the KB must never store class/link metadata in
adroit-owned pages** — decision pages are typed by corpus location, KB→decision
links live on the KB side only (KB pages already link INTO corpus slugs today,
gate 3), and any decision→KB backlink would need an adroit-side feature, not a
KB-side write.

## Gate 6 — conduit contract gate

Resolution (read, not modified): binary — `CONDUIT_ADROIT_BIN` env override,
else pinned `.conduit/bin/adroit` (src/adroit.rs:93-98); corpus for the E2E
test — **hardcoded** `tests/fixtures/corpus` (tests/adroit_contract.rs:194).
There is no env seam for the corpus, so the test file itself cannot be pointed
at the KB copy without modifying conduit (not allowed). Two-leg evidence:

**Leg 1 — verbatim suite (pinned binary, fixture corpus):**

```
$ CONDUIT_E2E_ADROIT=1 cargo test --test adroit_contract
running 5 tests … test pinned_adroit_against_fixture_corpus ... ok
test result: ok. 5 passed; 0 failed
```

**Leg 2 — the exact chokepoint invocation (src/adroit.rs:231-250: env-cleared
child keeping PATH/HOME, `ADROIT_DIR=<corpus>`, `ADROIT_AI_ENABLED/PROVIDER/
MODEL` per AdroitConfig defaults ollama/llama3.2, argv `<verb> … -o json`),
pinned binary, KB-resident corpus:**

```
manifest → tool adroit, manifest_schema 1        handshake PASS
list --status accepted → 8 rows, all contracted fields, 8 after
  superseded_by-null filter (addresses 1,2,3,4,5,6,13,14)        PASS
show 4 → status Accepted, body non-empty → require_accepted PASS
show 7 → status Proposed → NotAccepted rejection PASS
plan 4 → PlanEnvelope {reference ADR-0004, stored true, 2061 B}  PASS
```

All four ALLOWED_SUBCOMMANDS (`manifest`,`list`,`show`,`plan` —
src/adroit.rs:12) behave identically over KB-resident pages. The stored-plan
read needed no provider (short-circuits before ollama, as designed).

## What this means for the ADR (drafted separately, not committed)

1. **Spec-first, adopt-substrate-later.** The engine works as a container and
   read seam today, but two model clashes are structural: relative-vs-slug
   links (gate 3) and the shared `status`/`type` frontmatter keys (gate 5).
   Enter the ladder at the "spec" rung; pin llm-wiki-engine 0.4.x as the
   candidate instance substrate, not a dependency.
2. **The inversion holds and is now evidence-backed.** decision pages: adroit
   is the only writer; class membership by corpus location; KB metadata about
   decisions lives outside decision pages.
3. **Corpus placement is the open trade** (inside content root: full inbound
   slug links, 10 unfixable lint errors; outside: clean lint, no typed links
   into decisions). The spec should require a path/rule-scoped lint gate
   either way.

Artifacts (sandbox, session-scoped): `kb/` instance, `lint-1.json` /
`lint-2-after-set-status.json` / `lint-3-final.json`, `0002-before-write.md`,
`fm-0001-before-write.md`, `plan4-{a,b}.json`, ADR draft + issue-3 summary
drafts.
