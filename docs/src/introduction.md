# The TAPS Portfolio — Tools, Apps, Products, and Services

## Modernization with the seams closed

Most modernization programs break at the seams. The assessment dies in a PowerPoint. The playbook rots on Confluence. Adoption is unmeasured. Outcomes are invisible six months later — right when the CFO asks what the spend bought. The problem isn't that any single step is done badly. It's that the thread from *where are we?* to *is it working?* gets dropped between artifacts and teams.

## What Como Technologies does

Como Technologies builds and operates a portfolio of **Tools, Apps, Products, and Services** — our TAPS portfolio — designed to keep that thread intact across the full modernization lifecycle. We focus narrowly on two related domains: **software engineering practice** and the **application platforms** that workloads run on (virtualization, containers, Kubernetes, cloud, serverless). Every offering in the portfolio either produces, consumes, or measures artifacts that the others also use. It's a coherent system, not a menu.

We leverage AI where it provably removes drudgery — synthesizing interview notes into structured assessments, drafting ADRs and their implementation plans — and nowhere else. This isn't AI hype. It's current state-of-the-art applied in proven, repeatable patterns that just work.

## The loop

A Como engagement runs a closed four-stage loop, and the portfolio has purpose-built tooling at each stage. See the [Roadmap](./roadmap.md) for the full walkthrough.

1. **Assess** — Discover current state with [assessments](./loop/assess.md), our AI-assisted authoring tool that turns structured interviews into exportable, schema-validated maturity assessments.
2. **Prescribe** — Produce an opinionated playbook of decisions and guides, authored with [adroit](./loop/prescribe.md) and seeded mechanically from the assessment export. The generic [playbook template](./products/playbook.md) *(self-serve)* is the product a team clones; [palette-playbook](./products/README.md) is a delivered example of the format.
3. **Adopt** — Turn decisions into shipped code. [conduit](./loop/adopt.md) *(dogfooding)* is the Adopt-stage engine — a forge-neutral agentic harness that reads adroit's ADRs and stored plans and drives an agent to work them as issues and pull requests inside your *own* forge, model, and cloud, exercised end to end on Como's own work every iteration; Como's [services](./services/README.md) will wrap it. This is where the playbook meets your teams, your code, and your platforms.
4. **Measure** — Close the loop with honest signal. [pulse](./loop/measure.md) *(dogfooding, parked at the protocol proof)* captures verified-anonymous sentiment so you hear what people won't say in a town hall; [tuesday](./loop/measure.md) *(SME-usable)* quantifies where engineering capacity is actually going and attributes it back to the deciding ADR.

Then back to Assess. Modernization is a cycle, not a project.

## How we work

**Opinionated, not dogmatic.** We ship defaults because most organizations need a jumpstart — and every piece is designed for BYOx when you already have your own shape.

**AI as leverage, not theater.** Proven patterns, not chatbots bolted to sidebars. We apply AI where it materially reduces the cost of doing work that has to be done anyway.

## The portfolio at a glance

TAPS is the classification; the loop is the navigation. Each offering is
described in its loop-stage chapter — what it is, how it enters the loop,
and where its evidence lives.

| Offering | TAPS | Loop stage | Maturity |
|---|---|---|---|
| [assessments](./loop/assess.md) | App | Assess | SME-usable |
| [adroit](./loop/prescribe.md) | Tool | Prescribe | SME-usable |
| [The playbook](./products/playbook.md) | Product | Prescribe | self-serve |
| [palette-playbook](./products/README.md) | Product | Prescribe | delivered artifact |
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
recorded decision while the dogfood proof is kept green. The climbs above
dogfooding are gated by evidence in each app's own repo: tuesday and the
playbook template moved at the iteration-3 close (SME-usable and self-serve
respectively); adroit and assessments moved to SME-usable at the
iteration-4 open. conduit stays dogfooding by an honest call — it has the
N=3 forge-neutral engine and the rehearsed customer-demo kit, but no
owner-published remote and no external driver yet, so the rung waits on
owner action. Nothing claims a rung its repo can't evidence.
