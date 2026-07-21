# ADR-0007: Package KB capability as lore, a shippable product layer between the engine fork and KB instances

> State: Superseded

## Status

Superseded by [ADR-0008](../accepted/0008-build-the-kb-product-in-the-fork-itself-developing-on-main.md) — reversed before any lore code existed: the fork itself is the product, developed on `main`, with release tags as the pinning story. The four-layer split and the generic-vs-Como routing rule are retired with it.

## Stakeholders

Portfolio owner (lore is a portfolio member — built and shipped); fork
stewards (lore is the fork's primary consumer and where pinning happens);
head maintainers (adroit, tuesday, pulse, the librarian — talk to KB
instances that lore provisions); clients (lore is how a KB reaches them).

## Context and Problem Statement

[ADR-0006](../accepted/0006-adopt-llm-wiki-engine-como-fork-as-the-knowledge-base-substrate.md)
adopted the Como fork of `llm-wiki-engine` as the KB substrate and sketched
"three layers, three homes": fork, KB repo, heads — with provisioning
(engine install, hooks, weights, schema registration) living inside the KB
repo. Turning that sketch into a repo exposed a conflation: *the thing that
creates, configures, and operates KBs* and *a KB itself* are different
artifacts with different lifecycles. Provisioning-in-the-KB-repo means
every KB instance carries its own copy of tooling, nothing is shippable to
a client as a product, and Como-specific assets have no home that isn't
either the engine fork (polluting it) or a data repo (burying them).

## Decision Drivers

- The portfolio thesis: portfolio members are products we build and ship —
  a KB capability should be sellable ("KBs for anyone, including us"), with
  client-facing concerns (packaging, deployment, audit/compliance) owned by
  a product, not scattered across instance repos.
- The fork's purity rule (ADR-0006): only generic, upstreamable engine work
  lives in the fork. Como-specific code and config need a home that isn't
  the fork.
- One place to pin: instances and clients need a known-good engine version;
  the fork tracks branch tips for development.
- KB instances should be near-pure data — cheap to create, migrate, and
  reason about.

## Considered Options

1. **Provisioning scripts inside each KB repo** (ADR-0006's sketch) — every
   instance carries kb-setup-style tooling and its own schema copies.
2. **lore: a product layer between the fork and instances** — a portfolio
   member that depends on the fork and creates/manages/configures KBs.
3. **Fold Como specifics into the fork** — one repo, maximal convenience,
   fork purity abandoned.

## Decision Outcome

Chosen: **lore, the product layer** (`como-technologies/lore`). The
architecture becomes four layers:

1. **The fork** (`como-technologies/llm-wiki`, `como-main`) — the generic
   engine: upstream plus an upstreamable patch series. Nothing Como-shaped.
2. **lore** — the Como KB product. **Extends by dependency, never by
   patching**: the engine ships a library target (`llm_wiki`) and a CLI, and
   lore builds on those; engine-shaped generic work is contributed to the
   fork instead. lore owns the Como schema library (starting with the
   `decision` type from the spike), provisioning (engine install pinned to a
   known version, strict validation, hooks, search weights), and the ops
   surface: packaging, deployment, shipping to clients, audit/compliance.
   **Pinning happens here** — lore ships a known engine; the fork stays a
   moving tip.
3. **KB instances** — near-pure data spaces (`wiki/`, `evidence/`,
   `schemas/` as installed by lore), created, deployed, and managed *with*
   lore. Como's own KB is simply the first instance — the product's
   permanent dogfood.
4. **The heads** — adroit, tuesday, pulse, the librarian: structured
   writers and seam readers against instances, per the KB spec.

Option 1 makes N copies of tooling and zero products. Option 3 destroys the
fork's upstream optionality and violates ADR-0006's own purity rule. The
product layer is where a distribution belongs — the same pattern as
upstream → distro → installs.

### Positive Consequences

- A sellable portfolio member with a real ops story; audit/compliance become
  product features rather than per-instance afterthoughts.
- The fork's patch series stays clean and upstreamable; the routing rule
  ("generic → fork; Como → lore") gets a concrete destination on both sides.
- Instances become cheap and uniform; migration and multi-KB management are
  product problems solved once.

### Negative Consequences

- One more repo and release surface to maintain; lore needs its own CI and
  versioning discipline.
- Two-hop upgrades (fork → lore → instances) — the price of pinning; lore's
  job is to make that cheap.

## Implementation

Refines the "three layers, three homes" consequence of ADR-0006 (the
substrate decision there is unchanged). The KB spec's architecture section
(`docs/src/kb-spec.md` §8) is updated to the four layers; lore's creation is
tracked in portfolio#5 (product) with Como's own instance as a follow-on
issue. The spike's assets route accordingly: `kb-spike/bin/kb-setup` is
proto-lore provisioning; `kb-spike/schemas/decision.json` seeds lore's
schema library.
