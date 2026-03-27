---
name: consent-mode-qa
description: Audit, validate, and debug Google Consent Mode (CoMo) implementations in GTM.
  Use this skill when the user asks about Consent Mode setup, consent default/update events,
  gcs/gcd parameters, cookie banner integration, CMP validation, pre/post-consent checks,
  consent timing issues, SPA consent handling, or QA before go-live. Trigger whenever
  the user mentions Consent Mode, cookiebot, consent banner, gcs parameter, or consent
  default/update.
---

# Google Consent Mode QA & Validation

Structured playbook for auditing, debugging, and validating Google Consent Mode (CoMo)
implementations via GTM and Google Tag Assistant.

---

## When to use this skill
- Setting up or reviewing Consent Mode (default + update) in GTM
- Debugging missing `gcs` / `gcd` parameters in GA4 or Google Ads hits
- Validating CMP (e.g. Cookiebot, OneTrust) integration with GTM
- QA before go-live on a new or updated consent setup
- Investigating misattribution caused by incorrect consent timing
- Reviewing consent behaviour on Single Page Applications (SPAs)

---

## What you need from the user
- The website URL to audit
- The CMP/cookie banner platform in use (e.g. Cookiebot, OneTrust, custom)
- Whether the site is a standard web page or SPA
- Access to GTM container (Preview link) if debugging tag firing
- Client's intended consent policy (e.g. analytics always granted, or denied by default)

If any of the above are missing, ask for them before proceeding.

---

## Core concepts

### Consent signals
| Parameter | Purpose |
|---|---|
| `analytics_storage` | Controls GA4 cookie/data collection |
| `ads_storage` | Controls Google Ads cookie/data collection |
| `gcs` | Google Consent State — present in hits when CoMo is active |
| `gcd` | Google Consent Default — reflects baseline consent state |

### Two key events (always check both)
- **Consent Default** — must fire on every page load, before any tags fire. Reflects
  the client's cookie policy baseline (usually `denied` for analytics + ads).
- **Consent Update** — fires after user interacts with the consent banner. Must carry
  the persisted consent values on every subsequent page load.

### Google's required flow (Sep 2024 best practice)
1. Set `Consent Default` immediately on page load
2. After user interaction with banner → fire `Consent Update` before any reload
3. On all subsequent pages → fire `Consent Default` + `Consent Update` (using
   persisted values from the CMP) before any GTM tags execute

---

## Process

### Step 1 — Tool setup
1. Install **Google Tag Assistant Companion** from Chrome Web Store
2. Enable the extension for Incognito windows
3. Open a new Incognito window (Ctrl+Shift+N) — ensures clean cookie state
4. Open Tag Assistant → `https://tagassistant.google.com/`
5. Add the client domain and start debugging
6. If inspecting GTM tags: paste the GTM Preview link into the debugged browser tab

---

### Step 2 — Pre-consent check (cookie banner shown, no interaction yet)

**Expected:**
- :white_check_mark: `Consent Default` event present
- :x: No `Consent Update` event yet

**Check:**
- Default values match the client's cookie policy (most clients: `analytics_storage:
  denied`, `ads_storage: denied`)
- If `Consent Default` is missing → CoMo is not implemented. Any hits sent at this
  point will lack the `gcs` parameter — flag as **Critical**
- Click on individual events to verify the `gcs` parameter is absent (correct) or
  present with the right value

---

### Step 3 — Consent interaction (user accepts banner)

**Expected:**
- :white_check_mark: `Consent Update` event fires after user submits consent choice
- :white_check_mark: `gcs` and `gcd` parameters present in subsequent hits with correct values

**Check:**
- Locate the `Consent Update` event in Tag Assistant's left-hand event list
- Click the event → Consent tab → verify parameter values match user's choice
- Verify that hits sent *before* the `Consent Update` still carry correct `gcs` values
  (what matters is the value at hit time, not event order alone)

**If the CMP forces a page reload after consent:**
- `Consent Update` must execute **before** the reload
- Verify the updated `gcs` values persist into the next page load

**If the CMP does not force a reload:**
- `Consent Update` must fire immediately after user interaction
- All subsequent GTM events must fire **after** the updated consent state is in place

---

### Step 4 — Post-consent check (navigating to next page)

**Expected:**
- :white_check_mark: `Consent Default` fires on every page load
- :white_check_mark: `Consent Update` fires on every page load (using persisted CMP values)
- :white_check_mark: `Consent Update` appears before any GA4 / Google Ads hits

**For SPAs specifically:**
- `Consent Update` required after both hard reloads and every virtual page load
- Verify consent state is maintained across route changes

---

### Step 5 — Attribution & hit validation

After consent is granted, verify:
- `gcs` and `gcd` parameters are present in GA4 and Google Ads hits
- Traffic attribution data (`source/medium`) is correctly passed through
- No hits are sent before the `Consent Update` event in the timeline

> Missing attribution is often caused by consent timing issues — tags firing before
> the `Consent Update` completes.

---

## Output format

For audits, structure findings using this severity model:

### :red_circle: Critical
Issues that cause data loss or compliance violations.
_Example: `Consent Default` missing entirely; hits sent without `gcs` parameter._

### :large_yellow_circle: Warning
Issues that may cause incorrect data or partial compliance.
_Example: `Consent Update` fires after the first GA4 hit on page load._

### :large_green_circle: Suggestion
Improvements to robustness or future-proofing.
_Example: Add `wait_for_update` to handle async CMP initialisation._

---

## Rules & constraints
- Always check `Consent Default` before `Consent Update` — order matters
- Default state must reflect the client's actual cookie policy — never assume `granted`
- For SPAs: consent state must be re-applied on every virtual page load, not just
  hard reloads
- QA must be performed by a **different consultant** than the implementer (4-eyes
  principle) — flag this in deliverables
- Never validate consent in a regular browser window — always use Incognito to
  simulate a clean state

---

## Common issues & fixes

| Issue | Likely cause | Fix |
|---|---|---|
| `gcs` missing from hits | `Consent Default` not set | Add CoMo default tag in GTM firing before all other tags |
| `Consent Update` fires too late | CMP initialises async | Add `wait_for_update: 500` to CoMo default config |
| Attribution missing post-consent | Tags fire before `Consent Update` | Adjust tag trigger priority or use consent-aware triggers |
| Update not persisting on page 2 | CMP not pushing update on reload | Ensure CMP re-fires update event using stored cookie values |
| SPA losing consent state on route change | Consent only set on hard load | Hook into SPA route change events to re-apply `Consent Update` |

---

## References
- See `platforms/ga4.md` for GA4-specific consent configuration
- See `platforms/google-ads.md` for Google Ads consent signal requirements
- See `conventions/naming-conventions.md` for GTM tag naming of consent-related tags
