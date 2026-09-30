# Choose the delivery by the traveller's use case

| Format | Use case | Required verification |
|---|---|---|
| HTML | Editable guide, browser reading | Opens offline, readable width, no template trip remnants |
| Paged PNG | Phone swiping / messaging | Correct sequence, title/page count, no clipping |
| Long PNG | Single-image overview | Requested explicitly or useful at practical length; readable text |
| PDF | Printing / forwarding | Opens, page breaks and backgrounds intact |
| Feishu guide | Collaborative evolving itinerary | Saved URL, revision and content readback |
| Amap roadbook | Day-by-day driving navigation | Saved days/POIs, km/time, rendered route and cross-day continuity |

Ask once about formats if unspecified; recommend paged images for phone sharing, HTML for editing, Feishu for collaboration and Amap for driving. Combinations are valid. Until a choice arrives, an editable local draft is useful. Produce the selected formats, not an automatic bundle of everything.

## One itinerary, multiple views

Maintain one route version containing constraints, daily start/end/ordered points, transport mode per leg, visit reasons, time windows, cuts/backups, source dates and outstanding verification. Generate every selected output from that version; never update Amap while leaving the shared guide stale.

Adapt the sample HTML: replace all example facts, dates, hotel cards and sources. Remove hotel/meal sections if self-managed. Driving transport tables use mapped km/time, access/parking and charging instead of train numbers. Retain template components that fit the selected trip; they are not compulsory sections.

Rendering commands:

```bash
# macOS/Linux: format is png, pdf or both (default)
bash scripts/render.sh trip.html out/trip-v1 760 pdf
bash scripts/render-pages.sh trip.html out/pages-v1
```

Windows uses `render-pages.ps1` for paged PNG and `render.ps1` for PNG/PDF. The existing Windows combined renderer produces both files; disclose the additional file if the user requested only one. HTML-only needs no render command.

## Feishu

Use available Feishu document tools or `lark-cli`, reading the current document skill/help before commands. If available, these shortcut families support creation, update and readback: `docs +create`, `docs +update`, `docs +fetch`. Follow their current XML/Markdown contract rather than copying guessed arguments. If there is no Feishu capability, deliver a local guide and mark Feishu delivery blocked; do not fabricate a URL.

For an existing URL, fetch first and update the named document; for a requested new guide create one. Include route version/date, hard constraints, daily overview, reasons/durations, transport, cut/backups, sources and open items. Avoid unnecessary booking lists. Read back title, dates/day count, daily endpoints and changed sections, and report the actual revision. Do not alter sharing permissions or message companions unless requested.

## Completion

Report each selected output separately as verified, partial or blocked, with the real file/link and specific gap. A successful click/CLI response is not content verification. If login blocks a remote output, the local draft can still be completed.
