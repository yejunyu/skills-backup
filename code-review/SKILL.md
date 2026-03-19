---
name: code-review
description: Pull request code review workflow with multi-angle analysis and confidence scoring.
---

# Code Review

Use this skill when reviewing a pull request and you want a strict, low-noise review focused on real bugs and policy violations.

## Goal

Produce concise, high-confidence review findings with direct code links. Prioritize correctness and repository guidance compliance.

## Workflow

1. Check review eligibility first:
- PR is open
- PR is not draft
- PR is not auto-generated trivial change
- You have not already posted equivalent review

2. Gather repo guidance context:
- Root `CLAUDE.md` if present
- Any relevant `CLAUDE.md` under modified paths

3. Summarize the PR briefly:
- What changed
- Likely risk surface

4. Run multi-angle review passes:
- Pass A: CLAUDE.md compliance (only applicable rules)
- Pass B: Diff-only obvious bug scan (avoid nitpicks)
- Pass C: Historical context from blame/history for changed code
- Pass D: Prior PR comments on same area that may still apply
- Pass E: Modified-file comments and inline guidance compliance

5. Score each candidate issue with confidence (0-100):
- 0 false positive
- 25 weak hypothesis
- 50 likely but lower impact
- 75 high confidence and important
- 100 certain and frequent/clear

6. Filter aggressively:
- Keep only issues with score >= 80
- Drop pre-existing issues, lint/type/build-only issues, and stylistic nits unless explicitly required by CLAUDE.md

7. Re-check eligibility before posting review.

8. Post concise output:
- `### Code review`
- Findings list with brief reason and supporting link
- If none remain: "No issues found. Checked for bugs and CLAUDE.md compliance."

## Output Requirements

- Keep it brief and factual.
- No emoji unless the target workflow explicitly requires it.
- Every finding must include a stable code link with full commit SHA and line range.
- Include enough surrounding lines for context.

## Non-Goals

- Do not run build/lint/typecheck solely for review signal unless explicitly requested.
- Do not flood with low-confidence concerns.
- Do not comment on unchanged lines unless a changed line directly triggers the issue.
