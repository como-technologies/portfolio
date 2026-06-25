# Run 2 — the iteration-2 capstone

On 2026-06-12 the entire TAPS loop ran end to end a second time, on the
consolidated iteration-2 mains — same machine, same rules as
[run 1](./run-1.md). AI appeared in the same two lanes (local ollama
`llama3.2` at Assess authoring and Prescribe import/plan); conduit's
engine was the deterministic FakeEngine for the pass-criteria thread,
plus a sandboxed claude-code **live-engine encore**. Nothing left
localhost — the only forge was conduit's throwaway Gitea, seeded with the
playbook repo and destroyed at the end.

The headline is the run-1 comparison: every distilled iteration-2 fix
that was testable in-loop verified against fresh model output.

| | run 1 | run 2 |
|---|---|---|
| Assess authoring wall-clock | 532.4 s | 355.9 s (**−33%**) |
| Assess retries | 5 | **0** |
| Assessment name | placeholder echo | a real title |
| Context leakage into questions | 5 verbatim echoes | **0** |
| AI residue / skeleton echoes in ADR bodies | present | **none** |
| Restart proof | separate thread | **kill −9 mid-Coding, in-thread** |
| Loop-closure cross-check | PASS ×1 | **PASS ×2** |
| Live coding engine | not in the run | encore PR, merged and **harvested** |
| Prescribe target | throwaway /tmp corpus | the **real playbook corpus** |

That last row is the structural change: where run 1's decisions
evaporated with the run directory, run 2 prescribed into the playbook
itself, so the loop's output is now production content — eight
assessment-seeded proposed ADRs, one accepted-and-planned decision, and a
conduit-authored glossary, all on the playbook's main.

Every excerpt below is extracted **mechanically** from the captured
run artifacts by `just refresh-evidence` (see
[how these pages regenerate](../dogfood.md#how-these-pages-regenerate)).
The full artifact set lives in the workspace evidence ledger at
`docs/iteration-2/run-2/`.

## 1 — Measure, prior iteration: the pulse seed

The same deterministic seed as run 1, regenerated fresh (`just dogfood`,
exit 0, 1.6 s) and JSON-identical to run 1's report — seeded determinism
doing exactly what it promises. The weak dogfood-loop signal again steers
the run:

<!-- evidence:pulse-start -->
```text
schema: pulse.measure-report/v1   seed: 42
data_source: simulated respondents — synthetic demo data, not a real survey
flows: 10 total, 10 passed, 0 failed
avg 4.2  "How confident are you that this iteration's changes improved the portfolio?"
avg 2.6  "How well did the dogfood loop (prescribe, adopt, measure, assess) support the work this iteration?"   <- weakest signal
avg 3.9  "How sustainable is the current iteration pace?"
```
<!-- evidence:pulse-end -->

## 2 — Assess: the report steers the assessment

Authoring took 355.9 s on `llama3.2` — a third faster than run 1 — with
**zero retries** where run 1 needed five, and the context went in twice
(run 1's tuesday report plus the fresh pulse report):

```sh
AI_PROVIDER=ollama OLLAMA_MODEL=llama3.2 assessments author \
  --brief examples/dogfood/brief.md \
  --context tuesday-report.json --context pulse-report.json \
  --out assessment.yaml
```

<!-- evidence:assess-start -->
```text
4 domains, 8 practices, 96 questions
name: Software Engineering Maturity Assessment
description: Evaluates day-to-day engineering practices of a small-to-mid-size software team
goal: Identify riskiest gaps in everyday practice and provide prioritized improvement backlog
```
<!-- evidence:assess-end -->

A real name, a real description, a real goal — run 1's "Assessment Name"
placeholder echo is gone, caught by the degeneracy gate the run-1 warts
prescribed. The leakage gate came back with **zero hits**: no authored
question echoes the context artifacts' JSON shape (run 1 had five), and
the authoring dedupe left nothing for import to skip.

## 3 — Prescribe: the assessment seeds decisions

This is where run 2 stops being a rehearsal. `import --from-assessment
--ai` (adroit **v0.2.0**, the tagged binary) seeded the proposed decisions
into the **real playbook corpus** — `playbook/src/adrs`, not a throwaway
`/tmp` directory:

```sh
# in the playbook checkout
adroit import --dir src/adrs --from-assessment assessment.yaml --ai -o json
```

<!-- evidence:import-start -->
```text
seeded 8 proposed ADRs from assessment "Software Engineering Maturity Assessment"
  ADR-0005  Automated Testing       [Delivery Pipeline]
  ADR-0006  Continuous Integration  [Delivery Pipeline]
  ADR-0007  Code Reviews            [Code Quality]
  ADR-0008  Refactoring             [Code Quality]
  ADR-0009  Unit Testing            [Testing]
  ADR-0010  Integration Testing     [Testing]
  ADR-0011  Monitoring              [Operations]
  ADR-0012  Incident Management     [Operations]
```
<!-- evidence:import-end -->

Eight seeded, zero skipped — run 1's cross-domain duplicate never got
authored this time. The sanitizer held against fresh model output: **zero
chat residue and zero skeleton echoes** in the ADR bodies (both were run-1
warts), and run 1's lint depth false-positive is gone — the sweep came
back 7/8 clean, with the remaining findings genuine content gaps, not
linter disagreements.

## 4 — Prescribe: accept, plan once, read forever

ADR-0005 "Automated Testing" was accepted and planned — the provider cost
paid exactly once, then two provider-free reads replayed byte-identically:

```sh
adroit set-status 5 accepted --dir src/adrs
adroit plan 5 --save --dir src/adrs          # ollama, once (36 s)
adroit plan 5 --dir src/adrs -o json         # read twice, with NO AI env
```

<!-- evidence:plan-start -->
```text
plan-5.json — captured `plan -o json` for ADR-0005 "Automated Testing" — "stored": true
  sha256 aaa56e54efbd94d598107d4604c20595d93d903cf1710aa72a2251023a81c19e
  transcript.md records this same sha for two consecutive provider-free reads
```
<!-- evidence:plan-end -->

The plan's `Created: 2026-06-12` provenance is now document-persisted
rather than mtime-derived, and the corpus — eight proposed, one accepted
and planned — was committed to the playbook's own main before Adopt ever
started.

## 5 — Adopt: the decision becomes a merged PR

conduit read the stored plan with no provider call, opened the issue, and
— through the same human gates as run 1 — drove the task to a merged PR.
New this run: the restart proof is folded into the main thread. The
engine was **killed −9 mid-Coding**, leaving a crash record with the
`RunEngine` intent undone; the recovery tick converged from the immutable
snapshot with **no duplicate issue and no duplicate PR**, then review,
merge, and the six-check `verify`:

```sh
conduit plan 5                                   # stored plan, NO AI env
conduit run --once &  →  kill -9 mid-Coding      # crash record: state=Coding
conduit run --once                               # recovery → InReview, no duplicates
# … human review gates: approve, merge …
conduit verify 5 -o json
```

<!-- evidence:verify-start -->
```json
{
  "checks": [
    {
      "detail": "title \"[ADR-0005] Automated Testing\" (want ^\\[ADR-dddd\\] )",
      "name": "title_prefix",
      "pass": true
    },
    {
      "detail": "final body line \"Adr-Reference: ADR-0005\" (want \"Adr-Reference: ADR-0005\")",
      "name": "trailer_final_line",
      "pass": true
    },
    {
      "detail": "effort labels [\"effort:1-super-quick\"] (want exactly one from the closed set)",
      "name": "exactly_one_effort_label",
      "pass": true
    },
    {
      "detail": "labels [\"adr:ADR-0005\", \"effort:1-super-quick\"] (want \"adr:ADR-0005\")",
      "name": "adr_label_present",
      "pass": true
    },
    {
      "detail": "head branch \"conduit/adr-0005/automated-testing\" (want conduit/adr-dddd/<slug>)",
      "name": "branch_shape",
      "pass": true
    },
    {
      "detail": "head branch \"conduit/adr-0005/automated-testing\" (must never start adr/)",
      "name": "never_adr_namespace",
      "pass": true
    }
  ],
  "pass": true,
  "pr": 2,
  "task": "adr-0005"
}
```
<!-- evidence:verify-end -->

Forge-neutrality re-proved at N=2: the same event sequence through the
live Gitea adapter and the dry-run GitHub adapter diffs to nothing —
byte-identical transcripts, one sha256. The run's referee had asked for a
*three*-forge diff, but the pinned conduit binary has no GitLab adapter
yet — recorded as a matrix gap in the artifacts, not papered over.

**The live-engine encore.** The pass-criteria thread above ran on the
deterministic FakeEngine; run 2 then re-ran the Adopt beat with a real
coding engine (`CONDUIT_ENGINE=claude-code`, sandboxed, 5.5 min of engine
wall-clock) against a second accepted decision. The engine produced a
real 96-line glossary page wired into the playbook's book — reviewed,
approved, and merged by the human gate, with its own six-check `verify`
pass (`conduit-verify-encore.json` in the ledger). Before the forge was
destroyed, the playbook **harvested** that merge by URL fetch and
provenance cherry-pick onto its local main: the loop's output became
production content.

## 6 — Measure: the hours come back

tuesday read the same forge independently — strict mode, read-only — and
this time with the recipe's `--monthly-hours 160` pin (run 1's unpinned
360-hour default was a recorded wart). Both threads come back: the
FakeEngine PR and the encore PR, 80 hours each over the two-point month:

```sh
just dogfood-report playbook    # tuesday-report --source gitea --strict --monthly-hours 160
```

<!-- evidence:tuesday-start -->
```json
{
  "adr_totals": {
    "ADR-0004": 80.0,
    "ADR-0005": 80.0
  },
  "allocations": [
    {
      "pr_number": 6,
      "pr_title": "[ADR-0004] Maintain a glossary of shared engineering terms in the playbook",
      "effort_score": "SuperQuick",
      "adr_id": "ADR-0004",
      "allocated_hours": 80.0
    },
    {
      "pr_number": 2,
      "pr_title": "[ADR-0005] Automated Testing",
      "effort_score": "SuperQuick",
      "adr_id": "ADR-0005",
      "allocated_hours": 80.0
    }
  ],
  "total_effort_points": 2,
  "unallocated_prs": []
}
```
<!-- evidence:tuesday-end -->

One mid-run fix, recorded rather than hidden: tuesday's dogfood recipe
hardwired the run-1 repo name, so the recipe gained a `repo` parameter
(tuesday 117e13a, its own gate green before commit). A recipe-shape fix,
not a contract change — and the only code fix the entire run needed.

## 7 — Loop closure: two codebases, one ground truth

The closure proof is the agreement, and run 2 has it **twice**: conduit's
`verify` and tuesday's strict report — independent codebases reading the
same forge — agree on PR number, effort label, and ADR identity for both
the FakeEngine thread and the live-engine encore:

<!-- evidence:crosscheck-start -->
```text
pr:     conduit=2 tuesday=2
effort: conduit=effort:1-super-quick tuesday=effort:1-super-quick (SuperQuick)
adr:    conduit=ADR-0005 tuesday=ADR-0005 (adr_totals: 80.0h)
CROSS-CHECK PASS: PR 2, effort:1-super-quick, ADR-0005 — Adopt and Measure agree
pr:     conduit=6 tuesday=6
effort: conduit=effort:1-super-quick tuesday=effort:1-super-quick (SuperQuick)
adr:    conduit=ADR-0004 tuesday=ADR-0004 (adr_totals: 80.0h)
CROSS-CHECK PASS: PR 6, effort:1-super-quick, ADR-0004 — Adopt and Measure agree
```
<!-- evidence:crosscheck-end -->

Then `forge-down` destroyed the container: nothing ever left localhost,
and what survives is exactly what should — the captured artifacts, and
the harvested content on the playbook's main.

## Honest warts

Run 2 closed most of run 1's wart list and found new edges of its own.
Kept verbatim in the artifacts:

- **The sanitizer has a novel-placeholder blind spot.** It caught every
  run-1 failure mode (chat residue, skeleton echoes), but one seeded ADR
  carries a model-emitted bracket placeholder it didn't recognize.
- **Forge-neutrality is proven at N=2, claimed for 3.** The referee's
  three-forge transcript diff couldn't run: the pinned binary supports
  exactly Gitea and GitHub, so the diff ran 2/2 byte-identical and the
  GitLab adapter is recorded as the queued gap — building one mid-run
  would have broken the pinned-binary rule.
- **Import is still serial.** ~34.5 s per seeded ADR, flat against
  run 1 — the per-ADR provider call dominates, and there is no `--jobs`
  parallelism yet.
- **One recipe fix mid-run.** tuesday's dogfood recipe needed its repo
  name parameterized (117e13a). Run 1 needed zero fixes; run 2's one was
  recipe shape, not behavior.
- **Two genuine content gaps** in one seeded ADR's lint findings —
  real gaps a human author must fill, which is the linter doing its job.

The rolling ledger beside the artifacts
(`docs/iteration-1/learnings.md`) carries these forward as iteration-3
seeds.
