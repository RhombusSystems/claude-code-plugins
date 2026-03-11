---
name: expense-report
description: >
  Generate expense report templates, categorize expenses, and help prepare
  expense documentation for submission. Use this skill when the user asks to
  create an expense report, categorize expenses, prepare reimbursement docs,
  or organize receipts. Also trigger on: expense report, expense template,
  reimbursement, expense categories, travel expenses, expense summary,
  receipt organization, expense submission, T&E report, business expenses,
  expense categorization, cost report.
disable-model-invocation: true
argument-hint: "[expense period or trip name]"
---

# Expense Report Generator

Help prepare structured expense reports and categorize expenses for submission.

## Information Gathering

Ask the user for:

1. **Period** — What dates does this cover?
2. **Purpose** — Business trip, client meeting, monthly expenses, etc.
3. **Expenses** — List of expenses (amount, vendor, date, category)
4. **Currency** — If not USD, what currency?
5. **Policy notes** — Any company limits or special policies to flag?

If the user provides raw data (CSV, receipt list, bank statement excerpt), parse and categorize it automatically.

## Expense Categories

Use standard categories:

| Category | Examples |
|----------|----------|
| Travel - Airfare | Flights |
| Travel - Ground | Uber, taxi, rental car, parking |
| Travel - Lodging | Hotels, Airbnb |
| Meals - Business | Client dinners, team meals |
| Meals - Travel | Meals during business travel |
| Office Supplies | Equipment, software, subscriptions |
| Professional Development | Conferences, courses, books |
| Client Entertainment | Events, gifts |
| Miscellaneous | Other business expenses |

## Report Format

```markdown
# Expense Report
**Employee:** _________________
**Department:** _________________
**Period:** <date range>
**Purpose:** <business justification>
**Submitted:** <date>

---

## Summary
| Category | Amount |
|----------|--------|
| Travel - Airfare | $X,XXX.XX |
| Travel - Ground | $XXX.XX |
| Travel - Lodging | $X,XXX.XX |
| Meals - Business | $XXX.XX |
| Meals - Travel | $XXX.XX |
| Office Supplies | $XXX.XX |
| **Total** | **$X,XXX.XX** |

## Itemized Expenses
| Date | Vendor | Description | Category | Amount | Receipt |
|------|--------|-------------|----------|--------|---------|
| MM/DD | <vendor> | <description> | <category> | $XX.XX | [Y/N] |

## Notes
- <any policy exceptions or explanations needed>

## Approvals
- [ ] Employee signature: _________________ Date: _______
- [ ] Manager approval: _________________ Date: _______
```

## Guidelines

- Always include a business justification for the overall report
- Flag any expenses that might exceed typical company policy limits
- Group and subtotal by category
- Note missing receipts — most companies require receipts over $25-50
- If the user provides data in a messy format, clean it up and ask for confirmation before finalizing
- Calculate totals accurately — double-check arithmetic
