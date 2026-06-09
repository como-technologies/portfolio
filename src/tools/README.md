# Tools

Developer utilities in the Como Technologies portfolio. Tools are standalone — usable on their own, and composable with the rest of the TAPS portfolio.

- **adroit** — A terminal UI for authoring, linking, and managing Architecture Decision Records. ADRs are the atomic unit of a Como playbook; adroit is how teams produce and maintain them. [Source on GitHub »](https://github.com/como-technologies/adroit)
- **conduit** *(in development)* — A forge-neutral, model-neutral, cloud-neutral agentic development harness. It turns a playbook's accepted ADRs and guides into issues an agent works inside the team's *own* forge, model, and cloud — the whole build loop (scope → code → review → deploy → merge) happening in their existing issues and pull requests, nothing locked to a vendor. adroit decides; conduit enacts: it reads adroit's decisions over the manifest / `-o json` / MCP seam and ships reviewable PRs — each tagged with the deciding ADR, so the effort [tuesday](../apps/README.md) measures traces back to the decision without adroit and tuesday ever touching directly.
