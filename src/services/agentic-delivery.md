# Agentic delivery (pilot)

The flagship: accepted decisions worked to merged pull requests inside your
*own* forge by an agentic harness — with humans holding every gate. The
engagement shape is simple to say out loud: pick N accepted decisions from
the playbook; each one comes back as a reviewable, decision-tagged PR that
your reviewer merges, or sends back, or rejects.

**Honest tense first.** This is a capability Como is dogfooding, offered as
a pilot engagement — not a shipped product. The engine,
[conduit](../loop/adopt.md), carries a **dogfooding** badge: exercised end
to end on Como's own work every iteration, with captured evidence — not
yet SME-usable. The pilot's promise is the loop you can watch run on
Como's own repos today, applied to a bounded slice of yours.

**Inputs.** Accepted ADRs carrying stored implementation plans — the output
of [Playbook authoring](./playbook-authoring.md). conduit consumes them over
adroit's machine seam (`list`, `show`, `plan`, all `-o json`); it never
authors, edits, or transitions a decision. If it isn't an accepted ADR, it
isn't in scope — the engine enforces that itself.

**Tool.** [conduit](../loop/adopt.md) *(dogfooding)* — a forge-neutral,
model-neutral, cloud-neutral agentic development harness driving GitHub,
self-hosted Gitea, and GitLab identically (forge-neutrality proven at N=3;
GitLab and GitHub mutations are dry-run by construction, Gitea is the live
lifecycle host). The evidence is captured in the conduit book's demo
walkthroughs (`docs/src/usage/demo.md` and the kit-backed
`docs/src/usage/customer-demo.md` in the conduit repo): validated runs with
all six `verify` checks passing, byte-identical forge-neutral transcripts
(`FORGE-NEUTRAL: identical`), and a kill-mid-run restart with no duplicate
forge actions. The [Adopt](../loop/adopt.md) chapter summarizes those runs
and states the PR contract.

**Artifact out.** Merged, contract-tagged pull requests in your own forge:
`[ADR-NNNN]` title prefix, the decision's `adr:` label, exactly one effort
label, and an `Adr-Reference` trailer — every change traceable to the
decision that prompted it, machine-verified after merge by
`conduit verify`. You keep the full audit trail, because it lives in your
forge, not in our tooling.

## The human gates are the product

Three gates, by name. They aren't a safety disclaimer bolted onto an
agent — they're what you're buying. You never have to trust an agent; you
have to review a pull request, which your team already knows how to do.

1. **The scope gate.** Nothing runs until a human says so. conduit posts the
   decision's stored plan as a forge issue and stops; only a reviewer
   labeling that issue `conduit:run` authorizes work. You read the plan
   before any code exists.
2. **The review gate.** Every change arrives as a PR in your own forge,
   under your own review tooling. Request changes and the harness revises;
   review rounds are the designed path, not an exception path.
3. **The merge gate.** Only a human can merge. conduit has no merge
   method — the gate isn't policy, it's structurally unrepresentable in the
   tool. In the dogfood forge, the actor account can't even approve its own
   PRs.

And deploy stays a human gate *outside* the loop entirely — the engagement
ends at merged, not at shipped-to-production.

**Measure hooks.** Built in, not bolted on. tuesday's monthly report rolls
measured hours up per decision from the PR tags (its `--strict` mode exits
nonzero if any merged PR is unaccounted for), and conduit's `verify` plus
tuesday's report are two independent codebases agreeing about the same
merged PR — the loop's double-entry bookkeeping. pulse adds the qualitative
axis on the same cadence. What each decision cost, and how the team felt
about it, land in the same Measure artifacts the next
[assessment](./assessment.md) starts from.

**Engagement shape.** Pilots are scoped as N accepted decisions worked to
merged PRs in a bounded window, alongside
[Adoption enablement](./adoption-enablement.md) for everything an engine
shouldn't own. The unit of value is a merged, decision-tagged PR — adoption
you can count, not activity you have to take on faith.
