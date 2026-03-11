---
name: onboarding-checklist
description: >
  Generate onboarding checklists and guides for new team members at Rhombus.
  Use this skill when the user asks to create an onboarding plan, new hire
  checklist, onboarding guide, first-week plan, or team onboarding document.
  Also trigger on: new employee setup, onboarding doc, welcome guide, getting
  started guide, new hire orientation, onboarding steps, team setup checklist,
  day one plan, 30-60-90 plan.
disable-model-invocation: true
argument-hint: "[role or team name]"
---

# Onboarding Checklist Generator

Create structured onboarding checklists tailored to a specific role or team.

## Information Gathering

Ask the user for:

1. **Role/title** — What position is being onboarded?
2. **Team** — Which team are they joining?
3. **Start date** (optional) — To set timeline milestones
4. **Tools & systems** — What tools does this role use daily?
5. **Key contacts** — Who should the new hire meet?
6. **Special requirements** — Any certifications, access levels, or training needed?

## Checklist Format

```markdown
# Onboarding Checklist: <Role> — <Team>
**Created:** <date>
**New Hire:** _________________
**Manager:** _________________
**Buddy:** _________________

---

## Pre-Start (Before Day 1)
- [ ] Send welcome email with start date, time, and location
- [ ] Set up accounts: <list relevant tools>
- [ ] Order equipment: <laptop, monitors, etc.>
- [ ] Add to team channels: <Slack channels>
- [ ] Schedule Day 1 orientation meetings
- [ ] Assign onboarding buddy

## Week 1: Orientation & Setup
### Day 1
- [ ] Welcome meeting with manager
- [ ] IT setup and account verification
- [ ] Office/building tour (or remote setup walkthrough)
- [ ] Review team norms and communication preferences
- [ ] Meet onboarding buddy

### Days 2-5
- [ ] Complete required HR training
- [ ] Read team documentation and READMEs
- [ ] Set up development environment (if engineering)
- [ ] Attend team standup/sync
- [ ] 1:1 meetings with key collaborators
- [ ] Complete first small task or shadowing session

## Weeks 2-4: Ramp Up
- [ ] Take ownership of first real task/project
- [ ] Attend all recurring team meetings
- [ ] Complete role-specific training: <list>
- [ ] Review and understand team OKRs/goals
- [ ] Weekly 1:1 with manager (ongoing)
- [ ] Meet cross-functional partners

## Month 2-3: Full Contribution
- [ ] Own a workstream independently
- [ ] Contribute to planning/sprint sessions
- [ ] 30-day check-in with manager
- [ ] 60-day check-in with manager
- [ ] 90-day review and goal-setting

---

## Key Resources
| Resource | Link |
|----------|------|
| <handbook/wiki> | <url> |
| <tool docs> | <url> |
| <team page> | <url> |
```

## Guidelines

- Tailor the checklist to the specific role — an engineer's onboarding differs from a marketer's
- Include both administrative tasks (accounts, HR) and social tasks (meet the team)
- Set realistic timelines — don't expect full productivity in week 1
- Include checkboxes so the document is actionable
- Note who is responsible for each item (manager, IT, buddy, new hire)
