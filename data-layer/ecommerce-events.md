---
name: datalayer-ga4-ecommerce
description: Generates complete GA4 ecommerce datalayer documentation in Markdown, following the client's field mapping + code format standard. Use this skill whenever someone asks to document a datalayer event, create a dataLayer spec, write a tracking plan for GA4 ecommerce events, or produce implementation docs for view_item_list, select_item, view_item, add_to_cart, remove_from_cart, view_cart, begin_checkout, add_shipping_info, add_payment_info, purchase, refund, view_promotion, or select_promotion. Also trigger when someone says "maak een datalayer doc", "schrijf de spec voor event X", or "voeg event toe aan de tracking documentatie".
---

# Datalayer Documentation — GA4 Ecommerce Events

Generates a complete, client-standard Markdown documentation file for one or more GA4 ecommerce datalayer events.

## When to use this skill
- User asks to document a specific GA4 ecommerce event
- User asks to create a dataLayer spec / tracking plan
- User asks to add an event to existing datalayer documentation
- User provides a new event name and asks for the full doc
- User asks to update or extend an existing event doc

## What you need from the user
- **Event name(s)** — e.g. `purchase`, `begin_checkout` (required)
- **Funnel context** — e.g. `overnachten-hotel`, `dagje-uit`, `spa` (ask if missing)
- **Custom parameters** — any client-specific fields beyond the standard set (ask if unsure)
- **Trigger moment** — when does this event fire? (ask if not obvious from event name)

If funnel context is missing, ask before proceeding: "Voor welke funnel is dit event? (bijv. overnachten-hotel / overnachten-vakantiewoning)"

## Process

1. **Identify the event** — look up the event spec in `references/event-specs.md`
2. **Determine parameters** — combine the standard shared params + event-specific params from the reference file. Add any client-supplied custom params.
3. **Write the Touchpoint section** — describe when/how the event fires, including viewport rules, deduplication rules, or other trigger conditions specific to this event.
4. **Build the Field Mapping tables** — three tables in order:
   - Event Name table
   - Event Array Keys table (event-level ecommerce parameters)
   - Items Array Keys table (only if this event uses an `items` array)
5. **Write the Code Format block** — empty template with all fields present
6. **Write the Code Example block(s)** — at minimum one filled example; add "without prices" variant if `price` is conditional
7. **Output as a single Markdown file**

Read `references/event-specs.md` before writing any output — it contains the canonical parameter lists, types, and conditional rules for all events.

## Output format

Each event document follows this exact structure:
