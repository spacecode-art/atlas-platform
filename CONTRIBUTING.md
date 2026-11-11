# Contributing

Thank you for your interest in contributing to Atlas Platform.

## Development Workflow

1. Create a feature branch from `main`.
2. Make focused, well-documented changes.
3. Record any non-trivial decision as an ADR in `docs/adr/` before building
   on it.
4. Open a Pull Request with a clear description.

## Anonymization Requirement

The sample workload is Tawira, a private application, shown here under the
generic name `atlas-demo-api`, as in the other Atlas repositories.

- Use the generic service name `atlas-demo-api`.
- Redact hosted-project references from any captured command output before
  committing it.
- Never commit `.env` files, API keys, tokens, kubeconfigs or webhook URLs.

## Evidence Standards

- Label every measurement with the environment it came from. Results from a
  local kind cluster are not AWS service timings.
- A single run is an observation, not a result. State the run count.
- A component is "done" only when its check in the README milestone table
  has been run and its output is committed.
- Write down findings that contradict the plan. They are evidence, not
  embarrassment.

## Commit Messages

Follow a clear, descriptive style.

```text
feat(cluster): add kind config for the platform cluster
docs(adr): add ADR-0002 for the app-of-apps layout
fix(chart): correct readiness probe port
```

## Code Standards

- Keep deployments reproducible: one command, pinned versions.
- Pin GitHub Actions to a commit SHA with the version in a comment.
- Prefer small, focused commits.
- No `apply` against real AWS from CI.
- Secret values never appear in Git: the repository holds references only.
