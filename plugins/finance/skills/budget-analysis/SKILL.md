---
name: budget-analysis
description: >
  Analyze budgets, compare actuals to plan, identify variances, and generate
  budget summary reports. Use this skill when the user asks to analyze a budget,
  compare spend vs plan, review financial variances, or summarize budget status.
  Also trigger on: budget review, budget analysis, variance analysis, spend
  analysis, budget vs actual, over budget, under budget, budget summary,
  financial review, cost analysis, budget tracking, quarterly budget, annual
  budget, department budget, budget report.
allowed-tools: Read, Grep, Glob
argument-hint: "[budget file or department name]"
---

# Budget Analysis

Analyze budgets, identify variances, and generate actionable financial summaries.

## Process

### 1. Load Budget Data

Accept data from:
- Spreadsheet files (CSV, XLSX) — read and parse
- Pasted tables or numbers from the user
- File paths to budget documents

### 2. Analysis Framework

For each budget line item or category:

| Metric | Formula |
|--------|---------|
| **Variance ($)** | Actual - Budget |
| **Variance (%)** | (Actual - Budget) / Budget x 100 |
| **Run Rate** | (YTD Actual / Months Elapsed) x 12 |
| **Projected Year-End** | Run Rate or trend-based projection |
| **Remaining Budget** | Budget - YTD Actual |

### 3. Variance Classification

Flag variances by severity:

| Status | Criteria |
|--------|----------|
| **ON TRACK** | Variance within +/- 5% |
| **WATCH** | Variance between 5-15% |
| **OVER** | Over budget by >15% |
| **UNDER** | Under budget by >15% (may indicate underinvestment) |

### 4. Output Format

```markdown
# Budget Analysis: <Department/Project>
**Period:** <date range>
**Prepared:** <date>

---

## Executive Summary
<2-3 sentences: overall budget health, biggest variance, key action item>

## Budget vs Actual
| Category | Budget | Actual | Variance ($) | Variance (%) | Status |
|----------|--------|--------|--------------|--------------|--------|
| <item> | $XXX | $XXX | +/- $XX | +/- X% | ON TRACK/WATCH/OVER/UNDER |
| **Total** | **$XXX** | **$XXX** | **+/- $XX** | **+/- X%** | **STATUS** |

## Key Variances
### Over Budget
- **<Category>** (+X%): <explanation of why and recommended action>

### Under Budget
- **<Category>** (-X%): <explanation — is this savings or underinvestment?>

## Projections
| Category | YTD Actual | Run Rate | Year-End Projection | Annual Budget | Projected Variance |
|----------|-----------|----------|--------------------|--------------|--------------------|

## Recommendations
1. <most urgent action item>
2. <second recommendation>
3. <opportunity or reallocation suggestion>
```

## Guidelines

- Always show both dollar and percentage variances — dollars give magnitude, percentages give context
- Don't just report numbers — explain WHY variances exist if the user provides context
- Flag both over AND under budget items — underspend can indicate missed opportunities
- Include projections when you have enough data points for a trend
- Be precise with calculations — double-check all arithmetic
- Round to appropriate precision (dollars to nearest dollar, percentages to one decimal)
