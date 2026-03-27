# Data Collection Audit Skill

A structured, repeatable skill for performing ecommerce data collection audits covering GTM, dataLayer quality, GA4 configuration, and cross-platform data alignment.

## How Claude uses this skill

Claude reads `SKILL.md` first on every audit engagement. That file defines the workflow, input sequence, and file reading order. All other files are reference material read on demand as each section is reached.

## File map

```
SKILL.md                              Entry point — read first, always

methodology/
  audit-overview.md                   9-section audit structure and workflow diagram
  rating-thresholds.md                All numerical thresholds and rating rules
  comment-style-guide.md              Tone, templates, and annotated comment examples

sections/
  1-backend-vs-ga4.md                 GA4 vs backend gap analysis
  2-ga4-vs-marketing.md               GA4 vs Google Ads, Meta, and other platforms
  3-standardization.md                UTM, channel grouping, documentation, cookie compliance
  4-tag-manager.md                    Full GTM audit — Tier 1/2/3 input logic per question
  5-data-layer.md                     dataLayer push evaluation and GTM tag cross-reference
  6-ga4-config.md                     GA4 Monitor CSV pivot and property configuration audit

gtm-audit/
  connector-workflow.md               GTM connector call sequence and data extraction logic
  consent-checks.md                   Consent Mode v2 evaluation — pre/during/post consent
  tag-health-checks.md                Container structure, tag hygiene, variable audit logic
  happy-flow-checks.md                Page view, ecommerce funnel, error and duplicate checks

datalayer-audit/
  ga4-event-specs.md                  Required/recommended parameters for all 14 ecommerce events
  common-issues.md                    Recurring patterns distilled from real client audits
  gtm-variable-mapping.md             Cross-reference methodology for broken paths and silent drops

comparisons/
  calculation-templates.md            Gap formulas, rating application, footnote formats
  summary-templates.md                Section and overall summary fill-in templates

outputs/
  excel-population-guide.md           Cell conventions, checklist generation, follow-up formatting
  checklist-generation.md             Priority rules and consolidation logic for action items
```

## Audit sections → Excel sheets

| Section file | Excel sheet name |
|---|---|
| 1-backend-vs-ga4.md | Difference GA4 - Backend |
| 2-ga4-vs-marketing.md | GA4 vs Marketing applications |
| 3-standardization.md | Standardization & Compliancy |
| 4-tag-manager.md | Tag Manager |
| 5-data-layer.md | Data layer |
| 6-ga4-config.md | GA4 |

## Input source tiers

| Tier | Source | Examples |
|---|---|---|
| 1 | web_fetch (automatic) | GTM IDs, hardcoded scripts, consent defaults, CMP detection |
| 2 | GTM connector (automatic) | Tags, variables, triggers, consent settings, container metadata |
| 3 | Auditor (manual) | dataLayer pushes, browser observations, platform numbers, backend data |

## Rating values (use exactly)
- `Meets requirements`
- `Requires improvement`
- `Requires immediate attention`
- `To be audited`
