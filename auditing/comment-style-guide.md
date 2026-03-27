# Comment Style Guide

## Principles
- Write in clear, professional English. Not academic, not casual.
- Be direct. State the finding first, then the cause, then the recommendation.
- Never use bullet points inside a comment cell. Comments are prose only.
- Avoid repeating the question in the comment. The reader knows the question.
- Always end numerical comments with the raw data footnote.
- Calibrate length to severity: immediate attention comments are longer; meets requirements can be brief.

---

## Comment structure — numerical questions (Sections 1 and 2)

### Template
```
[Finding sentence stating the gap and rating trigger.]
[Causal hypothesis — what likely explains the gap.]
[Closing recommendation — what should be investigated or fixed.]

This comparison used data from [date range].

[Metric label]:
[Platform A]: [value]
[Platform B]: [value]
```

### Annotated example — GA4 vs Backend (Requires immediate attention)
```
The percentual difference between the number of conversions registered in the
backend (2,554) and those captured in GA4 (1,912) stands at 25.1% over fiscal
year 2025, which exceeds the 10% threshold and requires immediate attention.
A gap of this magnitude is consistent with structural tracking issues: parallel
implementations operating independently from GTM, consent tags not gating all
firing conditions, and a post-consent revisit timing issue allowing tags to fire
before consent state is restored.

This comparison used data from 01/01/2025 – 31/12/2025.

Number of conversions:
Backend: 2,554
GA4: 1,912
```

### Annotated example — GA4 vs Backend (Requires improvement)
```
The percentual difference between the turnover value registered in the backend
(€874,387.12) and the value captured in GA4 (€817,003.98) stands at 6.56%,
falling in the 5–10% range and requiring improvement. The value gap being
considerably smaller than the conversion count gap suggests that missing
conversions are concentrated in lower-value transactions, while higher-value
orders are more consistently tracked. Contributing factors likely include
string-typed value parameters and backend adjustments for cancellations not
reflected in GA4.

This comparison used data from 01/01/2025 – 31/12/2025.

Revenue totals:
Backend: €874,387.12
GA4: €817,003.98
```

### Annotated example — GA4 vs Google Ads (Requires immediate attention)
```
The percentual difference between GA4 and Google Ads conversions is 42.0%,
well above the 20% threshold, requiring immediate attention. Attribution model
and lookback window differences between GA4 (data-driven, session-based) and
Google Ads (last-click, cross-channel) naturally produce divergence, but a gap
of this magnitude also points to implementation gaps — specifically missing gclid
passthrough reliability and consent state timing issues.

This comparison used data for [period].

N. of conversions:
GA4: [value]
Google Ads: [value]
```

---

## Comment structure — qualitative questions (Sections 3, 4, 5)

### Template
```
[State what was found — factual, specific.]
[State why it matters or what it causes.]
[State what is needed to fix or improve it — optional for Meets requirements.]
```

### Example — Tag Manager (Requires immediate attention)
```
All GTM tags carry consentStatus: NOT_SET, meaning no tag is consent-gated
and all fire regardless of user consent state. Marketing tags are especially
concerning. GTM Consent Overview is not enabled. Consent Mode defaults are
declared via hardcoded HTML in the Magento AEC extension rather than managed
through GTM, meaning any change requires a Magento deployment rather than a
GTM publish.
```

### Example — Data Layer (Requires improvement)
```
The begin_checkout event fires and reaches GA4 with item-level data intact.
However, the GTM tag maps items only — value and currency are present in the
dataLayer but never forwarded to GA4. This means the event is visible in the
funnel but carries no monetary value, making value-based funnel analysis
impossible. The coupon parameter is also absent from the push entirely.
```

### Example — Meets requirements (brief)
```
The dataLayer push and the GTM container are injected within the <head>
element, consistent with Google's recommended placement.
```

---

## Section summary structure

Summaries appear at the top of each sheet. They synthesise all question findings into a single paragraph.

### Template
```
[Opening: overall verdict for the section in one sentence.]
[What works — briefly.]
[What doesn't work — the main issues, in order of severity.]
[Closing: overall direction for remediation.]
```

### Length norms
- Meets requirements overall: 3–4 sentences
- Mixed results: 5–7 sentences
- Requires immediate attention overall: 7–10 sentences

### Example — Tag Manager (mixed)
```
The GTM implementation is built on a single container correctly placed in the
<head> of the page, with the Data Processing Amendment in place since 2019 —
the foundational setup is therefore sound. At the interface level, the container
shows signs of accumulated technical debt: at 162 kb it exceeds the recommended
size threshold, driven by 35 tags, 6 of which are paused with edits ranging from
five months to a year ago, and the majority of GA4 tags date from three years ago.
Consent is where the most critical issues are concentrated: no GTM tag is
consent-gated, all carry consentStatus: NOT_SET, and Consent Mode defaults are
hardcoded in the Magento extension rather than managed through GTM. On return
visits, the consent update event fires too late for tags to inherit the previously
granted state, meaning marketing tags fire in a denied context.
```

---

## Overall audit summary structure (Management summary sheet)

### Template
```
[Overall health statement in one sentence.]
[Data alignment summary — backend vs GA4 and ads comparisons, with percentages.]
[Tag Manager and dataLayer state — key structural issues.]
[Consent state — critical if relevant.]
[Closing — what needs to happen first, in what order.]
```

---

## Tone rules
- Never use: "it is important to note", "it should be noted", "as mentioned above"
- Never start a comment with "The audit results indicate" more than once per section
- Prefer active constructions: "GA4 receives items only" not "items are the only parameter received by GA4"
- When a finding has a known root cause, name it specifically. Avoid vague language like "potential issues"
- When a finding cannot be explained without more investigation, say so explicitly
