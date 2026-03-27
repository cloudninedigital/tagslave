---
name: gtm-audit-checklist
description: Step-by-step checklist for auditing GTM tags before creation or
  modification. Use this skill whenever the user asks to create a new tag,
  modify an existing tag, or audit a GTM container. Run every check in order
  before producing or confirming any tag configuration. If any check fails,
  surface the issue to the user before proceeding.
---

# GTM Tag Audit Checklist

Runs a structured pre-creation and pre-publish audit on GTM tags to catch
naming errors, configuration gaps, and container hygiene issues before they
reach production.

## When to use this skill

- A new tag is about to be created
- An existing tag is being renamed or reconfigured
- A GTM container export is uploaded for review
- The user asks to "audit tags", "check the container", or "review before publishing"
- Any tag is being moved from a workspace to production

---

## Check 1 — Pre-creation: duplicate or similar tag detection

Before creating anything, scan existing tags for conflicts.

**Ask:**
- Does a tag with an identical name already exist?
- Does a tag exist with a near-identical name (same platform + event, slight
  spelling variation or different casing)?
- Does a tag already fire the same event for the same platform, even under a
  different name?

**Action if yes:**
- Surface the existing tag name(s) to the user.
- Ask whether the intent is to replace, duplicate, or deprecate the existing tag.
- Do not create the new tag until this is resolved.

**Pass condition:** No tag with the same or equivalent purpose exists, or the
user has explicitly confirmed that duplication is intentional.

---

## Check 2 — Naming convention validation

Validate the proposed tag name against the conventions in `naming-conventions.md`.

**Ask:**
- Does the name start with a recognised prefix from the prefix table?
- Are platform names in Title Case (`Meta`, `Google Ads`) and event/description
  segments in snake_case (`add_to_cart`, not `AddToCart`)?
- Are segments separated by ` - ` (space-hyphen-space)?
- Are there any empty segments or trailing hyphens?
- If a market qualifier is present, is it the last segment?
- For SST tags: does the name start with `SST -` and mirror the client-side
  name exactly after that prefix?
- For Consent Mode tags: does the name include the market qualifier
  (`Consent Mode - Default - NL`)?

**Action if no:**
- Generate the corrected name following the segment pattern:
  `[Prefix] - [Platform] - [Type/Subtype] - [Event/Description] - [Qualifier]`
- Present the corrected name with a one-line rationale before proceeding.

**Pass condition:** Name fully conforms to the naming convention.

---

## Check 3 — Trigger assignment

Every tag must have at least one firing trigger. Blocking triggers are
optional but must be validated if present.

**Ask:**
- Is at least one firing trigger attached to the tag?
- Does the trigger type match the tag's intended firing context?
  (e.g. a purchase event tag should use `CE - purchase`, not a generic
  `PV -` page view trigger)
- If a blocking trigger is attached, does it use the `Block -` prefix and
  is its condition correct?
- If a Trigger Group is used, does it carry the `TG -` prefix?
- Are all attached triggers active (not paused or deleted)?

**Action if no:**
- Flag the missing or mismatched trigger.
- Suggest the correct trigger type and name using the trigger prefix table.
- Do not mark the tag ready for publication until a valid trigger is confirmed.

**Pass condition:** At least one correctly typed and active firing trigger is
attached.

---

## Check 4 — Variable references

All variables referenced inside a tag must exist in the container and follow
naming conventions.

**Ask:**
- Does every variable referenced in the tag configuration exist in the
  container?
- Do all referenced variable names carry a recognised prefix (`DLV -`,
  `CJS -`, `LUT -`, etc.)?
- For GA4 tags: is a `GTES -` (Event Settings) or `GTCS -` (Config Settings)
  variable used where one exists, rather than hardcoded values?
- Are any referenced variables paused or scheduled for deletion?

**Action if no:**
- List each broken or non-conforming variable reference.
- Suggest the correct variable name or flag it for creation before the tag
  goes live.

**Pass condition:** All variable references resolve to active, correctly named
variables.

---

## Check 5 — Variable optimisation

Beyond checking that referenced variables exist, check whether available
variables in the container are being underused.

**Ask:**
- Are values hardcoded in the tag that could be pulled from an existing
  `DLV -` or `CJS -` variable?
- Is there a `LUT -` or `CS -` variable that could replace repeated
  hardcoded values (e.g. Measurement IDs, server-side URLs)?
- Is there a `GTES -` or `GTCS -` variable available that this GA4 tag
  should be using instead of standalone field configuration?
- Are there `UPD -` variables relevant to this tag that are not yet wired in?

**Action if yes:**
- Surface the unused variable(s) and explain how connecting them would
  standardise the configuration.
- Recommend the change; do not apply it without user confirmation.

**Pass condition:** No available variables exist that would meaningfully
improve standardisation or reduce hardcoding.

---

## Check 6 — SST pairing

If server-side tracking is in scope, client-side and server-side tags must
exist as a matched pair.

**Ask:**
- Does the tag have a server-side counterpart (or is one expected)?
- If yes: does the SST tag name start with `SST -` followed by the exact
  client-side name?
- Do both tags reference the same event name and parameter set?
- If only one side of the pair exists, is that intentional?

**Action if no:**
- Flag the missing or diverging counterpart.
- Generate the correct paired name and surface it to the user.

**Pass condition:** Both tags in the pair exist and their names are in sync,
or the user has confirmed that only one side is needed.

---

## Check 7 — Consent Mode coverage

Any container firing tags for markets with consent requirements must have the
correct Consent Mode tags in place.

**Ask:**
- Is there a `Consent Mode - Default - [Market]` tag present for every
  relevant market?
- Is there a `Consent Mode - Update - [Market]` tag present for every
  relevant market?
- Are both tags firing on the correct triggers (Default before any other tag;
  Update on consent interaction events)?
- If a new market is being added, are both tags being created as part of this
  work?

**Action if no:**
- List the missing Consent Mode tag(s) by name.
- Flag that the tag being created may fire without consent signalling in place.
- Do not block creation, but require explicit user acknowledgement of the gap.

**Pass condition:** Both Default and Update Consent Mode tags exist and are
correctly triggered for all in-scope markets.

---

## Check 8 — Deprecation check

Before creating a replacement tag, confirm that old versions are handled.

**Ask:**
- Does a previous version of this tag exist under a different or legacy name?
- If yes: is it paused?
- If yes: does its name start with `DEPRECATED -`?
- Is the deprecated tag being kept for reference, or should it be deleted?

**Action if no:**
- Rename the old tag by prepending `DEPRECATED -` to its existing name
  (do not rewrite the rest of the name).
- Pause it if it is still active.
- Confirm with the user whether it should be deleted entirely.

**Pass condition:** No un-deprecated legacy versions of this tag remain active
in the container.

---

## Check 9 — Folder and workspace hygiene

Tags must be organised consistently to keep the container navigable.

**Ask:**
- Is the tag assigned to the correct folder (e.g. by platform, market, or
  feature area)?
- Is the work being done in the correct workspace (not directly in Default)?
- Are naming conventions for the folder itself consistent with the rest of
  the container?

**Action if no:**
- Flag the folder assignment issue and suggest the correct folder.
- If no suitable folder exists, recommend creating one with a consistent name
  before publishing.

**Pass condition:** Tag is in the correct folder and the workspace is
appropriate for the change.

---

## Audit summary output format

After running all checks, output a summary table:

| # | Check | Status | Notes |
|---|---|---|---|
| 1 | Duplicate detection | ✅ Pass / ⚠️ Review / ❌ Fail | |
| 2 | Naming convention | ✅ Pass / ⚠️ Review / ❌ Fail | |
| 3 | Trigger assignment | ✅ Pass / ⚠️ Review / ❌ Fail | |
| 4 | Variable references | ✅ Pass / ⚠️ Review / ❌ Fail | |
| 5 | Variable optimisation | ✅ Pass / ⚠️ Review / ❌ Fail | |
| 6 | SST pairing | ✅ Pass / ⚠️ Review / ❌ Fail | |
| 7 | Consent Mode coverage | ✅ Pass / ⚠️ Review / ❌ Fail | |
| 8 | Deprecation | ✅ Pass / ⚠️ Review / ❌ Fail | |
| 9 | Folder / workspace | ✅ Pass / ⚠️ Review / ❌ Fail | |

- **✅ Pass** — no action needed
- **⚠️ Review** — a recommendation was made; user should confirm
- **❌ Fail** — a blocking issue; must be resolved before publishing

Do not proceed to tag creation or publication if any check has status ❌ Fail.
