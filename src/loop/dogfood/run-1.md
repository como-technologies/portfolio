# Run 1 — the iteration-1 capstone

On 2026-06-12 the entire TAPS loop ran end to end on one machine — the
iteration-1 capstone. AI appeared in exactly two lanes: local ollama
(`llama3.2`) at Assess authoring and at Prescribe import/plan; conduit's
engine was the deterministic FakeEngine; pulse and tuesday used zero AI.
Nothing left localhost — the only forge was conduit's throwaway Gitea
container, destroyed at the end of the run. Every step exited 0, and no
step needed a code fix mid-run.

Every excerpt below is extracted **mechanically** from the captured run
artifacts by `just refresh-evidence` — nothing is hand-transcribed (see
[how these pages regenerate](../dogfood.md#how-these-pages-regenerate)).
The full artifact set — `transcript.md` with every command and exit code,
plus every seam JSON quoted below — lives in the workspace evidence ledger
beside the portfolio checkouts, at `docs/iteration-1/run-1/`.

## 1 — Measure, prior iteration: the pulse seed

The loop enters at Assess, but Assess reads what the previous Measure
wrote. The seed was pulse's deterministic dogfood report — simulated
respondents, seeded, and labeled as such inside the artifact itself:

```sh
just dogfood        # in the pulse repo → out/pulse-report.json
```

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

The low score on dogfood-loop support is the weak signal the rest of the
run keeps meeting again.

## 2 — Assess: the report steers the assessment

First-ever exercise of the Measure → Assess return edge: the pulse report
went in as authoring context. Authoring took 532 s on `llama3.2`
(three bounded structure retries did their job), and `validate` exited 0:

```sh
AI_PROVIDER=ollama OLLAMA_MODEL=llama3.2 assessments author \
  --brief examples/dogfood/brief.md \
  --context pulse-report.json --out assessment.yaml
assessments validate assessment.yaml
```

<!-- evidence:assess-start -->
```text
4 domains, 12 practices, 115 questions
name: Assessment Name
description: What this assessment evaluates
goal: Intended outcome
```
<!-- evidence:assess-end -->

The context wiring measurably steered content: five authored questions
cite the report's literal JSON shape (`per_tenant`, `total_flows`), and
both weak pulse signals resurfaced as authored questions. The top-level
name above is a small-model placeholder echo — recorded in the
[warts](#honest-warts), not edited away.

## 3 — Prescribe: the assessment seeds decisions

```sh
adroit import --dir corpus --from-assessment assessment.yaml --ai -o json
```

<!-- evidence:import-start -->
```text
seeded 11 proposed ADRs from assessment "Assessment Name" (1 skipped as duplicate: Learning from Failure)
  ADR-0001  Version Control Discipline        [Delivery Pipeline]
  ADR-0002  Continuous Integration            [Delivery Pipeline]
  ADR-0003  Release Management                [Delivery Pipeline]
  ADR-0004  Code Review Practice              [Code Quality]
  ADR-0005  Coding Standards                  [Code Quality]
  ADR-0006  Technical Debt Management         [Code Quality]
  ADR-0007  Automated Test Coverage           [Testing]
  ADR-0008  Tests Gating Merges and Releases  [Testing]
  ADR-0009  Learning from Failure             [Testing]
  ADR-0010  Monitoring and Alerting           [Operations]
  ADR-0011  Incident Response                 [Operations]
```
<!-- evidence:import-end -->

One practice the model had authored into two domains was caught by the
import dedupe guard — seeded once, skipped once. The lint sweep across the
seeded corpus came back 9/11 clean; the two findings were section-shape
notes, not substance.

## 4 — Prescribe: accept, plan once, read forever

ADR-0007 "Automated Test Coverage" was accepted and planned. The provider
cost is paid exactly once, at `plan --save`; every read after that is a
deterministic, provider-free stored-plan read — the property the Adopt
engine's snapshotting relies on:

```sh
adroit set-status 7 accepted --dir corpus
adroit plan 7 --save --dir corpus            # ollama, once (29 s)
adroit plan 7 --dir corpus -o json           # read twice, with NO AI env
```

<!-- evidence:plan-start -->
```text
adroit-plan-7.json — captured `plan -o json` for ADR-0007 "Automated Test Coverage" — "stored": true
  sha256 a1bfd19f9500b7a56ac5bcae5251d9554c1bb68b47ad68f2c78f318ea8ff5556
  transcript.md records this same sha for two consecutive provider-free reads
plan-5.json — captured `plan -o json` for ADR-0005 "Coding Standards" — "stored": true
  sha256 23e8d62746e58935450effc2e9267383fab197fd8ea210f109739dfc750af417
  transcript.md records this same sha for two consecutive provider-free reads
```
<!-- evidence:plan-end -->

The second artifact is an independent replication: a parallel session
accepted and planned ADR-0005 against the same corpus, and its stored-plan
read replayed byte-identically too.

## 5 — Adopt: the decision becomes a merged PR

conduit, pointed at the run corpus, read the stored plan with no provider
call, opened issue 1, and — through the human gates (a reviewer labeled
the issue runnable, approved the PR, and merged it) — drove the task
Scoped → Coding → InReview → Merged as PR 2 on the throwaway forge. The
closing beat machine-asserts the
[conduit → tuesday contract](../adopt.md#the-conduit--tuesday-contract) on
the merged PR:

```sh
conduit plan 7 --forge gitea
conduit run --forge gitea --once    # … human review gates …
conduit run --forge gitea --once
conduit verify 7 --forge gitea -o json
```

<!-- evidence:verify-start -->
```json
{
  "checks": [
    {
      "detail": "title \"[ADR-0007] Automated Test Coverage\" (want ^\\[ADR-dddd\\] )",
      "name": "title_prefix",
      "pass": true
    },
    {
      "detail": "final body line \"Adr-Reference: ADR-0007\" (want \"Adr-Reference: ADR-0007\")",
      "name": "trailer_final_line",
      "pass": true
    },
    {
      "detail": "effort labels [\"effort:1-super-quick\"] (want exactly one from the closed set)",
      "name": "exactly_one_effort_label",
      "pass": true
    },
    {
      "detail": "labels [\"adr:ADR-0007\", \"effort:1-super-quick\"] (want \"adr:ADR-0007\")",
      "name": "adr_label_present",
      "pass": true
    },
    {
      "detail": "head branch \"conduit/adr-0007/automated-test-coverage\" (want conduit/adr-dddd/<slug>)",
      "name": "branch_shape",
      "pass": true
    },
    {
      "detail": "head branch \"conduit/adr-0007/automated-test-coverage\" (must never start adr/)",
      "name": "never_adr_namespace",
      "pass": true
    }
  ],
  "pass": true,
  "pr": 2,
  "task": "adr-0007"
}
```
<!-- evidence:verify-end -->

## 6 — Measure: the hours come back

tuesday read the same forge independently — strict mode, reviewer
identity, read-only — and recovered the decision's identity, effort, and
hours from the PR markers alone:

```sh
tuesday-report --source gitea --owner como --repo conduit-dogfood \
    --year 2026 --month 6 \
    --token-file ../conduit/.secrets/reviewer.token \
    --strict -o json
```

<!-- evidence:tuesday-start -->
```json
{
  "adr_totals": {
    "ADR-0007": 360.0
  },
  "allocations": [
    {
      "pr_number": 2,
      "pr_title": "[ADR-0007] Automated Test Coverage",
      "effort_score": "SuperQuick",
      "adr_id": "ADR-0007",
      "allocated_hours": 360.0
    }
  ],
  "total_effort_points": 1,
  "unallocated_prs": []
}
```
<!-- evidence:tuesday-end -->

Strict mode satisfied: one allocation, zero unallocated PRs. (The 360-hour
figure is the recipe's unpinned monthly-hours default spread over a
one-PR month — a recorded wart, not a measurement.)

## 7 — Loop closure: two codebases, one ground truth

The closure proof is not either report — it is their agreement. conduit's
`verify` (the Adopt side) and tuesday's strict report (the Measure side)
are independent codebases reading the same forge:

```sh
scripts/cross-check.sh conduit-verify.json tuesday-report.json
```

<!-- evidence:crosscheck-start -->
```text
pr:     conduit=2 tuesday=2
effort: conduit=effort:1-super-quick tuesday=effort:1-super-quick (SuperQuick)
adr:    conduit=ADR-0007 tuesday=ADR-0007 (adr_totals: 360.0h)
CROSS-CHECK PASS: PR 2, effort:1-super-quick, ADR-0007 — Adopt and Measure agree
```
<!-- evidence:crosscheck-end -->

Sentiment fed assessment, assessment seeded decisions, a decision became a
merged contract-tagged PR, and the measurement side independently
recovered that decision's identity, effort, and hours. Then `forge-down`
destroyed the container: nothing ever left localhost.

## Honest warts

A first full-loop run that found nothing wrong would itself be suspect.
What this one found, kept verbatim in the artifacts rather than cleaned
up:

- **Placeholder echo, now load-bearing.** The capstone assessment is
  literally named "Assessment Name", with description "What this
  assessment evaluates" — `llama3.2` echoed the prompt's scaffold, and
  schema validation cannot catch semantically empty strings. A degeneracy
  check is the distilled iteration-2 fix.
- **Context leaked too literally.** Question guidance like "Check the
  'pulse-report.json' file under 'per_tenant'…" treats the context
  artifact as the system under assessment. The author prompt should frame
  context as background signal, not subject matter.
- **Duplicate practice across domains.** "Learning from Failure" was
  authored into both Testing and Operations; the import dedupe guard
  caught it (11 seeded, 1 skipped), but authoring should dedupe too.
- **AI residue in ADR bodies.** One seeded ADR ends with a trailing
  conversational pleasantry; two others carry the seed skeleton echoed
  back as content — and lint flags neither. Two of eleven seeds also
  failed lint purely on a section-depth convention the model and the
  linter disagree about.
- **The clock cost is the model.** The ollama lanes account for roughly
  15 minutes of an ~25-minute run (authoring 8m52s, import ~33 s per ADR,
  plan 29 s); everything mechanical is sub-second to two seconds.
- **Unpinned hours default.** tuesday's dogfood recipe doesn't pass
  `--monthly-hours`, so the month's full default landed on the single PR.
  Harmless for the cross-check (it compares identity, effort label, and
  ADR — never hours), but the recipe should pin it.
- **The run dir was not single-writer.** A parallel session resumed the
  same queue item mid-run and accepted a second ADR in the shared corpus.
  The verified thread was unaffected — and the intruder accidentally
  donated the stored-plan replication in section 4 — but iteration 2 runs
  get per-run unique directories.

The full ledger — these and every earlier finding, with the distilled
per-app iteration-2 changes — lives beside the run artifacts at
`docs/iteration-1/learnings.md` in the portfolio workspace.
