# Rating Thresholds

All numerical thresholds are fixed. Apply them exactly as specified below. Do not interpret or adjust based on context unless explicitly instructed.

## Rating scale

| Rating | When to use |
|---|---|
| `Meets requirements` | Result is within acceptable range, no action needed |
| `Requires improvement` | Result is outside acceptable range but not critical |
| `Requires immediate attention` | Result exceeds critical threshold or feature is broken/absent |
| `To be audited` | Data was not provided or cannot be assessed without additional input |

---

## Section 1 — GA4 vs Backend

### Q1.1 — Number of conversions (annual / fiscal year)
| Gap | Rating |
|---|---|
| < 5% | Meets requirements |
| 5% – 10% | Requires improvement |
| > 10% | Requires immediate attention |

### Q1.2 — Revenue value (annual / fiscal year)
| Gap | Rating |
|---|---|
| < 5% | Meets requirements |
| 5% – 10% | Requires improvement |
| > 10% | Requires immediate attention |

**Gap formula:** `ABS(backend - GA4) / backend * 100`
Always use backend as the denominator. Always state the direction (GA4 under-reports vs over-reports).

---

## Section 2 — GA4 vs Marketing Platforms

### Q2.1 / Q2.3 — Number of conversions (monthly comparison)
| Gap | Rating |
|---|---|
| < 10% | Meets requirements |
| 10% – 20% | Requires improvement |
| > 20% | Requires immediate attention |

### Q2.2 / Q2.4 — Conversion value (monthly comparison)
Same thresholds as above.

**Important:** If Google Ads has two conversion actions (native + GA4-imported), calculate and report both gaps separately. Rate on the worse of the two.

**Gap formula:** `ABS(GA4 - platform) / GA4 * 100`
Use GA4 as the denominator for marketing platform comparisons.

---

## Section 3 — Standardization & Compliancy

### Q3.1 — Measurement documentation (SDR)
| State | Rating |
|---|---|
| SDR exists and was shared | Meets requirements |
| SDR exists but not shared / incomplete | Requires improvement |
| No SDR exists | Requires immediate attention |

### Q3.2 — Channel grouping
| State | Rating |
|---|---|
| All traffic correctly attributed, < 2% unassigned | Meets requirements |
| Minor issues (missing source platform, 2–10% unassigned) | Requires improvement |
| Significant unassigned / misattributed traffic (> 10%) | Requires immediate attention |

### Q3.3 — Reporting suite
| State | Rating |
|---|---|
| Documented report suite in use | Meets requirements |
| Reports exist but undocumented or incomplete | Requires improvement |
| No reports beyond GA4 defaults | Requires improvement |

### Q3.4 — UTM standardization
| State | Rating |
|---|---|
| Consistent naming, < 20 source variations | Meets requirements |
| Some inconsistencies, 20–100 source variations | Requires improvement |
| High fragmentation, > 100 source variations or no convention | Requires immediate attention |

### Q3.5 — Cookie banner and privacy compliance
| State | Rating |
|---|---|
| Banner loads before any tracking, privacy statement linked | Meets requirements |
| Banner present but minor issues | Requires improvement |
| Banner delayed / fires after tracking, or absent | Requires immediate attention |

---

## Section 4 — Tag Manager

### Q1.1 — Multiple containers
| State | Rating |
|---|---|
| Single container across all pages | Meets requirements |
| Multiple containers with documented reason | Requires improvement |
| Multiple containers, undocumented / conflicting | Requires immediate attention |

### Q1.2 — Container size
| Size | Rating |
|---|---|
| 90–140 kb | Meets requirements |
| 140–200 kb | Requires improvement |
| > 200 kb or < 90 kb | Requires immediate attention |

### Q2.1 — GTM snippet placement
| State | Rating |
|---|---|
| In `<head>` on all pages | Meets requirements |
| In `<head>` on most pages, `<body>` on some | Requires improvement |
| In `<body>` or missing on significant pages | Requires immediate attention |

### Q3.1 — Data Processing Amendment
| State | Rating |
|---|---|
| Accepted | Meets requirements |
| Not confirmed | To be audited |

### Q4.1 — Tag count
| Count | Rating |
|---|---|
| ≤ 25 | Meets requirements |
| 26–40 | Requires improvement |
| > 40 | Requires immediate attention |

### Q4.2 — Custom HTML tags
| State | Rating |
|---|---|
| 0–1 cHTML tags | Meets requirements |
| 2–5 cHTML tags | To be audited |
| > 5 cHTML tags | To be audited + flag for security review |

### Q4.3 — Paused tags
| State | Rating |
|---|---|
| No paused tags | Meets requirements |
| 1–3 paused tags, recently edited | Requires improvement |
| > 3 paused tags or edited > 6 months ago | Requires improvement |

### Q4.4 — Tag age
| State | Rating |
|---|---|
| Most tags edited within 2 years | Meets requirements |
| Majority edited 2–3 years ago | Requires improvement |
| Majority edited > 3 years ago | Requires improvement |

### Q4.5 — Unlinked triggers
| State | Rating |
|---|---|
| No unlinked triggers | Meets requirements |
| 1–3 unlinked triggers | Requires improvement |
| > 3 unlinked triggers | Requires improvement |

### Q4.6 — Unlinked variables
| State | Rating |
|---|---|
| No unlinked variables | Meets requirements |
| Any unlinked variables | Requires improvement |

### Q4.7 — Tags without triggers
| State | Rating |
|---|---|
| All tags have triggers | Meets requirements |
| Any tag without trigger | Requires immediate attention |

### Q4.8 — Server-side tagging
| State | Rating |
|---|---|
| Not in use (note this) | Meets requirements |
| In use and correctly configured | Meets requirements |
| In use but misconfigured | Requires immediate attention |

### Q5.1 — Console errors during happy flow
| State | Rating |
|---|---|
| No errors | Meets requirements |
| Minor/occasional errors | Requires improvement |
| Plentiful or recurring errors | Requires immediate attention |

### Q5.2 — Duplicate page views
| State | Rating |
|---|---|
| One page_view per page | Meets requirements |
| Duplicate page views detected | Requires immediate attention |

### Q6.1–Q6.4 — Pre-consent and consenting flow
Rate each independently. Meets requirements if the expected event sequence fires correctly.

### Q6.5–Q6.6 — Post-consent (return visit)
| State | Rating |
|---|---|
| Consent correctly restored before any tag fires | Meets requirements |
| Consent update fires but too late | Requires immediate attention |
| No consent update on return visit | Requires immediate attention |

### Q6.7 — Consent Mode via GTM
| State | Rating |
|---|---|
| All tags consent-gated, GTM Consent Overview enabled | Meets requirements |
| Partial consent gating | Requires improvement |
| No tags consent-gated (all NOT_SET) | Requires immediate attention |

### Q6.8 — Consent Mode hardcoded
| State | Rating |
|---|---|
| Not hardcoded, managed via GTM | Meets requirements |
| Hardcoded but aligned with GTM | Requires improvement |
| Hardcoded and not aligned / outside GTM control | Requires immediate attention |

---

## Section 5 — Data Layer

### Per-event rating logic
For each ecommerce event:

| State | Rating |
|---|---|
| All required parameters present, correct types, GA4 spec compliant | Meets requirements |
| Required parameters present but missing recommended params or minor issues | Requires improvement |
| Required parameters missing, wrong types, or event functionally broken | Requires immediate attention |
| Event not implemented | Requires immediate attention |

### GTM tag mapping check
If GTM tag maps fewer parameters than exist in the dataLayer (e.g. items only, no value/currency): `Requires improvement` minimum, `Requires immediate attention` if monetary parameters are missing on conversion events.

---

## Section 6 — GA4 Configuration

### GA4 Monitor CSV — pivot logic
- Rows: section + check_name
- Columns: result values (pass, fail, warning, etc.)
- Values: count of each result per check

Rate sections based on failure concentration:
| Failures in section | Rating |
|---|---|
| 0 failures | Meets requirements |
| 1–2 failures or warnings only | Requires improvement |
| 3+ failures | Requires immediate attention |
