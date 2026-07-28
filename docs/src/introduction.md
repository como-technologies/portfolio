# The TAPS Portfolio — Tools, Apps, Products, and Services

## Modernization with the seams closed

Most modernization programs break at the seams. The assessment dies in a PowerPoint. The prescriptions rot in a wiki nobody trusts. Adoption is unmeasured. Outcomes are invisible six months later — right when the CFO asks what the spend bought. The problem isn't that any single step is done badly. It's that the thread from *where are we?* to *is it working?* gets dropped between artifacts and teams.

## What Como Technologies does

Como Technologies builds and operates a portfolio of **Tools, Apps, Products, and Services** — our TAPS portfolio — designed to keep that thread intact across the full modernization lifecycle. We focus narrowly on two related domains: **software engineering practice** and the **application platforms** that workloads run on (virtualization, containers, Kubernetes, cloud, serverless). Every offering in the portfolio either produces, consumes, or measures artifacts that the others also use — and those artifacts share one substrate: the **Como knowledge base**, typed, schema-validated, machine-readable pages behind mechanical anti-rot gates (the [KB specification](./kb-spec.md)). It's a coherent system, not a menu.

AI runs through the whole loop as working assistance, not decoration: an assistant co-authors the assessment in the interview, drafts and plans decisions in the knowledge base, answers questions over the corpus, and drives an agent from an accepted decision to a reviewable pull request. Every one of those steps is bounded the same way — a deterministic gate validates what a model produces, and a human holds acceptance. And the interface follows from that: **the primary human UI for the portfolio is your own AI harness** — Claude Code, Claude Desktop, or any MCP-capable client — configured with Como's tools over MCP, with the CLIs and native surfaces staying as first-class alternate doors (this book's ADR-0010). The **authoring kit** ships with the KB product — instructions, Como skills, reference configs for Claude Code and Claude Desktop, starter content, and a captured worked example — so a configured harness authors gate-clean content from the first conversation; today Como runs that session with SMEs alongside, and the librarian remains the one future-state piece of the authoring story ([where this is going](./roadmap.md#where-this-is-going)).

## The loop

A Como engagement runs a closed four-stage loop, and the portfolio has purpose-built tooling at each stage. See the [Roadmap](./roadmap.md) for the full walkthrough.

1. **Assess** — Discover current state with [assessments](./loop/assess.md), our AI-assisted authoring tool that turns structured interviews into exportable, schema-validated maturity assessments.
2. **Prescribe** — Record *decisions* and *guidance* in the knowledge base: decisions authored with [adroit](./loop/prescribe.md) — from your harness or the CLI — and seeded mechanically from the assessment export; content classes authored conversationally per the kit's authoring contract. A fresh space starts from the shipped [starter content](./products/starter-content.md), not a blank page.
3. **Adopt** — Turn decisions into shipped code. [conduit](./loop/adopt.md) *(dogfooding)* is the Adopt-stage engine — a forge-neutral agentic harness that reads adroit's ADRs and stored plans and drives an agent to work them as issues and pull requests inside your *own* forge, model, and cloud, exercised end to end on Como's own work every iteration; Como's [services](./services/README.md) will wrap it. This is where the decisions meet your teams, your code, and your platforms.
4. **Measure** — Close the loop with honest signal. [pulse](./loop/measure.md) *(dogfooding, parked at the protocol proof)* captures verified-anonymous sentiment so you hear what people won't say in a town hall; [tuesday](./loop/measure.md) *(SME-usable)* quantifies where engineering capacity is actually going and attributes it back to the deciding ADR.

Then back to Assess. Modernization is a cycle, not a project.

## One substrate under the loop

The knowledge base is not a brochure line — it is how the tools already work, and by decision it is the content product itself (this book's ADR-0010): content is born in the KB through a harness conversation, not maintained in a cloned doc repo. The substrate is [llm-wiki](./kb-spec.md), Como's KB product: one Rust binary, headless and git-backed, with typed pages, strict admission gates, search, a concept graph, and 23 MCP tools — and **no LLM inside**. Every model call happens in the harness and tools around it, which is what keeps the AI steps auditable. adroit operates exclusively against KB spaces today (its ADR-0020) and remains the only writer of decision pages; every suite repo's CI seeds its committed decision corpus into an ephemeral space and validates it there on every run — instances are disposable and built from source at HEAD; the content of record stays in each repo (this book's ADR-0009). The future state, called out honestly as future: the **librarian**, an AI head that files captured evidence, links concepts, and flags contradictions against accepted decisions — the knowledge base organizing itself behind the same deterministic gates ([spec, Part I](./kb-spec.md#part-i--how-content-moves)).

## How we work

**Opinionated, not dogmatic.** We ship defaults because most organizations need a jumpstart — and every piece is designed for BYOx when you already have your own shape.

**AI as leverage, not theater.** Proven patterns, not chatbots bolted to sidebars. AI assistance guides every stage of the loop — and every AI step lands behind a mechanical gate and a human decision.

## The portfolio at a glance

TAPS is the classification; the loop is the navigation. Each offering is
described in its loop-stage chapter — what it is, how it enters the loop,
and where its evidence lives.

| Offering | TAPS | Loop stage | Maturity |
|---|---|---|---|
| [assessments](./loop/assess.md) | App | Assess | SME-usable |
| [adroit](./loop/prescribe.md) | Tool | Prescribe | SME-usable |
| [The knowledge base](./kb-spec.md) | Product | every stage | substrate |
| [Starter content](./products/starter-content.md) | Product | Prescribe | ships with the kit |
| [conduit](./loop/adopt.md) | Tool | Adopt | dogfooding |
| [pulse](./loop/measure.md) | App | Measure | dogfooding (parked) |
| [tuesday](./loop/measure.md) | App | Measure | SME-usable |
| [Services](./services/README.md) | Service | every stage | — |

Maturity badges use one ladder portfolio-wide, recorded as a decision in
this repo's own adroit-managed ADR corpus — the vision repo takes its own
Prescribe medicine:

| Badge | Meaning |
|---|---|
| **spec** | The design is decided and written down; no runnable end-to-end proof yet. |
| **spike** | A runnable end-to-end proof exists, with captured evidence; not yet exercised every iteration. |
| **dogfooding** | Exercised on Como's own work every iteration; build from source. |
| **SME-usable** | An external subject-matter expert can drive it with Como alongside. |
| **self-serve** | Production-grade: a client team runs it without Como in the room. |

A **(parked)** suffix means development is intentionally frozen by a
recorded decision while the dogfood proof is kept green. The knowledge
base carries no ladder rung by design: it is the substrate the badged
apps run against, and its stage — ephemeral-first, built from source at
HEAD — is recorded in this corpus's ADR-0006/0008/0009 rather than graded
on the app ladder; the starter content is content, not an app, and is
graded by its rehearsed bootstrap staying gate-clean instead. The climbs
above dogfooding are gated by evidence in each app's own repo: tuesday
moved at the iteration-3 close; adroit and assessments moved to
SME-usable at the iteration-4 open. conduit stays dogfooding by an honest
call — it has the N=3 forge-neutral engine and the rehearsed
customer-demo kit, but no owner-published remote and no external driver
yet, so the rung waits on owner action. The ladder also records a
retirement: the playbook template earned **self-serve** at the
iteration-3 close and carried it until ADR-0010 retired the product —
the badge retired with it rather than transferring to a successor, and
the harness-first offering will earn its own rung on its own evidence.
Nothing claims a rung its repo can't evidence.
