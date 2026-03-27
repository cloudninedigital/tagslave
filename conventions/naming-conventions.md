---
name: gtm-naming-conventions
description: Enforces and applies GTM naming conventions for tags, triggers, and
  variables in a GTM container. Use this skill whenever the user asks to name,
  rename, or review the naming of GTM entities — tags, triggers, variables,
  folders, or workspaces. Also trigger when the user asks to create new tags
  or variables and a name needs to be generated, when auditing a container for
  naming inconsistencies, or when the user says "follow our naming convention",
  "what should I call this", or "check if names are consistent". Always apply
  this skill before creating or renaming any GTM entity.
---

# GTM Naming Conventions

Produces correctly formatted names for GTM tags, triggers, variables, and
workspaces following the established prefix-based convention used across
containers.

## When to use this skill

- User asks to name or rename a tag, trigger, variable, or folder
- User asks Claude to create a new GTM entity and a name is needed
- User asks for an audit of naming consistency in a container
- User uploads a GTM JSON export and asks to check or fix naming
- User says "follow naming conventions", "what should I call this tag", or
  "our naming standard"
- Any entity name is missing a recognised prefix (see prefix table below)

## What you need from the user

- **Entity type**: tag / trigger / variable / workspace
- **Platform or tool**: e.g. GA4, Meta, Google Ads, TikTok, Consent Mode
- **Event or purpose**: e.g. `purchase`, `page_view`, `add_to_cart`
- **Whether server-side applies**: yes/no — determines if `SST -` prefix is needed
- **Market qualifier** (if applicable): e.g. NL, DE, BE

If any of the above are missing, ask before generating a name.

## Process

1. Identify the entity type (tag / trigger / variable).
2. Select the correct prefix from the prefix table below.
3. Build the name following the segment pattern:
   `[Prefix] - [Platform] - [Type/Subtype] - [Event/Description] - [Qualifier]`
   Drop segments that don't apply. Never add empty segments.
4. Use snake_case for event names and descriptions (`add_to_cart`, not
   `AddToCart` or `add to cart`).
5. If the entity has a server-side counterpart, prefix the SST version with
   `SST -` followed by the identical remainder of the name.
6. If a market qualifier is needed (NL / DE / BE), append it as the last
   segment.
7. Output the name(s) and a one-line rationale.

## Prefix reference table

### Tags

| Prefix | Use for |
|---|---|
| `GA4 -` | GA4 event and config tags (client-side) |
| `SST - GA4 -` | GA4 tags routed through server-side GTM |
| `Meta -` | Meta Pixel tags (browser-side) |
| `Google Ads -` | Google Ads conversion and remarketing tags |
| `DV360 -` | Display & Video 360 / Floodlight tags |
| `TikTok -` | TikTok Pixel event tags |
| `LinkedIn -` | LinkedIn Insight Tag and event tags |
| `Bing -` | Microsoft Advertising / UET tags |
| `Snapchat -` | Snapchat Pixel tags |
| `Reddit -` | Reddit Pixel tags |
| `Criteo -` | Criteo tags |
| `Consent Mode -` | Google Consent Mode default and update tags |
| `CHTML -` | Custom HTML tags |
| `Kameleoon -` | Kameleoon A/B testing integration tags |
| `Tealium -` | Tealium integration tags |
| `SST -` | Any non-GA4 tag routed server-side |
| `DEPRECATED -` | Paused legacy tags kept for reference — prepend to existing name |

### Triggers

| Prefix | Use for |
|---|---|
| `CE -` | Custom Event triggers |
| `PV -` | Page View triggers (with conditions) |
| `PVWL -` | Page View – Window Loaded triggers |
| `PVDOM -` | Page View – DOM Ready triggers |
| `CAE -` | Click – All Elements triggers |
| `CJL -` | Click – Just Links triggers |
| `EV -` | Element Visibility triggers |
| `TG -` | Trigger Groups |
| `Block -` | Blocking triggers (exception triggers) |
| `QA -` | QA/test-only triggers (timers, debug helpers) |

### Variables

| Prefix | Use for |
|---|---|
| `DLV -` | Data Layer Variables |
| `CJS -` | Custom JavaScript variables |
| `FPC -` | First-Party Cookie variables |
| `LUT -` | Lookup Table variables |
| `RX -` | Regex Table variables |
| `CS -` | Constant variables |
| `URL -` | URL-type variables |
| `GTES -` | GA4 Event Settings variables |
| `GTCS -` | GA4 Config Settings variables |
| `UPD -` | User-Provided Data variables |

## Output format

For a **single entity**, output:

```
[Entity type]: [Generated name]
Rationale: [One sentence explaining prefix and segment choices]
```

For a **client + SST pair**, output both names together:

```
Client-side tag:  GA4 - Event - purchase
Server-side tag:  SST - GA4 - Event - purchase
```

For a **naming audit**, output a table:

| Current name | Issue | Suggested name |
|---|---|---|
| `buy button click` | Missing prefix, not snake_case | `CE - buy_button_click` |

## Rules & constraints

- Always use Title Case for platform names (`Meta`, `Google Ads`, `TikTok`)
  but snake_case for event names and descriptions
- Never abbreviate platform names (`GA4` is acceptable; `fb` for Meta is not)
- SST tags must mirror client-side names exactly after the `SST -` prefix —
  never rename the underlying event segment
- `CHTML -` is for custom HTML tags only; never apply it to native tag types
- `DEPRECATED -` is always prepended to the existing name as-is — do not
  rewrite the rest of the name
- Market qualifiers (NL, DE, BE) go at the end, not in the middle
- Consent Mode tags must include the market: `Consent Mode - Default - NL`,
  `Consent Mode - Update - DE`
- `CJS -` and `cJS -` are the same convention — normalise to `CJS -`
- Trigger groups always use `TG -` prefix, not `CE -`
- `Block -` is reserved for exception/blocking triggers only

## Examples

### Tags

```
Platform: GA4 | Type: Event | Event: view_item | Server-side: no
→ GA4 - Event - view_item

Platform: GA4 | Type: Event | Event: purchase | Server-side: yes
→ Client-side:  GA4 - Event - purchase
→ Server-side:  SST - GA4 - Event - purchase

Platform: Meta | Type: standard event | Event: Purchase | Server-side: no
→ Meta - Event - Purchase

Platform: Consent Mode | Type: Default | Market: NL
→ Consent Mode - Default - NL

Platform: Google Ads | Type: Conversion | Event: purchase
→ Google Ads - Conversion - purchase

Custom HTML tag for session tracking:
→ CHTML - Session start
```

### Triggers

```
Custom event for add_to_cart:
→ CE - add_to_cart

Custom event with consent qualifier:
→ CE - add_to_cart - marketing consent

Page view with URL condition:
→ PV - Page path contains /checkout

Trigger group combining pageview + consent:
→ TG - pageview after consent - NL

Blocking trigger for DE market:
→ Block - Country contains DE
```

### Variables

```
dataLayer key ecommerce.transaction_id:
→ DLV - ecommerce.transaction_id

Lookup table for GA4 Measurement ID:
→ LUT - GA4 Measurement ID

Custom JS that formats a price:
→ CJS - Converts price to correct format

First-party cookie for consent:
→ FPC - CookieConsent

Constant for server-side URL:
→ CS - SSTServerURL
```

### What to avoid

```
❌ facebook_purchase_tag         → no prefix, unclear type
❌ CE - AddToCart                → PascalCase instead of snake_case
❌ SST - purchase                → missing platform segment
❌ GA4 Event purchase NL        → missing hyphens between segments
❌ DLV - ecommerce - value      → dot notation preferred for nested keys
   (correct: DLV - ecommerce.value)
❌ cJS - formatPrice            → non-standard casing (use CJS -)
```
