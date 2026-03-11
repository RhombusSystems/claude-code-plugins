---
name: status-report
description: >
  Generate structured status reports, project updates, and weekly summaries
  for leadership and stakeholders. Use this skill when the user asks to write
  a status report, project update, weekly update, progress report, leadership
  update, or team summary. Also trigger on: status update, standup summary,
  executive summary, progress check, what's the status, weekly recap, sprint
  summary, project status, team update, 3P update, stakeholder update.
disable-model-invocation: true
argument-hint: "[project or team name]"
---

# Status Report Generator

Generate clear, structured status reports for leadership and stakeholders.

## Information Gathering

Before writing the report, ask the user for:

1. **Reporting period** — What timeframe does this cover? (e.g., this week, this sprint, this month)
2. **Audience** — Who is this for? (e.g., leadership, cross-functional partners, the team)
3. **Key accomplishments** — What was completed or shipped?
4. **In progress** — What's currently being worked on?
5. **Blockers/risks** — Anything slowing the team down or at risk?
6. **Upcoming** — What's planned for the next period?
7. **Metrics** (optional) — Any numbers worth highlighting?

If the user provides context (e.g., git log, Jira/Linear data, meeting notes), use it to populate the report instead of asking.

## Report Format

```markdown
# Status Report: <Project/Team Name>
**Period:** <date range>
**Author:** <name>
**Date:** <today>

---

## Summary
<2-3 sentence executive summary of the most important takeaway>

## Completed
- <accomplishment with context on impact>
- <accomplishment>

## In Progress
- <work item> — <current status, % complete or ETA>
- <work item> — <status>

## Blockers & Risks
- [BLOCKER] <description> — **Owner:** <who can unblock> — **Impact:** <what's affected>
- [RISK] <description> — **Likelihood:** High/Med/Low — **Mitigation:** <plan>

## Upcoming (Next Period)
- <planned work item>
- <planned work item>

## Metrics (if applicable)
| Metric | Previous | Current | Trend |
|--------|----------|---------|-------|
| <metric> | <value> | <value> | <up/down/flat> |

## Asks / Decisions Needed
- <any decisions or approvals needed from the audience>
```

## Writing Guidelines

- Lead with impact, not activity — "Shipped feature X, reducing support tickets by 30%" not "Worked on feature X"
- Keep each bullet to 1-2 lines — this is a scan document, not a narrative
- Be honest about blockers — surfacing problems early builds trust
- Quantify when possible — numbers are more memorable than adjectives
- Match the formality to the audience — leadership gets concise summaries, team gets more detail
