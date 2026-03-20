---
name: code-review
description: >
  Review code for quality, security, performance, and adherence to Rhombus
  engineering conventions. Use this skill when the user asks to review code,
  check a file for issues, audit code quality, or look for bugs. Also trigger
  when the user mentions: code review, review this, check this code, find bugs,
  code quality, security review, PR review, pull request review, look over this,
  code audit, what's wrong with this code, improve this code, best practices check.
argument-hint: "[file path or PR number]"
allowed-tools: Read, Grep, Glob, Bash
---

# Code Review

Perform a thorough code review focused on quality, security, and maintainability.

## Review Process

### 1. Understand Context

- Read the file(s) or diff provided
- Identify the language, framework, and patterns in use
- Check for related test files and documentation

### 2. Review Checklist

Evaluate the code against these categories:

#### Correctness
- Logic errors or off-by-one bugs
- Unhandled edge cases (null, empty, boundary values)
- Race conditions or concurrency issues
- Incorrect error handling

#### Security (OWASP Top 10)
- Injection vulnerabilities (SQL, command, XSS)
- Authentication/authorization gaps
- Sensitive data exposure (hardcoded secrets, logged credentials)
- Insecure deserialization
- Missing input validation at system boundaries

#### Performance
- N+1 queries or unnecessary database calls
- Missing pagination on list endpoints
- Unbounded loops or memory allocations
- Opportunities for caching

#### Maintainability
- Unclear naming or overly complex logic
- Functions doing too many things
- Missing or misleading comments
- Dead code or unused imports

#### Testing
- Are critical paths tested?
- Are edge cases covered?
- Are tests readable and not testing implementation details?

### 3. Output Format

```
## Code Review: <file or PR>

### Summary
<1-2 sentence overview of the code's purpose and overall quality>

### Critical Issues
- [CRITICAL] <file:line> — <description and fix>

### Improvements
- [IMPROVE] <file:line> — <description and suggestion>

### Nits
- [NIT] <file:line> — <minor style/convention suggestion>

### Positive Notes
- <things done well worth calling out>

### Verdict: APPROVE / REQUEST CHANGES / NEEDS DISCUSSION
```

## Guidelines

- Be constructive — explain WHY something is an issue, not just that it is
- Prioritize: security > correctness > performance > maintainability > style
- Don't nitpick style that a formatter would catch
- If reviewing a PR diff, focus on changed lines but note if surrounding context has issues
- Suggest specific fixes, not just "this is wrong"
