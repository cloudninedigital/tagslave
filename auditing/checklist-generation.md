# Checklist Generation

## When to generate
Generate the checklist after all 6 sections are complete. The checklist is a prioritised action plan derived from all findings — it should add no new information, only organise existing findings into executable tasks.

---

## Priority assignment rules

### Priority 1 — Immediate action required
Derive from: all questions rated `Requires immediate attention`
Characteristics: legal risk, data loss, broken conversion tracking, or non-functional events

**Always Priority 1:**
- Any consent compliance failure (tags firing before consent, incorrect default state, post-consent timing broken)
- Purchase event broken or producing unreliable data
- Parallel implementation sending data to uncontrolled property
- PII in dataLayer
- Console errors on checkout or purchase pages
- view_item_list with empty items array (if it is a core funnel event)
- Missing events that are business-critical (select_item if attribution depends on it)
- Backend-GA4 gap > 10%
- GA4 vs Ads gap > 20%

### Priority 2 — Improvement needed
Derive from: all questions rated `Requires improvement`
Characteristics: data quality degradation, analytical gaps, governance issues

**Always Priority 2:**
- Missing value/currency parameters in GTM ecommerce tags (systemic)
- Broken GTM variable paths (affiliation, payment_type, shipping_tier)
- UA legacy fields in dataLayer (cleanup)
- UTM fragmentation / channel grouping issues
- Container oversized or tag count high
- Paused tags older than 6 months
- Unlinked triggers and variables
- Missing custom dimension registrations in GA4
- Backend-GA4 gap 5–10%
- Missing recommended parameters (coupon, new_customer, etc.)

### Priority 3 — Governance and maintenance
Derive from: best-practice gaps that do not affect data quality directly

**Always Priority 3:**
- Create or update measurement documentation (SDR)
- Create UTM tagging guidelines for marketing team
- Historical tag review and cleanup
- Enable GTM Consent Overview
- Review cHTML tags for security
- Custom dimension documentation

---

## Consolidation rules

### Consolidate by root cause, not by question
Each checklist item should represent a single action, even if that action fixes multiple audit questions.

**Do not create separate items for:**
- Q3.2 begin_checkout missing value + Q3.3 add_to_cart missing value + Q3.4 view_item missing value

**Create one item:**
- "Map value and currency parameters in all GA4 ecommerce tags" — describe scope in description field

**Do not create separate items for:**
- Q6.7 GTM tags not consent-gated + Q6.5 Post-consent timing broken + Q6.8 Consent hardcoded

**Create one item per distinct action:**
- "Enforce GTM consent gating on all marketing tags" (fixes Q6.7)
- "Investigate and fix post-consent return visit timing" (fixes Q6.5/Q6.6)
- "Migrate Consent Mode management to GTM" (fixes Q6.8, requires development)

### Platform-specific actions stay separate
Do not consolidate actions that require different people or systems:
- GTM changes = one item
- Magento/backend changes = separate item
- Platform configuration (Google Ads, Meta) = separate item

---

## Checklist item format

For each item, produce:

| Field | Content |
|---|---|
| Action | Short imperative phrase, 3–8 words. Start with a verb. |
| Description | One sentence: what specifically must be done, and why. |
| Category | Tag Manager / Data layer / GA4 / Standardization & Compliance |
| Priority | 1, 2, or 3 |

### Good action phrases
- "Enforce GTM consent gating on all marketing tags"
- "Map value and currency in GA4 ecommerce event tags"
- "Fix broken GTM variable paths for purchase enrichment"
- "Decommission G-CNCT6DBHPM after migrating custom events"
- "Investigate and fix post-consent return visit timing"
- "Repair view_item_list items array population in Magento"
- "Standardize UTM naming conventions across paid channels"
- "Create tracking measurement documentation (SDR)"

### Poor action phrases (avoid)
- "Fix tracking issues" — too vague
- "Address consent" — not actionable
- "Update the dataLayer" — not specific
- "Improve data quality" — not actionable

---

## Ordering within each priority tier

Within Priority 1, order by:
1. Legal/consent risk first
2. Main conversion reliability second
3. Data loss (missing events) third
4. Platform alignment fourth

Within Priority 2, order by:
1. Revenue/monetary parameter gaps first (affect all reporting)
2. Broken variable paths second
3. Missing event implementations third
4. Container hygiene fourth
5. Documentation and governance last

---

## Checklist size norms

Based on three-client audit experience:
- Typical Priority 1 items: 4–8
- Typical Priority 2 items: 6–12
- Typical Priority 3 items: 2–4
- Total: 12–24 items

If checklist exceeds 25 items: consolidate further. Too many items reduces actionability.
If checklist has fewer than 8 items total: check that all `Requires immediate attention` and `Requires improvement` findings have been captured.
