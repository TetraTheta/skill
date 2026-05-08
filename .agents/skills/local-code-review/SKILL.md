---
name: local-code-review
description: "Generic, high-signal code review skill for any project: prioritizes security, correctness, regressions, performance, maintainability, and test gaps; reasons in English for analysis quality and delivers final review feedback in Korean."
---

# Code Review Skill (Generic, Reusable)

## Purpose
Provide consistent, high-signal pull request and patch reviews for any software project.
Focus on finding real risks first, then provide concise, actionable guidance.

## Language Policy
- Think and reason in English if it improves analysis quality.
- Final reviewer-facing response MUST be in Korean.
- Do not mix languages in the final review except for code identifiers, file paths, or standard technical terms.

## Review Priorities (in order)
1. Security and privacy risks
2. Correctness and potential regressions
3. Performance and scalability concerns
4. Maintainability and architecture consistency
5. Readability, style, and developer experience
6. Test coverage and validation quality

## Core Review Rules
- Prefer evidence-based findings over generic advice.
- Report only meaningful issues; avoid noise.
- Preserve current behavior unless a behavior change is clearly intended by the patch.
- If requirements are ambiguous, state assumptions explicitly.
- Recommend minimal, safe fixes before larger refactors.

## Severity Model
- Critical: exploitable security issue, data loss, or production outage risk.
- High: likely functional bug, major regression, or serious reliability issue.
- Medium: maintainability/performance issue with real impact.
- Low: minor quality/style issue with limited impact.

## What To Check

### 1) Security
- Input validation and output encoding/sanitization.
- Authentication/authorization boundaries.
- Secret handling (no hardcoded keys/tokens/passwords).
- Unsafe deserialization, command execution, path traversal, injection vectors.
- External calls and dependency trust boundaries.

### 2) Correctness
- Edge cases, null/empty handling, error paths.
- State transitions and business logic consistency.
- Concurrency/async race conditions or ordering bugs.
- API contract compatibility and backward compatibility.

### 3) Performance
- Obvious N+1 or repeated expensive operations.
- Unbounded loops, large memory spikes, blocking operations.
- Inefficient data structures/algorithms in hot paths.

### 4) Maintainability
- Clear module boundaries and separation of concerns.
- Consistent patterns with the existing codebase.
- Type safety, explicit contracts, and meaningful abstractions.

### 5) Style and Readability
- Naming clarity, cohesion, and local complexity.
- Error messages/logging usefulness.
- Project lint/format conventions where applicable.

### 6) Testing
- New/changed logic has adequate tests.
- Regression tests for bug fixes.
- Critical paths and failure modes are covered.

## Output Format (Korean)
Use this structure:

1. **주요 발견사항**
   - 항목별로 `심각도`, `파일/위치`, `문제`, `영향`, `권장 수정`을 간결히 작성.
2. **확인 필요/가정**
   - 요구사항이 불명확한 부분, 리뷰 시 가정한 내용.
3. **요약**
   - 전체 위험도와 병합 전 필수 조치 여부.

If no meaningful issues are found, explicitly say:
- "치명적/중요 이슈를 발견하지 못했습니다."
- Then mention residual risks (e.g., missing tests, unverified runtime paths).

## Scope Adaptation
- Apply language/framework-specific best practices based on detected stack.
- Do not assume a specific domain (finance, healthcare, agriculture, etc.).
- Do not require repository-specific paths or architecture unless present in the patch context.

## Non-Goals
- Do not demand broad rewrites for small patches.
- Do not block on subjective preferences without clear impact.
- Do not invent requirements that are not supported by code or context.
