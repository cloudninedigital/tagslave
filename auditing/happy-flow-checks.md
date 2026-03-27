# Happy Flow Checks — GTM Audit

## Overview
Happy flow checks (Section 4, Q5.x) verify that GTM behaves correctly during a simulated user journey. These checks require a live GTM Preview session — they cannot be automated via the connector or web_fetch. The auditor must perform them and report findings.

---

## What to ask the auditor to do

Provide these instructions when requesting happy flow observations:

> "Please open GTM Preview for the container, visit the website, and walk through the full happy flow from homepage to purchase confirmation. While doing so, note:
> 1. Any errors or warnings in the GTM Preview console tab
> 2. The list of events firing on each page (check for unexpected duplicates)
> 3. Whether a scroll event fires and on which pages
> 4. The Tag Assistant Hits Sent tab — which events reach which GA4 property
> 5. On the purchase confirmation page specifically: does the purchase event appear exactly once?"

---

## Q5.1 — Console errors during happy flow

### What to look for
GTM Preview shows a Console tab. Errors here indicate:
- JavaScript conflicts between GTM tags
- Tags referencing variables that return undefined
- Timer-based tags creating repeated errors (especially on homepage)
- Missing dependencies (e.g. a tag calling a function that doesn't exist)
- dataLayer events with malformed data causing tag failures

### Severity classification
| Error type | Severity |
|---|---|
| Single error, isolated page | Minor — Requires improvement |
| Recurring error on multiple pages | Moderate — Requires improvement |
| Plentiful errors, console flooding | Requires immediate attention |
| Errors on checkout or purchase page | Requires immediate attention regardless of count |
| Recurring warning on specific event (e.g. view_search_results) | Requires improvement — note the event name |

### Timer tag flooding pattern
A common issue: a tag fires on a timer trigger (e.g. every 5 seconds) on the homepage.
Signal: the same event/tag appears repeatedly in GTM Preview with identical interval spacing.
Impact: inflates hit counts, floods the console, may contribute to quota issues.
If detected: flag the tag name and interval in the comment.

---

## Q5.2 — Duplicate page views

### Detection method
In GTM Preview, on any single page load, count the number of `page_view` events in the Hits Sent column for the GA4 property.

**Also check via GTM connector (Tier 2):**
Look for this combination which is the most common cause of duplicates:
- GA4 Config tag (`type = googtag`) with parameter `send_page_view = true`
- AND a separate GA4 Event tag (`type = gaawe`) with `eventName = page_view`
- Both firing on the same trigger (e.g. All Pages)

If both exist and fire simultaneously: duplicate page views are certain.

**SPA/hybrid sites:**
On Single Page Applications, page views may be tracked via `gtm.historyChange` events.
Verify: does a new page_view fire on each navigation? Does it also fire on initial page load? If both fire on load = duplicate.

### Hardcoded parallel page view (cross-reference with web_fetch)
If web_fetch revealed a hardcoded `gtag("config", "G-XXXXXXXX")` call, this fires its own page_view independently of GTM's GA4 Config tag. This creates page views in the parallel property (not the GTM property) but is still an architectural concern to note.

---

## Happy flow — what a clean result looks like

For reference: what the auditor should see in a well-implemented container during happy flow:

| Page | Expected events in GTM Preview |
|---|---|
| Any page load | Consent events (in correct sequence), page_view, scroll (if configured) |
| Category/list page | view_item_list with populated items array |
| Product detail page | view_item with item data |
| Add to cart action | add_to_cart |
| Cart page | view_cart |
| Checkout start | begin_checkout |
| Shipping step | add_shipping_info |
| Payment step | add_payment_info |
| Order confirmation | purchase (exactly once) |

Absence of any expected event = note in Data Layer section (Section 5), not here.
Presence of unexpected events or duplicates = note here (Section 4, Q5).

---

## Tag Assistant — Hits Sent cross-reference

The Tag Assistant "Hits Sent" view shows which events reach which GA4 property. Ask auditor to share this view or describe what they see.

**What to look for:**
- Are all expected events reaching the primary GA4 property?
- Is any event reaching a secondary/unknown property? (indicates parallel implementation)
- Are Abtesting/Varify events visible? (confirms A/B test integration is firing — cross-reference with Data Layer section)
- Are form events (form_start, form_submit) visible on relevant pages?
- Are scroll events visible? (confirms scroll tracking is active)

**Flag:** If both G-XXXXXXXX properties appear in the Hits Sent view, this visually confirms the parallel implementation architecture identified in web_fetch.
