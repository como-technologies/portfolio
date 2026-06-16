# Measurement setup

Standing up the loop's [Measure](../loop/measure.md) stage so adoption is
observed, not assumed: baseline capture, the reporting cadence, and the two
instruments — capacity and sentiment. The deliverable is evidence that feeds
the next assessment, which is what makes an engagement a loop instead of a
project.

**Inputs.** Read access to the team's forge (GitHub or Gitea), an
effort-labeling practice for merged PRs (developers self-report relative
effort — a habit this service installs), and, for the sentiment axis, the
survey itself: checked-in data the team can edit without redeploying
anything.

**Tools.** Two, with different maturity — said plainly:

- [tuesday](../loop/measure.md) *(dogfooding)* — team capacity analysis from
  merged-PR effort. The headless CLI emits the canonical monthly report
  JSON, including the per-decision rollup: hours attributed to the ADR that
  prompted the work.
- [pulse](../loop/measure.md) *(dogfooding, parked)* — verified-anonymous
  sentiment polling on cryptographic blind signatures. Development is
  intentionally frozen at the protocol proof by a recorded decision; the
  end-to-end dogfood run is kept green each iteration, but there is no
  production deployment and its respondents today are simulated. A client
  pilot is a deliberate future step, not a current offer.

**Artifact out.** Machine-readable Measure artifacts on a monthly cadence:
tuesday's capacity report (hours by category and by decision) and — once
pulse is unparked for a pilot — the k-anonymous sentiment aggregate. Plain
JSON files, because the loop's last hand-off is the next assessment's input.

**Human gates.** The signal is human at the source: developers self-report
effort, respondents choose what to say. The instruments are read-only by
construction — measurement never mutates the forge — and pulse's k-anonymity
suppression means no aggregate can identify a respondent, even to the
operator. What to *do* about the numbers stays a human decision in the
re-assessment.

**Measure hooks.** This service *is* the hook. Its artifacts close the loop:
the capacity report says what each decision cost, the sentiment aggregate
says what it felt like, and the next
[Assessment engagement](./assessment.md) starts from both.
