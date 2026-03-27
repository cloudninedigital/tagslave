---
name: gtm-common-issues
description: Reference guide for diagnosing and fixing recurring GTM tag
  issues. Use this skill when an audit surfaces a problem, when the user
  reports unexpected tag behaviour, or when reviewing a GTM container export
  for quality. Cross-reference with audit-checklist.md for the full pre-publish
  workflow and naming-conventions.md for correct name formats.
---

# GTM Common Issues

Diagnoses and resolves the most frequent configuration, naming, and hygiene
problems found in GTM containers. Each issue includes how to detect it, why
it matters, and the fix to apply.

---

## Issue 1 — Naming violations

**What it looks like:**
- Tag, trigger, or variable name has no recognised prefix
- Platform name is abbreviated or lowercased (`fb` instead of `Meta`,
  `ga4` instead of `GA4`)
- Event or description segment is in PascalCase or plain text instead of
  snake_case (`AddToCart`, `add to cart`)
- Segments are separated by underscores or spaces only, not ` - `
- Market qualifier appears mid-name instead of at the end
- `cJS -` used instead of the standard `CJS -`

**Why it matters:**
Inconsistent names break searchability, make audits harder, and create
ambiguity about a tag's purpose and ownership.

**Fix:**
Apply the segment pattern from `naming-conventions.md`:
`[Prefix] - [Platform] - [Type/Subtype] - [Event/Description] - [Qualifier]`

Output the corrected name and rationale. If the tag is live, rename it in
the current workspace and note the change in the workspace description.

**Examples:**

| Violation | Corrected name |
|---|---|
| `facebook_purchase_tag` | `Meta - Event - Purchase` |
| `CE - AddToCart` | `CE - add_to_cart` |
| `GA4 Event purchase NL` | `GA4 - Event - purchase - NL` |
| `cJS - formatPrice` | `CJS - formatPrice` |
| `SST - purchase` | `SST - GA4 - Event - purchase` |

---

## Issue 2 — Duplicate or near-duplicate tags

**What it looks like:**
- Two or more tags share the same platform and event but differ by casing,
  spacing, or minor wording
- A tag was recreated without deprecating the old one
- The same conversion event is tracked by two tags that both fire in
  production

**Why it matters:**
Duplicate tags cause double-counting in analytics and ad platforms, inflating
conversion and event metrics.

**Fix:**
1. Identify which tag is the canonical version (usually the more recently
   created, correctly named one).
2. Pause and rename the redundant tag with the `DEPRECATED -` prefix.
3. Confirm with the user before deleting — deprecated tags are sometimes
   kept as a rollback reference.

---

## Issue 3 — Orphaned tags

**What it looks like:**
- A tag has no firing trigger attached
- A tag's trigger exists but is paused or has been deleted
- A Trigger Group (`TG -`) used as the sole trigger is empty

**Why it matters:**
Orphaned tags never fire, creating dead weight in the container and confusion
during audits about whether a platform is being tracked.

**Fix:**
1. Check whether the tag is intentionally inactive (e.g. awaiting a trigger
   to be built).
2. If intentional: add a `QA -` note or move it to a holding folder.
3. If unintentional: identify the correct trigger type from the prefix table,
   create or reattach the trigger, and verify firing in Preview mode.
4. If the tag is no longer needed: deprecate it rather than leaving it
   untriggered.

---

## Issue 4 — Broken variable references

**What it looks like:**
- A tag references a variable name that no longer exists in the container
- A variable was renamed but the reference inside the tag was not updated
- A variable carries a non-standard prefix or no prefix at all, making it
  hard to identify whether it is the correct one

**Why it matters:**
Broken variable references cause tags to fire with undefined or empty values,
silently corrupting data in analytics and ad platforms.

**Fix:**
1. List every variable reference inside the tag.
2. For each reference, verify the variable exists and is active.
3. If a variable was renamed, update the reference to match the new name.
4. If the variable does not exist, determine whether it needs to be created
   (using the correct prefix from `naming-conventions.md`) or whether an
   existing variable under a different name serves the same purpose.

---

## Issue 5 — Missing or underused variables

**What it looks like:**
- Values such as Measurement IDs, server-side endpoint URLs, or currency
  codes are hardcoded directly in a tag instead of pulled from a `CS -`
  constant or `LUT -` lookup table
- A dataLayer key is read directly inside a tag field instead of via a
  `DLV -` variable
- A `GTES -` (GA4 Event Settings) or `GTCS -` (GA4 Config Settings) variable
  exists in the container but the tag configures fields manually
- Multiple tags repeat the same logic that could live in a single `CJS -`
  variable

**Why it matters:**
Hardcoded values require individual tag edits for every update, increasing the
risk of inconsistency and human error. Shared variables centralise changes to
one place.

**Fix:**
1. Identify the hardcoded value and check whether a suitable variable already
   exists.
2. If a variable exists: replace the hardcoded value with the variable
   reference and note the change.
3. If no variable exists: recommend creating one with the correct prefix and
   a descriptive name (e.g. `CS - GA4 Measurement ID - NL`,
   `DLV - ecommerce.transaction_id`).
4. For GA4 tags without a `GTES -` variable wired in: flag this and recommend
   centralising shared event parameters into an Event Settings variable.

---

## Issue 6 — SST name mismatches

**What it looks like:**
- The server-side tag name does not start with `SST -`
- The segment after `SST -` does not exactly mirror the client-side tag name
- The client-side tag was renamed after the SST tag was created, leaving the
  pair out of sync
- Only one side of a paired tag exists without documented intent

**Why it matters:**
Name mismatches between client and server tags make it impossible to trace
data flow at a glance and increase the chance of misconfiguration when
updating one side of the pair.

**Fix:**
1. Identify the canonical client-side tag name.
2. Rename the SST tag to `SST - [exact client-side name]`.
3. If the client-side tag was recently renamed, check whether any other
   references (trigger conditions, variable values) also need updating.
4. If only one side of the pair exists, confirm with the user whether the
   other side needs to be created.

---

## Issue 7 — Consent Mode gaps

**What it looks like:**
- A market is being tracked but no `Consent Mode - Default - [Market]` tag
  exists
- The Update tag exists but the Default tag is missing (or vice versa)
- Consent Mode tags exist but fire on the wrong trigger (e.g. Default fires
  on a page view instead of Initialization)
- A new market was added to the container without adding the corresponding
  Consent Mode tags

**Why it matters:**
Missing or misfiring Consent Mode tags mean consent signals are not passed to
Google's ad and analytics products, creating legal and data quality risk.

**Fix:**
1. List all markets active in the container.
2. For each market, confirm that both `Consent Mode - Default - [Market]` and
   `Consent Mode - Update - [Market]` tags exist.
3. Verify that the Default tag fires on an Initialization trigger and the
   Update tag fires on the appropriate consent event trigger.
4. Create any missing tags and attach correct triggers before publishing.

---

## Issue 8 — CHTML prefix misuse

**What it looks like:**
- A native tag type (GA4, Meta Pixel, Google Ads) carries the `CHTML -`
  prefix
- A Custom HTML tag carries a platform-specific prefix (`GA4 -`, `Meta -`)
  instead of `CHTML -`
- A Custom HTML tag has no prefix at all

**Why it matters:**
The `CHTML -` prefix is reserved exclusively for Custom HTML tags. Applying
it to native tags, or omitting it from Custom HTML tags, makes it impossible
to filter by tag implementation type during an audit.

**Fix:**
- Native tag types: remove `CHTML -` and apply the correct platform prefix.
- Custom HTML tags with wrong prefix: replace with `CHTML -` followed by a
  descriptive name in snake_case.
- Custom HTML tags with no prefix: prepend `CHTML -`.

**Examples:**

| Violation | Corrected name |
|---|---|
| `CHTML - GA4 - Event - purchase` (native tag) | `GA4 - Event - purchase` |
| `Meta - Custom consent handler` (custom HTML) | `CHTML - meta_consent_handler` |
| `session tracking script` (custom HTML, no prefix) | `CHTML - session_tracking` |

---

## Issue 9 — Deprecated tags still active

**What it looks like:**
- An old tag is still live (not paused) and has not been renamed with
  `DEPRECATED -`
- A tag marked `DEPRECATED -` is still firing in production (not paused)
- Multiple versions of the same tag exist and it is unclear which is current

**Why it matters:**
Active deprecated tags cause double-firing, data duplication, and confusion
during incident investigation. Tags kept for reference must be paused to
prevent accidental firing.

**Fix:**
1. Identify the legacy tag.
2. Pause it immediately if it is still active.
3. Prepend `DEPRECATED -` to the existing name without altering the rest
   (e.g. `GA4 - Event - purchase` becomes `DEPRECATED - GA4 - Event - purchase`).
4. Confirm with the user whether the tag should be retained for reference or
   deleted outright.
5. Never rewrite the name beyond adding the prefix — the original name should
   remain readable for audit trail purposes.

---

## Quick-reference diagnosis table

Use this table to map a symptom to the relevant issue section above.

| Symptom | See issue |
|---|---|
| Tag name has no prefix | 1 — Naming violations |
| Two tags seem to track the same event | 2 — Duplicate tags |
| Tag exists but never fires | 3 — Orphaned tags |
| Tag fires with empty or undefined values | 4 — Broken variable references |
| Same Measurement ID hardcoded in multiple tags | 5 — Missing or underused variables |
| GA4 tag not using Event Settings variable | 5 — Missing or underused variables |
| SST tag name doesn't match client-side tag | 6 — SST mismatches |
| No Consent Mode tag for a market | 7 — Consent Mode gaps |
| Native tag has `CHTML -` prefix | 8 — CHTML misuse |
| Custom HTML tag has no prefix | 8 — CHTML misuse |
| Old tag still active, not labelled deprecated | 9 — Deprecated tags active |
