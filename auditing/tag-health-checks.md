# Tag Health Checks — GTM Audit

## Overview
This file covers the GTM interface quality questions (Section 4, Q4.x) and the structural account checks (Q1.x, Q2.x, Q3.x). All data comes from the GTM connector unless noted.

---

## Container metadata checks

### Container size (Q1.2)
The GTM connector may return container size directly. If not, estimate from composition:

| Signal | Likely size range |
|---|---|
| < 20 tags, < 30 variables, no cHTML | < 100 kb — likely within range |
| 20–35 tags, moderate variables | 100–160 kb — borderline |
| > 35 tags, multiple cHTML, large custom templates | > 160 kb — likely oversized |

Size contributors in descending order of impact:
1. Custom HTML tag content (inline JavaScript is expensive)
2. Custom JavaScript variables
3. Custom templates
4. Large numbers of redundant tags

When size exceeds threshold, note the most likely contributors based on what the connector returns.

---

## Tag audit checks

### Tag inventory (Q4.1)
Pull full tag list. For each tag record:
- `name` — display name
- `type` — tag type code
- `fingerprint` — last modified timestamp (Unix ms)
- `paused` — boolean
- `firingTriggerId` — list of trigger IDs

**Tag type reference — common types:**
| Type code | Tag type |
|---|---|
| `gaawe` | GA4 Event |
| `googtag` | Google Tag (GA4 Config or Google Ads) |
| `awct` | Google Ads Conversion Tracking |
| `gclidw` | Conversion Linker |
| `sp` | Google Ads Remarketing |
| `html` | Custom HTML |
| `v` | (this is a variable type, not a tag) |
| `baut` | Microsoft Ads / UET |
| `cvt_*` | Custom template (vendor-specific) |

### Custom HTML tags (Q4.2)
Filter: `type = "html"`
For each cHTML tag found:
- Note the tag name
- Flag that each requires individual security review:
  - Does it load external scripts? (src= in the HTML)
  - Does it access document.cookie?
  - Does it make network requests to unknown endpoints?
  - Is it duplicating functionality available via a native GTM template?
- Comment should list all cHTML tag names and recommend review

### Paused tags (Q4.3)
Filter: `paused = true`
For each paused tag:
- Calculate time since last edit: `(current_date - fingerprint_date).days`
- Classify: < 90 days = recently paused (may be intentional), 90–180 days = stale, > 180 days = should be removed or published
- Comment should list paused tag names and their ages

### Tag age (Q4.4)
For all tags:
- Convert fingerprint to date
- Calculate age in days
- Flag any tag > 730 days (2 years) as potentially outdated
- Calculate: count and percentage of tags over 2 years old
- Context: tags from the UA era (pre-2023) may contain UA-specific configuration that is now irrelevant or incorrect in GA4 context

**Age calculation:**
```
tag_date = datetime.fromtimestamp(fingerprint / 1000)
age_days = (today - tag_date).days
age_years = age_days / 365
```

---

## Trigger audit checks

### Unlinked triggers (Q4.5)
```
all_trigger_ids = set of all trigger IDs in container
used_trigger_ids = union of all firingTriggerId arrays across all tags
                   + all exception trigger IDs
unlinked_triggers = all_trigger_ids - used_trigger_ids
```

For each unlinked trigger: note name and type.
Common unlinked trigger causes:
- Tag was deleted but trigger was not cleaned up
- Trigger built speculatively and never used
- Trigger previously linked to a now-paused or deleted tag

### Tags without triggers (Q4.7)
Filter: tags where `firingTriggerId` is empty or null.
This should not happen for active tags — every firing tag needs at least one trigger.
Exception: tags used only as tag sequencing dependencies (fired by another tag) may have no direct trigger — verify by checking if the tag appears in any other tag's `setup_tag` or `teardown_tag` references.

---

## Variable audit checks

### Unlinked variables (Q4.6)
```
all_variable_names = set of all user-defined variable display names
referenced_names = all {{VarName}} references found in:
  - tag parameter values
  - trigger filter values
  - other variable parameter values
  - built-in variable configurations
unlinked_variables = all_variable_names - referenced_names
```

Note: built-in variables (Page URL, Event, etc.) do not appear in the variable list — only user-defined variables.

**Common causes of unlinked variables:**
- Variable created for a tag that was later deleted
- Variable name changed, old name left behind
- Variable built for a use case that was never implemented
- Copy-paste duplication

---

## Server-side tagging check (Q4.8)

### Detection signals
From web_fetch (Tier 1):
- Look for sGTM container URL pattern: `https://[subdomain].[domain].com` where the subdomain serves GTM container JS
- Stape-hosted containers: typically `*.stape.io` or custom domain
- Look for Measurement Protocol hits in network requests

From GTM connector:
- Server-side GA4 tags have different type codes than client-side
- Check if a GA4 config tag points to a server URL instead of `www.google-analytics.com`

### What to note
If server-side is NOT in use: note this as a factual observation, not a finding. Rate Meets requirements unless the audit specifically identifies server-side as a requirement.

If server-side IS in use:
- Confirm the sGTM container URL is correctly referenced in client-side GTM
- Check if client-side GA4 Config tag transport_url points to sGTM
- Note if both client-side and server-side tags exist for the same event (duplication risk)

---

## Combining findings into Q4 comment structure

When writing the GTM Interface section summary:
1. Open with overall container health (size, age context)
2. Note governance issues (paused tags, unlinked elements)
3. Flag cHTML tags as requiring review without making assumptions about their content
4. Connect tag age finding to the UA-era migration context if relevant
5. Do not list every individual tag — summarise patterns

Example structure:
```
The container contains [N] tags, exceeding the 25-tag threshold. [N] tags are paused,
with edits ranging from [X] to [Y] ago — these inflate container size without serving
active measurement. The majority of GA4 tags were last edited [Z] years ago, consistent
with a UA-era configuration that has not been fully updated. [N] custom HTML tags are
present and require individual security review. Trigger and variable hygiene is
[acceptable / needs attention]: [specific unlinked count and type].
```
