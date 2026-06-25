# Run 3

Run 3 (2026-06-12) was the iteration-3 capstone — the full TAPS loop on the
hardened suite. Only the Assess and Prescribe beats touched AI (local ollama
`llama3.2`); Adopt ran the deterministic fake engine and Measure used no model
at all. Everything stayed on localhost: a throwaway Gitea container, destroyed
at the end. What set run 3 apart from run 2 is that the quality gates **fired
for real for the first time** — a bounded, recoverable failure kept as
evidence rather than smoothed away — alongside three byte-identical forges
(N=3) and the first in-loop use of multi-month measurement, with **zero
mid-run code fixes**.

Every excerpt below is extracted **mechanically** from the captured
run artifacts by `just refresh-evidence` (see
[how these pages regenerate](../dogfood.md#how-these-pages-regenerate)).
The full artifact set lives in the workspace evidence ledger at
`docs/iteration-3/run-3/`.

## 1 — Measure, prior iteration: the pulse seed

The loop opens by reading the previous iteration's sentiment. Pulse's seeded,
deterministic report — synthetic respondents, not a real survey — is fed into
Assess as background. The weakest signal (iteration pace, 2.9) is the kind of
honest negative the closed loop is meant to surface.

<!-- evidence:pulse-start -->
```text
schema: pulse.measure-report/v1   seed: 42
data_source: simulated respondents — synthetic demo data, not a real survey
flows: 10 total, 10 passed, 0 failed
avg 4.0  "How confident are you that this iteration's changes improved the portfolio?"
avg 3.1  "How well did the dogfood loop (prescribe, adopt, measure, assess) support the work this iteration?"
avg 2.9  "How sustainable is the current iteration pace?"   <- weakest signal
avg 3.8  "How much do you trust the artifacts the loop produced this iteration (assessments, seeded decisions, merged PRs)?"
```
<!-- evidence:pulse-end -->

## 2 — Assess: the report steers the assessment

The headline of run 3: authoring **failed bounded on its first attempt** — the
local model echoed the prompt scaffold and the degeneracy gate caught all three
structure tries, exiting non-zero with an actionable message instead of letting
a placeholder assessment downstream. Attempt 2 recovered through one in-run gate
retry and produced a real, named assessment. That is the gate working: a
misbehaving model yields a bounded failure, not a bad artifact. (Parallel
authoring with `--jobs 2` ran at ~2.6 s/question vs run-2's 3.0 serial — honest,
not the headline 1.56 the isolated lane saw, because the model drew a larger
11-practice structure.)

<!-- evidence:assess-start -->
```text
4 domains, 11 practices, 131 questions
name: Software Engineering Maturity Assessment
description: Evaluates day-to-day engineering practices of a small-to-mid-size software team
goal: Identify riskiest gaps in everyday practice and provide prioritized improvement backlog
```
<!-- evidence:assess-end -->

## 3 — Prescribe: the assessment seeds decisions

adroit imported the validated assessment into a fresh corpus — one proposed ADR
per practice. The iteration-3 sanitizer hardening showed: zero bracket-placeholder
survivors on the model's output, and lint's cleanest sweep yet (11/11). The one
observability gap noted here — the sanitizer's drops were silent — became
iteration-4's C3 (per-rule drop counts now surface in the import summary).

<!-- evidence:import-start -->
```text
seeded 11 proposed ADRs from assessment "Software Engineering Maturity Assessment"
  ADR-0001  Version Control Discipline        [Delivery Pipeline]
  ADR-0002  Continuous Integration            [Delivery Pipeline]
  ADR-0003  Release Management                [Delivery Pipeline]
  ADR-0004  Code Review Practice              [Code Quality]
  ADR-0005  Coding Standards                  [Code Quality]
  ADR-0006  Technical Debt Management         [Code Quality]
  ADR-0007  Automated Test Coverage           [Testing]
  ADR-0008  Tests Gating Merges and Releases  [Testing]
  ADR-0009  Monitoring and Alerting           [Operations]
  ADR-0010  Incident Response                 [Operations]
  ADR-0011  Learning from Failure             [Operations]
```
<!-- evidence:import-end -->

## 4 — Prescribe: accept, plan once, read forever

One ADR is accepted and its implementation plan saved — the model is paid once.
Every subsequent read is provider-free and deterministic: two consecutive
`plan -o json` reads with no AI configured produce the byte-identical sha below.
This is the seam that lets the Adopt engine run with no model at all.

<!-- evidence:plan-start -->
```text
plan-1-read2.json — captured `plan -o json` for ADR-0001 "Version Control Discipline" — "stored": true
  sha256 97c7914ff4929591efa6eaedfc5701cfe42f30ee20b5e7ec78e5efd45574cd01
  transcript.md records this same sha for two consecutive provider-free reads
plan-1.json — captured `plan -o json` for ADR-0001 "Version Control Discipline" — "stored": true
  sha256 97c7914ff4929591efa6eaedfc5701cfe42f30ee20b5e7ec78e5efd45574cd01
  transcript.md records this same sha for two consecutive provider-free reads
```
<!-- evidence:plan-end -->

## 5 — Adopt: the decision becomes a merged PR

conduit read the stored plan (no AI), opened a human-gated PR on the throwaway
forge, survived a `kill -9` mid-Coding with a duplicate-free recovery, and the
PR was merged by the reviewer. `conduit verify` machine-asserts all six tagging
checks on the merged PR:

<!-- evidence:verify-start -->
```json
{
  "checks": [
    {
      "detail": "title \"[ADR-0001] Version Control Discipline\" (want ^\\[ADR-dddd\\] )",
      "name": "title_prefix",
      "pass": true
    },
    {
      "detail": "final body line \"Adr-Reference: ADR-0001\" (want \"Adr-Reference: ADR-0001\")",
      "name": "trailer_final_line",
      "pass": true
    },
    {
      "detail": "effort labels [\"effort:1-super-quick\"] (want exactly one from the closed set)",
      "name": "exactly_one_effort_label",
      "pass": true
    },
    {
      "detail": "labels [\"adr:ADR-0001\", \"effort:1-super-quick\"] (want \"adr:ADR-0001\")",
      "name": "adr_label_present",
      "pass": true
    },
    {
      "detail": "head branch \"conduit/adr-0001/version-control-discipline\" (want conduit/adr-dddd/<slug>)",
      "name": "branch_shape",
      "pass": true
    },
    {
      "detail": "head branch \"conduit/adr-0001/version-control-discipline\" (must never start adr/)",
      "name": "never_adr_namespace",
      "pass": true
    }
  ],
  "pass": true,
  "pr": 2,
  "task": "adr-0001"
}
```
<!-- evidence:verify-end -->

## 6 — Measure: the hours come back

tuesday read the merged PR from the same forge and attributed its effort to the
deciding ADR. Run 3 also exercised the new multi-month range (`--from`/`--to`)
in the loop for the first time, including a genuinely empty month — the rollup
stayed consistent with the per-month reports.

<!-- evidence:tuesday-start -->
```json
{
  "adr_totals": {
    "ADR-0001": 160.0
  },
  "allocations": [
    {
      "pr_number": 2,
      "pr_title": "[ADR-0001] Version Control Discipline",
      "effort_score": "SuperQuick",
      "adr_id": "ADR-0001",
      "allocated_hours": 160.0
    }
  ],
  "total_effort_points": 1,
  "unallocated_prs": []
}
```
<!-- evidence:tuesday-end -->

## 7 — Loop closure: two codebases, one ground truth

The cross-check reads conduit's verify JSON and tuesday's report and asserts
both independent codebases agree on the same merged PR, the same effort label,
and the same ADR. The loop closed:

<!-- evidence:crosscheck-start -->
```text
bash scripts/cross-check.sh /tmp/como-dogfood/run-3-20260612T184337Z/conduit-verify.json /tmp/como-dogfood/run-3-20260612T184337Z/tuesday-report.json
pr:     conduit=2 tuesday=2
effort: conduit=effort:1-super-quick tuesday=effort:1-super-quick (SuperQuick)
adr:    conduit=ADR-0001 tuesday=ADR-0001 (adr_totals: 160.0h)
CROSS-CHECK PASS: PR 2, effort:1-super-quick, ADR-0001 — Adopt and Measure agree
```
<!-- evidence:crosscheck-end -->

## Honest warts

Run 3 found four things and kept them in the artifacts rather than cleaning
them away — all became iteration-4 work (now landed):

- **Silent sanitizer drops** in adroit's `import --ai`: the artifacts couldn't
  distinguish "the model emitted nothing bad" from "the sanitizer ate it."
  Fixed in iteration-4 C3 — per-rule drop counts now surface.
- **WSL2 clock drift** reached an app binary: assessments' author reporter
  printed 486s (monotonic) for a 446.7s wall run. Iteration-4 B6 confirmed the
  measurement was already on the correct monotonic clock and documented the
  contract so it can't regress.
- **Demo topology one knob short**: pointing the conduit demo at a non-default
  corpus repo took a hand-sed of the generated config. Iteration-4 A4 added the
  `REPO_NAME` knob (the third sighting of the hardcoded-target lesson).
- **Pulse brief/file batch-count drift**: a run brief said "5 batches" when the
  committed survey had 4. Recorded under the docs-reflect-reality rule;
  iteration-4 P1 folded the iteration-3 retro question (5 batches now).
