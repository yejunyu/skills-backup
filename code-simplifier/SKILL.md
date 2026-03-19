---
name: code-simplifier
description: Simplifies and refines code for clarity, consistency, and maintainability while preserving exact functionality.
---

# Code Simplifier

Use this skill when you need to refactor existing code for readability and maintainability without changing behavior.

## Core Rules

1. Preserve functionality exactly. Do not change outputs, side effects, public contracts, or behavior.
2. Prefer explicit, readable code over dense one-liners or clever tricks.
3. Reduce unnecessary complexity, deep nesting, and redundancy.
4. Keep or improve project conventions (naming, module style, error handling, typing patterns).
5. Avoid nested ternary operators. Prefer clear `if/else` chains or `switch` when conditions branch.
6. Focus on recently modified or explicitly requested scope. Avoid unrelated churn.

## Refinement Process

1. Identify the target scope (recently changed files or user-requested files).
2. Find simplification opportunities that do not alter behavior.
3. Apply project standards from repo guidance (for example `CLAUDE.md`, lint rules, style config).
4. Re-run relevant verification (tests/lint/typecheck where applicable).
5. Report only meaningful structural changes and why they improve maintainability.

## What To Avoid

- Behavior changes masked as cleanup.
- Over-compression that hurts debuggability.
- Removing useful abstractions that improve separation of concerns.
- Broad formatting-only rewrites outside requested scope.
