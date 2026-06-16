# Assessment engagement

Facilitated discovery that ends in a machine-consumable artifact, not a
deck. Como runs structured interviews with engineers, architects, and
platform owners; AI-assisted synthesis turns the conversation into a
consistent four-level maturity model (Assessment → Domain → Practice →
Question). The engagement is the human wrapper around the loop's
[Assess](../loop/assess.md) stage.

**Inputs.** Interviews and workshops with the people who own the systems;
existing documentation and artifacts the team already has. On a repeat
engagement, the previous iteration's Measure artifacts — the capacity report
and the sentiment aggregate — are the starting evidence, which is what makes
the loop a loop.

**Tool.** [assessments](../loop/assess.md) *(dogfooding)* — the AI-assisted
authoring environment. SMEs co-create the assessment through a guided
five-phase workflow; the headless pipeline runs on a local model, so client
material never has to leave client infrastructure.

**Artifact out.** A schema-validated assessment export (YAML/JSON/TOML,
checked against a published JSON Schema). It is exactly what
`adroit import --from-assessment` consumes to seed Proposed ADRs in the
Prescribe stage — the hand-off is a seam, not a re-keying exercise.

**Human gates.** The interview itself: SMEs steer what the model is told and
correct what it infers. And the sign-off: the assessment is reviewed with
stakeholders before it is exported and acted on — nothing flows into
Prescribe that the client hasn't read.

**Measure hooks.** The assessment is the baseline. The next iteration's
measurement is read against it, and the re-assessment that closes the loop
starts from the deltas — which practices moved, which didn't, and what that
cost.
