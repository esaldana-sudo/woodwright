# Contributing

Thanks for your interest! This repo uses small, reviewable PRs and an MVP-first mindset.

## Workflow
1. Fork and clone the repo.
2. Create a feature branch: `git checkout -b feat/<short-name>`
3. Keep PRs under ~300 lines when possible; add tests for calculators.
4. Describe *why* in the PR (user story & acceptance criteria).

## Code style
- Flutter/Dart: follow `flutter_lints`
- Prefer pure functions in domain calculators; unit test with fixed fixtures.
- Enforce safety in joinery rules (block unsafe options).

## Commit messages
Conventional commits are encouraged:
- `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`

## Issues
Use issue templates under `.github/ISSUE_TEMPLATE`. Provide steps to reproduce and expected behavior.
