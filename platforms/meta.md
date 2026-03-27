---
name: meta-pixel
description: Set up, configure, audit, and debug Meta Pixel (browser-side) implementations
  via GTM. Use this skill when the user asks about Meta Pixel setup, fbq() events,
  standard events, object properties, CAPI deduplication, event match quality, advanced
  matching, or pixel QA. Trigger whenever the user mentions Meta Pixel, Facebook Pixel,
  fbq, Purchase event, ViewContent, AddToCart, eventID, or EMQ.
---

# Meta Pixel — GTM Implementation

Reference and playbook for implementing, auditing, and debugging Meta Pixel via GTM,
including CAPI deduplication and Advanced Matching.

> Source: https://developers.facebook.com/docs/meta-pixel/reference

---

## When to use this skill
- Setting up Meta Pixel tags and triggers in GTM for the first time
- Implementing standard events (Purchase, ViewContent, AddToCart, etc.)
- Writing `eventID` logic for CAPI deduplication
- Auditing an existing Meta Pixel implementation for errors or gaps
- Debugging missing events or parameters in Events Manager
- Implementing Advanced Matching to improve Event Match Quality (EMQ)
- Validating pixel behaviour in pre- and post-consent states

---

## What you need from the user
- Pixel ID (find in Ads Manager → Events Manager)
- Which standard events to implement
- Whether CAPI is also running (deduplication required if yes)
- dataLayer schema for ecommerce data — see `data-layer/ecommerce-events.md`
- Client's consent policy — see `snippets/consent-handling.md`

If any of the above are missing, ask before writing tags.

---

## Process

### Step 1 — GTM variable setup
Create these variables once per container. Reference them in all Meta tags.

| Variable name | Type | dataLayer key |
|---|---|---|
| `{{Const - Meta Pixel ID}}` | Constant | `[Pixel ID]` |
| `{{DLV - event_id}}` | Data Layer Variable | `event_id` |
| `{{DLV - ecom.value}}` | Data Layer Variable | `ecommerce.value` |
| `{{DLV - ecom.currency}}` | Data Layer Variable | `ecommerce.currency` |
| `{{DLV - ecom.items}}` | Data Layer Variable | `ecommerce.items` |

---

### Step 2 — Init / PageView tag
Fires on every page. Must load before any event tags — set as **setup tag** for all
other Meta tags.

```javascript
// Custom HTML tag — fires on All Pages
!function(f,b,e,v,n,t,s)
{if(f.fbq)return;n=f.fbq=function(){n.callMethod?
n.callMethod.apply(n,arguments):n.queue.push(arguments)};
if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
n.queue=[];t=b.createElement(e);t.async=!0;
t.src=v;s=b.getElementsByTagName(e)[0];
s.parentNode.insertBefore(t,s)}(window, document,'script',
'https://connect.facebook.net/en_US/fbevents.js');
fbq('init', '{{Const - Meta Pixel ID}}');
fbq('track', 'PageView');
```

Tag naming: `[Meta] - Init + PageView - All Pages`

---

### Step 3 — Standard event tags
Use `fbq('track', 'EventName', {parameters}, {eventID: '...'})`.

Always include `eventID` when CAPI is running — see Step 4.

| Event | When to fire | Required params | Optional params |
|---|---|---|---|
| `PageView` | Every page load | — | — |
| `ViewContent` | Product/landing page | — | `content_ids`, `content_type`, `contents`, `currency`, `value` |
| `Search` | Search results | — | `content_ids`, `contents`, `currency`, `search_string`, `value` |
| `AddToCart` | Add to cart | — | `content_ids`, `content_type`, `contents`, `currency`, `value` |
| `AddToWishlist` | Add to wishlist | — | `content_ids`, `contents`, `currency`, `value` |
| `InitiateCheckout` | Enter checkout | — | `content_ids`, `contents`, `currency`, `num_items`, `value` |
| `AddPaymentInfo` | Payment info saved | — | `content_ids`, `contents`, `currency`, `value` |
| `Purchase` | Order confirmed | `currency`, `value` | `content_ids`, `content_type`, `contents`, `num_items` |
| `Lead` | Form completed | — | `currency`, `value` |
| `CompleteRegistration` | Registration done | — | `currency`, `value`, `status` |
| `Contact` | Contact initiated | — | — |
| `Schedule` | Appointment booked | — | — |
| `StartTrial` | Free trial started | — | `currency`, `predicted_ltv`, `value` |
| `Subscribe` | Paid subscription | — | `currency`, `predicted_ltv`, `value` |

> **Advantage+ catalog ads**: `contents` or `content_ids` required on `ViewContent`,
> `AddToCart`, `Purchase`, and `Search`.

**Object properties reference:**

| Property | Type | Notes |
|---|---|---|
| `content_ids` | Array of strings | Product SKUs — e.g. `['ABC123', 'XYZ789']` |
| `content_type` | String | `'product'` or `'product_group'` — must match what `content_ids` references |
| `contents` | Array of objects | `[{id: 'ABC123', quantity: 2}]` — `id` + `quantity` required |
| `content_name` | String | Page or product name |
| `content_category` | String | Page or product category |
| `currency` | String | ISO 4217 — e.g. `'EUR'`, `'USD'` |
| `value` | Number | Monetary value of the event |
| `num_items` | Integer | Item count at checkout (`InitiateCheckout` only) |
| `search_string` | String | Search term (`Search` only) |
| `predicted_ltv` | Number | Predicted lifetime value (`StartTrial`, `Subscribe`) |
| `status` | Boolean | Registration status (`CompleteRegistration` only) |

---

### Step 4 — CAPI deduplication (when server-side is also running)
Both browser pixel and CAPI must send the **same `eventID`** per event instance.
Meta deduplicates on `eventID` + `event_name` + time window.

```javascript
// Generate eventID — push to dataLayer so CAPI tag can read it too
var eventId = 'purchase_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
dataLayer.push({ event_id: eventId });

// Fire pixel with eventID as 4th argument
fbq('track', 'Purchase',
  {
    currency: '{{DLV - ecom.currency}}',
    value: '{{DLV - ecom.value}}',
    content_ids: ['{{DLV - ecom.items}}'],
    content_type: 'product'
  },
  { eventID: eventId }
);
```

- EventID must be **unique per event instance** — not per page or session
- Pass `{{DLV - event_id}}` into the CAPI server-side tag as well
- See `server-side/sgtm-tag-templates.md` for CAPI tag config

---

### Step 5 — Advanced Matching (optional but recommended)
Pass hashed customer data on `fbq('init')` to improve Event Match Quality (EMQ).

```javascript
fbq('init', '{{Const - Meta Pixel ID}}', {
  em: '{{DLV - customer.email_hashed}}',   // SHA-256 hashed email
  ph: '{{DLV - customer.phone_hashed}}',   // SHA-256 hashed phone
  fn: '{{DLV - customer.firstname_hashed}}',
  ln: '{{DLV - customer.lastname_hashed}}'
});
```

> Never pass unhashed PII. Hash server-side before pushing to the dataLayer.

---

## Output format

For **tag setups**, always deliver in this order:
1. Variables needed
2. Tag code (in a code block)
3. Trigger configuration
4. Tag naming (follow `conventions/naming-conventions.md`)

For **audits**, use the severity structure:

### 🔴 Critical
Data loss or compliance violation.
_Example: Purchase event firing without `currency` and `value`; duplicate events
without deduplication._

### 🟡 Warning
Incorrect data or degraded performance.
_Example: `content_type` mismatch; low EMQ score due to missing Advanced Matching._

### 🟢 Suggestion
Nice-to-have improvements.
_Example: Add `content_name` to ViewContent for richer reporting._

---

## Rules & constraints
- Always set the Init tag as **setup tag** for every other Meta tag — never assume
  it fired first
- Always include `eventID` when CAPI is running — no exceptions
- `content_type` must match what `content_ids` actually references — mismatch breaks
  catalog ads
- Never pass raw (unhashed) PII to the pixel — hash everything server-side first
- For Advantage+ catalog ads: `contents` or `content_ids` is required, not optional
- Custom events (`fbq('trackCustom', ...)`) cannot be used for conversion optimisation
  — use standard events wherever a match exists

---

## Common issues & fixes

| Issue | Likely cause | Fix |
|---|---|---|
| Duplicate Purchase events | Browser + CAPI without deduplication | Add matching `eventID` to both |
| `content_type` mismatch | Passing group IDs but setting `'product'` | Match `content_type` to what the IDs reference |
| Missing `currency` on Purchase | Not pulling from dataLayer | Map `{{DLV - ecom.currency}}` |
| Pixel fires before init | Event tag firing without setup tag | Set init tag as setup tag on all event tags |
| Low EMQ score | Missing Advanced Matching params | Pass hashed `em`, `ph`, `fn`, `ln` on init |
| No events in Events Manager | Consent Mode blocking pixel | Check `ads_storage` state — see `snippets/consent-handling.md` |
| Events in test but not live | Pixel Helper active, not real traffic | Disable Pixel Helper and retest in Incognito |

---

## References
- Meta Pixel Reference: https://developers.facebook.com/docs/meta-pixel/reference
- CAPI Deduplication: https://developers.facebook.com/docs/marketing-api/conversions-api/deduplicate-pixel-and-server-events
- Consent & GDPR: https://developers.facebook.com/docs/facebook-pixel/implementation/gdpr
- See `server-side/sgtm-tag-templates.md` for CAPI server-side tag setup
- See `snippets/consent-handling.md` for consent mode integration
- See `data-layer/ecommerce-events.md` for dataLayer schema
- See `conventions/naming-conventions.md` for GTM tag naming rules
