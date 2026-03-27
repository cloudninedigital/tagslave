# Summary Templates

## How to use these templates
Fill in the bracketed placeholders using findings from the completed section questions. Do not reproduce the template structure literally — use it as a scaffold and write naturally. The output should read as continuous prose, not a filled-in form.

---

## Section 1 — GA4 vs Backend summary

```
The purchase comparison results indicate [overall verdict: stable/mixed/critical] performance
in data alignment. [Lead with the stronger finding.] The site [shows/does not show] acceptable
alignment in [count/revenue], with a [X]% discrepancy [within/exceeding] the [5/10]% threshold.
[If gaps differ significantly: note the divergence and what it implies about where conversions are lost.]
Key contributing factors include [name 2–3 specific causes from this client's audit].
[Closing: what the overall data reliability implication is and what remediation is needed first.]
```

### Example — mixed result
```
The purchase comparison results indicate a performance that requires both improvement and
immediate attention across the data alignment categories. While the site demonstrates relative
stability in revenue tracking — maintaining a 6.56% discrepancy in conversion value that falls
within the improvable range — the conversion volume gap of 25.1% significantly exceeds industry
standards and requires immediate action. This divergence suggests that missing conversions are
concentrated in lower-value transactions, while higher-value orders are more consistently captured.
Key contributing factors include the parallel Magento AEC implementation operating independently
from GTM, consent tags that do not gate all firing conditions, and a post-consent revisit timing
issue. Until the structural tracking architecture is remediated, the dataset cannot be considered
analytically reliable.
```

---

## Section 2 — GA4 vs Marketing Platforms summary

```
The [platform] comparison results indicate [critical/mixed/stable] misalignment across
[conversion volume/revenue value/both]. [State the gap percentages and thresholds triggered.]
[Explain whether gaps are similar or divergent across count vs value, and what that implies.]
[Name the structural causes — distinguish between expected attribution divergence and
implementation issues.] [Closing: what cannot be resolved by attribution reconciliation alone
and what technical remediation must come first.]
```

### Example — both metrics critical
```
The GA4 versus Google Ads comparison results indicate a critical misalignment across both
conversion volume and revenue value, requiring immediate attention on all measured dimensions.
The site records a 42.0% discrepancy in conversion count and a 39.7% gap in conversion value —
both substantially exceeding the 20% threshold. The near-identical percentage differences across
both metrics suggest attribution and lookback window divergence is the dominant structural driver
rather than a concentration of missing lower-value transactions. This effect is compounded by
the implementation issues identified throughout this audit. Gaps of this magnitude undermine
ROAS calculations and cannot be resolved through attribution reconciliation alone.
```

---

## Section 3 — Standardization & Compliancy summary

```
[Open with overall compliance posture — one sentence.]
[UTM and channel grouping state: what is working, what is fragmented.]
[Documentation state: SDR exists or not, reporting suite state.]
[Cookie and consent compliance: is the banner compliant? Is there a legal risk?]
[Closing: overall data integrity and legal framework assessment.]
```

---

## Section 4 — Tag Manager summary

```
[Open with foundational setup state: container count, placement, DPA.]
[GTM interface state: container size, tag count, age, paused tags, cHTML count.]
[Happy flow state: errors present or clean, page view behavior.]
[Consent state — this is usually the most critical subsection: pre/post consent, gating, hardcoded vs GTM.]
[Closing: overall direction — what is structurally sound vs what requires immediate intervention.]
```

### Template for consent-critical result
```
[Foundation sentence.] At the interface level, [tag/trigger/variable hygiene finding].
Consent is where the most critical issues are concentrated: [specific consent failures].
[If post-consent return visit is broken: state the exact failure.] [If all tags are NOT_SET:
state the implication.] [If hardcoded: state what that means for change management.]
```

---

## Section 5 — Data Layer summary

```
[Open with architectural finding if parallel implementation exists — this is the most important
structural context for everything else.]
[dataLayer push quality: what format is used, what legacy fields are present, what is systematically missing.]
[GTM tag configuration: is the items-only mapping gap present? How many events are affected?]
[Purchase event state: is the main conversion monetarily reliable?]
[Consent interaction: how does the dataLayer relate to the consent architecture?]
[Closing: what layer needs to change first — Magento/backend, GTM tags, or both.]
```

---

## Section 6 — GA4 Configuration summary

```
[Open with overall health statement from GA4 Monitor results: X checks assessed, Y failures, Z warnings.]
[Name the clean sections — where things work well.]
[Name the failing sections in order of severity: PII first, revenue/ecommerce second, attribution third.]
[Any specific anomalies: duplicate streams, revenue outliers, duplicate transaction IDs.]
[Closing: is the GA4 property structurally sound for high-level analysis, or are there fundamental issues?]
```

---

## Overall audit summary — Management summary sheet

This is written after all sections are complete. It synthesises the entire audit into a single paragraph for the Management Summary sheet.

```
[One sentence: overall data collection health verdict for this client.]
[Data alignment: state the backend-GA4 gaps and the ads platform gaps with percentages.]
[Architecture: name the most significant structural issue (e.g. parallel implementation, consent gap).]
[Ecommerce tracking: are the key events functional? Is purchase reliable?]
[Legal/compliance: is there a consent risk?]
[Closing: what must happen first, in what order, before the data can be trusted.]
```

### Example — complex client with multiple critical issues
```
The data collection audit reveals a tracking infrastructure that is partially functional
but structurally unsound, with critical gaps in consent enforcement, ecommerce parameter
completeness, and platform data alignment. GA4 captures 74.9% of backend conversions
(25.1% volume gap) and 93.4% of revenue — the volume gap significantly exceeds acceptable
thresholds while revenue alignment is improvable. Against Google Ads, both count (42.0%) and
value (39.7%) gaps require immediate attention. The root cause connects across sections:
a parallel Magento AEC implementation operates independently from GTM, consent tags are
not gated on any tag in the container, and GTM ecommerce tags forward only item data
with no monetary parameters. The purchase event itself is monetarily reliable in the GTM
property, but the secondary property (G-CNCT6DBHPM) uses string-typed values, making its
revenue data untrustworthy. Remediation must begin at the Magento extension level before
GTM-only fixes can be effective.
```
