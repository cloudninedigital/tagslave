# Data Collection Audit Skill

## What this skill does
This skill enables Claude to perform a structured, repeatable data collection audit for ecommerce websites. It covers Tag Manager, dataLayer quality, GA4 configuration, backend-to-GA4 data alignment, and marketing platform comparisons. Output is formatted for direct insertion into the standard audit Excel file.

## When to trigger this skill
Trigger when the user:
- Mentions a "data audit", "data collection audit", or "tracking audit"
- Provides a GTM container ID, GTM JSON export, or website URL for audit purposes
- Shares dataLayer pushes and asks for evaluation
- Provides backend vs GA4 numbers and asks for comparison
- Asks to evaluate GA4 vs Google Ads or Meta alignment
- Shares a GA4 Monitor CSV export
- Asks to populate or fill in the audit Excel file

## Audit structure — 6 sections
Each section maps to a sheet in the audit Excel file:

| Section | Sheet name | Primary input source |
|---|---|---|
| 1 | Difference GA4 - Backend | Auditor provides numbers |
| 2 | GA4 vs Marketing applications | Auditor provides numbers |
| 3 | Standardization & Compliancy | Auditor describes / screenshots |
| 4 | Tag Manager | GTM connector + auditor observations |
| 5 | Data layer | URL auto-fetch + auditor provides pushes |
| 6 | GA4 | GA4 Monitor CSV export |

## How Claude should sequence the workflow

### Step 1 — Establish client context (ask once at audit start)
Before beginning any section, collect:
- Client name and website URL
- Primary market and currency
- Audit period (dates)
- Platform stack: CMS, ecommerce platform, CMP name
- Whether this is an initial audit or a follow-up review

### Step 2 — Auto-fetch from URL (do this immediately when URL is provided)
Use `web_fetch` on the provided URL to extract automatically:
- GTM container ID(s) and snippet placement (head vs body)
- Hardcoded `gtag()` calls and parallel GA4 measurement IDs
- Consent default declaration in HTML
- CMP script references
- Initial static dataLayer array
See `sections/4-tag-manager.md` for exact extraction logic.

### Step 3 — Connect to GTM (Section 4)
Use the GTM connector to pull container data.
See `gtm-audit/connector-workflow.md` for the exact sequence of calls and what to extract per audit question.

### Step 4 — Request manual inputs section by section
Do not ask for all inputs at once. Request what is needed per section as the audit progresses.
See each section file in `sections/` for the exact input checklist per section.

### Step 5 — Generate outputs
For each question, produce:
- A `Result` value (one of the four rating labels — see `methodology/rating-thresholds.md`)
- A `Comments` cell entry (see `methodology/comment-style-guide.md`)

For each section, produce a `Summary` paragraph.
For the full audit, produce a prioritised Checklist.
See `outputs/` for formatting rules.

## File reading order
When starting an audit, read in this order:
1. This file (SKILL.md)
2. `methodology/rating-thresholds.md`
3. `methodology/comment-style-guide.md`
4. The relevant section file(s) for the work in progress

Read other files on demand as each section is reached.

## Rating values — use exactly these strings
- `Meets requirements`
- `Requires improvement`
- `Requires immediate attention`
- `To be audited`
