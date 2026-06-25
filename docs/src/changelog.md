# Iteration changelog

One entry per iteration, written at the iteration's close. Each entry
records the same four things: what shipped, the **badge moves** with the
evidence that gated them, the **corrections** the iteration forced on
earlier claims, and the **run pointer** to the captured capstone evidence.
A badge never moves here without its evidence link — this page is the
ledger's per-iteration index, not release notes.

## Iteration 4 — what shipped

**The final buildable wave.** Iteration 4 was one short wave, not a campaign:
the iteration-3 re-grade left the matrix at 61 PASS / 2 PARTIAL / 0 FAIL and
declared the buildable list nearly exhausted. This wave cleared run-3's four
recorded warts and lifted the last two ready badges, after which every
remaining item is an owner action (publish/reconcile, counsel, real-SME
pilots) — the suite's local-work completion point.

- **adroit C3** — sanitizer drop telemetry: `import --ai` now surfaces per-rule
  drop counts (an additive `sanitized` field, `manifest_schema` unchanged), so
  "the model emitted nothing bad" and "the sanitizer ate it" are distinguishable
  from artifacts.
- **assessments B6** — the author elapsed timing was already on the monotonic
  clock; the WSL2 "drift" was an operator-stopwatch comparison, not a bug. The
  contract is now documented so a refactor can't regress it.
- **conduit A4** — `REPO_NAME` knob templates the generated demo `conduit.toml`
  (no more hand-sed for a non-default corpus repo), and the process-group-kill
  test margins widened 5s→15s so the gate is robust under parallel-build load.
- **pulse P1** — the iteration-3 retro question folded into the survey (5
  batches), same-seed dogfood byte-identical.

**Badge moves.** Two more climbs, graded against the ladder (this repo's
ADR-0002), each gated by evidence in its own repo and pinned in
`scripts/verify-claims`. **adroit, dogfooding → SME-usable**: the v0.2.0 tagged
release (ADR-0012), build-from-source as the recorded install path (ADR-0013),
a 19-ADR self-managed corpus, and three full-loop runs of live `import --ai`
plus provider-free stored-plan determinism. **assessments, dogfooding →
SME-usable**: the live-rehearsed facilitated walkthrough, the operating-model
decision (ADR-0009), quality gates proven under attack and live in run-3,
upload wiring, the provider-aware picker, and `--jobs` parallel authoring.
**conduit holds at dogfooding** — same honest call: no owner-published remote,
no external driver yet.

**Run pointer.** No run-4 capstone — by the re-grade's own guidance, a fourth
full loop would exercise no new seam (the loop has three committed proofs). The
wave's verification is folded into each lane's gate.

## Iteration 3

**Wave 1 — what shipped.** Five branches merged to their repos' local
mains, each behind its full gate. conduit landed the GitLab REST v4
adapter behind the same conformance suite and transcript diff that gated
the claim at N=2, recorded the adapter's record-only-behind-DryRun design
as its ADR-0016, and widened the kit's adopt beat to a **three-way**
forge-neutrality diff — **N=3**. adroit hardened its sanitizer against
novel whole-line bracket placeholders and pinned `num_ctx=8192` on every
ollama request (the silent-truncation guard). assessments grew an
adversarial fault-injection harness over the full author pipeline and
closed the three gate gaps it exposed. tuesday shipped the
`--from`/`--to` multi-month range as an additive envelope of unchanged
per-month reports (its ADR-0007), the SME quickstart and self-host pages,
and retired the GCP machinery, built-in scheduling, and Gitea OAuth by
ADR (its ADR-0008–0010). The playbook accepted ADR-0014 — scoping the
self-serve rung to the content product — taught `scripts/init --fresh`
the per-class reset it records, and seeded four fresh Proposed starters.

**Badge moves.** Two moves, graded against the ladder (this repo's
ADR-0002). **The playbook, dogfooding → self-serve**: a fresh copy
initializes and passes its full gate without Como in the room —
`just template-check` rehearses the documented first-clone steps in a
pristine temp copy and requires `just ci` green — with the claim scoped
by playbook ADR-0014 (the content product; adroit recommended, not
required) and an 11-record Proposed starter backlog shipping beyond the
five accepted worked examples. **tuesday, dogfooding → SME-usable**:
iteration 2 named tuesday's open cells — no SME quickstart, no
multi-month range — and both are closed: the quickstart
(`docs/src/usage/quickstart.md`) takes an external SME from a fresh clone
to a capacity report over their *own* forge, both command shapes verified
against live forges (GitHub, and Gitea 1.24); the `--from`/`--to` range
landed (its ADR-0007); the retirement ADRs cut the surface to the
generic, local-first self-host story; and the repo has an owner-published
remote an outsider can fetch.

**SME-usable was considered and declined again for conduit**, N=3
notwithstanding. The customer-demo kit, the narrated demo page, and the
three-way forge-neutrality proof are exactly the drive-it-yourself shape
the rung needs, but the iteration-2 blockers stand unchanged: conduit
(and the playbook corpus its demo drives) has no owner-published remote —
an outsider cannot fetch what a quickstart would assume — and no external
SME has driven it. What flips it: published remotes plus a
fetch-and-drive quickstart an external SME actually follows with Como
alongside. conduit holds at **dogfooding**; a badge moves on evidence,
not proximity.

**Corrections.** The forge-neutrality claim widened from N=2 to N=3
everywhere the book states it (the Adopt chapter and the Agentic-delivery
service page) — exactly the flip `scripts/verify-claims` was armed for:
the two-sided pin went red against the merged conduit until the book
widened the claim on conformance evidence, and the assertion now pins
`--forge` to exactly [gitea, github, gitlab]. The playbook chapters'
corpus description caught up with the corpus: five accepted worked
examples, three carrying stored plans (previously stated as four and
two). The introduction's "nothing is SME-usable or self-serve yet" line
is gone with the badge moves.

**Run pointer.** [Run 3](./loop/dogfood/run-3.md) — the iteration-3 capstone
(`docs/iteration-3/run-3/`): the gates fired live for the first time (a
bounded failure, then recovery), N=3 byte-identical in-loop, multi-month
Measure's first in-loop use, zero mid-run code fixes.

## Iteration 2 — what shipped

A referee-sequenced arc over the suite's definition-of-done matrix. The
iteration opened with integration: every repo's iteration-1 side branches
consolidated onto its local main, and one uniform cross-repo resolution
convention adopted suite-wide — env override, then sibling checkout, then
a pinned clone cache, then skip-with-notice — recorded as an accepted ADR
in each repo that resolves another (this repo's ADR-0004). Eight quality
lanes distilled from run 1's warts then landed across the apps:
assessments grew degeneracy, dedupe, and leakage gates plus the `num_ctx`
fix; adroit's sanitizer strips chat residue and skeleton echoes, its lint
accepts both section-depth shapes, and creation dates became
document-persisted — released together as **v0.2.0**, the tag conduit's
adroit pin then advanced to; tuesday pinned the dogfood report's
`--monthly-hours 160` and made its web head forge-neutral; conduit
retargeted its demo at the real playbook corpus (parameterized seeding,
per-run workdirs), then packaged the whole engagement as the **customer
demo kit** — one-command stand-up, five evidence-printing beats,
teardown, both rehearsals committed verbatim, design rules in its
ADR-0015. pulse's parked-at-M0 state was formalized as suite-done (its
ADR-0010), and the iteration-2 retro question was folded into its dogfood
survey. [Run 2](./loop/dogfood/run-2.md) closed the iteration: the full
loop again, a third faster at Assess with zero retries and zero context
leakage, prescribing into the playbook itself, the restart proof folded
in-thread, the loop-closure cross-check passing twice, and a live-engine
encore whose merged PR was harvested back into the playbook.

**Badge moves.** One move, graded against the ladder (this repo's
ADR-0002): **conduit, spike → dogfooding**. The rung's definition —
exercised on Como's own work every iteration, build from source — is met
by two captured capstone runs: [run 1](./loop/dogfood/run-1.md) (the
merged contract-tagged PR and six-check `verify` pass) and
[run 2](./loop/dogfood/run-2.md) (the same proof twice over — the
FakeEngine thread with its kill-mid-Coding restart, and the live-engine
encore — both independently cross-checked against tuesday), with the
customer demo kit as the repeatable harness around them.

**SME-usable was considered and declined** — for conduit and for every
other node. The rung requires that an *external* subject-matter expert
can drive the tool with Como alongside. conduit's narrated customer-demo
page and kit are exactly the drive-it-yourself shape that rung needs, but
what's missing is real: no external SME has driven it, conduit and the
playbook have no owner-published remotes (an outsider cannot fetch what a
quickstart would assume), and the forge-neutrality claim an engagement
would lean on is proven at **N=2** — Gitea and GitHub, byte-identical
transcripts — with the third implementation (GitLab) queued, not landed.
tuesday, adroit, and assessments likewise hold at **dogfooding**: their
SME-usable cells in the iteration's done-matrix remain partly open
(tuesday has no SME quickstart and no multi-month range; adroit's and
assessments' external-driver evidence does not exist), and a badge moves
on evidence, not proximity. pulse stays **dogfooding (parked)** by
recorded decision, now pinned to its accepted ADR-0010.

**Corrections.** The Adopt chapter's "seven residuals gate production
use" went stale mid-iteration — conduit closed the list (six done, one
retired by ADR), and the chapter now says so. Forge-neutrality wording
was tightened wherever it appears: proven at N=2, GitLab queued — and
`scripts/verify-claims` now pins both sides of that claim, going red the
day a GitLab adapter lands without the book widening it on conformance
evidence. The introduction's "(spike complete)" hedge is gone with the
badge move.

**Run pointer.** The capstone's evidence page is
[Run 2 — the iteration-2 capstone](./loop/dogfood/run-2.md); the captured
artifacts — 28 files plus the run's loop summary — live in the workspace
ledger at `docs/iteration-2/run-2/`, beside the rolling learnings ledger
that carries the run's open warts (the sanitizer's novel-placeholder
blind spot, the GitLab matrix gap) forward as iteration-3 seeds.

## Iteration 1 — what shipped

Thirty queue items, sequenced by a referee pass across six app plans. The
book got its accuracy and de-identification pass, then the loop-first
restructure, the services and products chapters, the `verify-claims`
truthfulness gate, and the dogfood evidence page. adroit proved the corpus
discipline on its own `adr/`, hardened the manifest/MCP read-only seam,
and added stored plans (`plan --save`) plus machine-readable assessment
ingest. conduit went from an empty repo to the full spike: forge adapters
(live Gitea, dry-run GitHub) over a shared conformance suite, the PR
lifecycle state machine, the engine seam with a deterministic fake, the
contract emission and `verify`, and the two-user throwaway-forge demo.
assessments was rebuilt around a provider seam (Anthropic, ollama, fake),
gained the headless `author` pipeline with `--context`, and a golden-export
seam check. tuesday split into a forge-neutral core, grew a Gitea source
and the headless strict-mode `tuesday-report`, and contributed the
cross-check script. pulse serialized its report contract and shipped the
seeded, deterministic dogfood. The playbook repo stood up the client-shaped
corpus with four accepted ADRs and a proven provider-free read path. Item
29 was the capstone run; item 30 was the evidence page it regenerates.

**Badge moves.** The maturity ladder is itself an iteration-1 decision
(this repo's ADR-0002), so iteration 1 records first gradings rather than
moves. assessments, adroit, tuesday, and the playbook pattern enter at
**dogfooding** — each gated by a non-empty adroit-managed ADR corpus in
its own repo, the floor `scripts/verify-claims` enforces. conduit enters
at **spike**: a spec at iteration start, a captured end-to-end proof at
close — the evidence is [run 1](./loop/dogfood/run-1.md)'s merged
contract-tagged PR and six-check `verify` pass. pulse enters at
**dogfooding (parked)** by recorded decision (its ADR-0007).

**Corrections.** The opening accuracy pass cut the book's pre-iteration
overclaims to reality: AI playbook "variant generation" moved from a
present-tense capability to roadmap-only wording, and the delivered
playbook example was de-identified end to end.

**Run pointer.** The capstone's evidence page is
[Run 1 — the iteration-1 capstone](./loop/dogfood/run-1.md); the captured
artifacts live in the workspace ledger at `docs/iteration-1/run-1/`,
beside the learnings ledger (`docs/iteration-1/learnings.md`) that
distilled the run's warts into iteration-2 work.
