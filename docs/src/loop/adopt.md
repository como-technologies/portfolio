# Adopt

This is where the playbook meets your teams, your code, and your platforms —
and historically where modernization programs stall. The portfolio's answer
is an engine plus a services wrapper: conduit turns accepted decisions into
reviewable pull requests inside the team's own forge, and Como's services
carry the enablement around it. Humans hold every gate — scope, review,
merge — and deploy stays a human gate outside the loop.

## conduit

**Maturity: dogfooding** — exercised on Como's own work every iteration;
build from source. Moved up from spike at the iteration-2 close; the
gating evidence is the two captured capstone runs,
[run 1](./dogfood/run-1.md) and [run 2](./dogfood/run-2.md).

**What it is.** A forge-neutral, model-neutral, cloud-neutral agentic
development harness. conduit is *not* an agent: it stands on commodity
coding engines and builds only the thin layer they don't have — a
forge-neutral event router, a PR lifecycle state machine, and the forge
adapter. It drives GitHub, self-hosted Gitea, and GitLab identically today, proven
by a shared conformance suite and a byte-identical three-way transcript
diff — forge-neutrality proven at N=3: the GitLab adapter passed the same
suite and diff that gated the claim at N=2 (conduit ADR-0016; GitLab
mutations are dry-run by construction, like GitHub's — Gitea remains the
live lifecycle host). The
iteration-1 spike's acceptance run drove the full loop against a throwaway
local Gitea — reading conduit's own accepted ADRs and working them on
conduit's own repo — with GitHub mutations dry-run by construction;
iteration 2 ran the loop again on the playbook corpus, restart proof
in-thread, plus a live-engine encore whose merged PR was harvested back.

**How it enters the loop.** conduit consumes adroit's read slice — the only
adroit subcommands it ever invokes are `manifest`, `list`, `show`, and
`plan` (enforced by test); it never authors, edits, or transitions an ADR.
It produces merged PRs tagged with the contract below. The validated run, in
its essential beats:

```sh
conduit plan 2 --forge gitea    # adroit handshake → forge issue carrying the stored plan
                                # human gate: a reviewer labels the issue conduit:run
conduit run --forge gitea --once  # Scoped → Coding → InReview: branch, commit, open the PR
                                # human gates: review rounds, then merge
conduit verify 2 --forge gitea -o json  # machine-assert the contract on the merged PR
```

In the captured run all six `verify` checks pass, and the forge-neutrality
beat — the same fixture event sequence through the live Gitea adapter and
the dry-run GitHub adapter — diffs to nothing: `FORGE-NEUTRAL: identical`.

### The conduit → tuesday contract

Every PR conduit merges carries a fixed set of markers; tuesday (the Measure
stage) reads them at report time. This table is the book's one concrete
statement of the contract. The producer side is implemented in conduit's
`src/contract.rs`, and `conduit verify` re-checks every element against the
live forge after merge:

| Element | Value |
|---|---|
| ADR label | `adr:<reference>` — e.g. `adr:ADR-0003` |
| Effort label | exactly **one** of the closed five-value set: `effort:1-super-quick`, `effort:2-not-long`, `effort:3-average`, `effort:4-a-while`, `effort:5-felt-like-forever` |
| PR title | `[ADR-NNNN] <title>` prefix |
| PR body | final line is the trailer `Adr-Reference: ADR-NNNN` |
| Branch | `conduit/<ref-lower>/<slug>` — never adroit's `adr/` namespace (proven by unit test) |

The effort label is **final at merge** — that is the moment tuesday reads
it. How tuesday allocates from these markers, including the two accepted
caveats, is described with [Measure](./measure.md#tuesday).

**Where its evidence lives.** In this book: the per-run pages
[run 1](./dogfood/run-1.md) and [run 2](./dogfood/run-2.md) — six-check
`verify` passes, byte-identical forge-neutral transcripts, a
kill-mid-Coding restart with no duplicate forge actions, and run 2's
live-engine encore. In the conduit repo's book: `docs/src/usage/demo.md` —
the validated end-to-end acceptance run; `docs/src/usage/customer-demo.md`
— the narrated customer demo, backed by the `demo/kit/` scripts
(one-command stand-up, five evidence-printing beats, teardown; both
rehearsals committed verbatim, per its ADR-0015);
`docs/src/dev/forge-contract.md` (the conformance suite all three adapters
must pass); and `docs/src/dev/follow-ups.md` — the spike's seven recorded
residuals, closed as of iteration 2 (six done, one retired by ADR).

## Where services wrap it

The engine alone doesn't change a team's practice. Como's
[Adoption enablement](../services/adoption-enablement.md) service wraps
conduit with pairing, workshops, and incremental rollout — and carries the
parts no engine should own: the scope conversations, the review culture, and
the occasional hard conversation with a stakeholder who'd rather keep the
status quo. The engagement shape that puts the engine to work is the
[Agentic delivery](../services/agentic-delivery.md) pilot.
