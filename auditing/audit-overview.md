# Audit Overview

## The 9-sheet Excel structure

Every audit file contains these sheets in this order:

1. **Management summary** — auto-populated score blocks + overall summary text
2. **Checklist** — prioritised action items derived from all findings (P1/P2/P3)
3. **Difference GA4 - Backend** — conversion count and revenue gap analysis
4. **GA4 vs Marketing applications** — Google Ads, Meta, and other platform comparisons
5. **Standardization & Compliancy** — UTM, channel grouping, documentation, cookie compliance
6. **Tag Manager** — GTM container audit across 6 sub-sections
7. **Data layer** — dataLayer push quality and GTM tag mapping evaluation
8. **GA4** — GA4 property configuration audit from GA4 Monitor CSV
9. **Lists** — dropdown value lists (do not modify)

---

## Question numbering convention

Each sheet has numbered questions (e.g. 1.1, 1.2, 4.1–4.8, 6.1–6.8).
The Tag Manager sheet uses sub-sections:
- 1.x — Account Structure
- 2.x — Best Practices
- 3.x — Security
- 4.x — GTM Interface
- 5.x — Happy Flow
- 6.x — Consent

Each question has two output fields:
- **Result** — one of the four rating values (see `methodology/rating-thresholds.md`)
- **Comments** — prose explanation (see `methodology/comment-style-guide.md`)

---

## Workflow overview

```
Client context collected
        ↓
URL provided → web_fetch → extract static signals (GTM IDs, hardcoded scripts, consent defaults)
        ↓
GTM connector → pull container data → evaluate Tag Manager questions
        ↓
Auditor provides dataLayer pushes → evaluate Data Layer questions
        ↓
Auditor provides GA4 Monitor CSV → pivot table → evaluate GA4 questions
        ↓
Auditor provides backend numbers → calculate gaps → evaluate Section 1
        ↓
Auditor provides marketing platform numbers → calculate gaps → evaluate Section 2
        ↓
Auditor describes UTM/channel grouping/cookie setup → evaluate Section 3
        ↓
Generate: all question Results + Comments
Generate: section summaries
Generate: Management summary
Generate: Checklist (P1/P2/P3)
```

---

## Follow-up audit handling

When `audit_type = follow-up`:
- Add a "Post audit review" column to relevant sheets
- Comment framing shifts from "X is broken" to "X persists / X was resolved / X improved"
- Checklist items carry over from previous audit with status update
- Note the review date explicitly in each updated comment
