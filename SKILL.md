---
name: travel-itinerary-planner
description: Plan a complete, relaxed multi-day trip itinerary for China travel using real research (Xiaohongshu notes, Ctrip/Fliggy hotel and train prices, Amap distances) and deliver it as a polished long image + PDF with a backup option for every stop and meal. Use this skill whenever the user asks for a travel guide / 旅游攻略 / 行程 / 路书 / 几天几夜怎么玩, wants hotels compared across platforms, asks how to get somewhere by public transport, or wants an existing itinerary turned into a nicer, shareable format — even if they only mention one piece (e.g. "帮我看看景迈山住哪" or "这个攻略排版好看点").
---

# Travel Itinerary Planner

Produce a trip plan that two tired people can actually follow on their phones: every day on one timeline, every leg of transport verified, every stop with a reason to go and a backup if it fails, and hotels compared on real prices. The output is a designed long image (for phones) plus a PDF (for printing / forwarding).

The workflow below exists because the easy failure modes are specific and repeatable: plans built from stale blog posts, transport legs that don't connect (last bus already gone), "sunrise every morning" schedules nobody enjoys, and hotels that look close on a map but need a car. Each step guards against one of those.

## 0. Before you start: tools and limits

Check which of these you have, and say up front what you'll do without the missing ones:

- **Browser with the user's logins** (e.g. Claude in Chrome) — needed for Xiaohongshu search, Ctrip/Fliggy live prices, Ctrip train lists, Amap routing. Read `references/research-playbook.md` before the first browser step; it has site-specific tricks that save a lot of flailing.
- **Web search / fetch** — fallback for official schedules, news, blog guides.
- **Headless Edge or Chrome** — renders the HTML template into PNG + PDF (`scripts/render.ps1` on Windows, `scripts/render.sh` on macOS/Linux).

Hard limits you must respect: never log in for the user, never type passwords, never solve CAPTCHAs or "security verification" pages, never book or pay. When a site needs login or shows verification, stop, tell the user which site and what you need, and continue with other work meanwhile.

## 1. Collect requirements (one round, then act)

Ask only what changes the plan. Use a single multi-question prompt if possible:

| Must know | Why it matters |
|-|-|
| Destination(s), dates, departure city | Everything else hangs on this |
| Hard end constraint (flight/train out, time) | Work transport backwards from it |
| Transport mode (self-drive / public only) | Decides where to stay and what's reachable |
| Party size, budget per night, comfort needs (e.g. "clean, no bugs") | Hotel filters |
| Interests and pace (sunrise/sunset? hiking? food? how packed?) | What fills the days |
| Output format (image / PDF / Feishu doc) | Deliverable |
| Existing material (their draft plan, screenshots) | Keep it, don't rewrite it |

If the user already gave a draft for part of the trip, **keep their content verbatim** and mark your additions with a small "补充" tag, so they can see exactly what changed.

Pace defaults unless told otherwise: at most one early start in any 3-day stretch; a nap / rest block after any early morning or long transit; ~3 anchored activities per day. Users who say "we like sunrises" usually mean "one great sunrise", not one every day — ask if unsure.

## 2. Build the route skeleton first

1. Fix the start point, the hard end, and the must-see places.
2. Order by geography; identify each **transfer day** and compute it end-to-end with real schedules: first/last departures, travel time, ticket-sale dates. Check whether the last bus/train still leaves after the previous activity ends — this is the most common silent failure.
3. Decide base locations (where to sleep) by **reachability without a car** if the user isn't driving. Measure walking/driving time from each candidate hotel to the main sights in Amap. A cheap, highly rated hotel 18 km from everything is a bad pick for bus travellers.
4. Only then fill days with sights.

When the user asks "can we do X on day N?", answer with the concrete constraint (which last departure, what time you'd arrive) and the trade-off of the only workable alternative, then give a recommendation.

**Transport must be concrete, every leg.** Travellers can't act on "take the high-speed train" or "find a local car". For each leg write: the exact train number or bus departure time (plus 1–2 backup departures), origin → destination station/stop, duration, price, where to buy, and when tickets go on sale. For trains, check **both directions** — a plan that says "come back around 16:00" is useless if the return trains are 14:32 and 18:28. For local cars/taxis, write distance and minutes (from the map), the typical per-person price, whether ride-hailing apps work there, and who to call (e.g. ask the host for drivers' numbers on arrival). Transfers happen in real places, so name the pickup/drop point.

Search hard for official operators before settling for multi-transfer routes: regional bus companies often post current timetables on their own Xiaohongshu / WeChat accounts (e.g. a direct 8-seat shuttle that removes a transfer entirely). A newer official timetable beats an older blog post.

## 3. Research each place (Xiaohongshu first)

For each destination, read 3–6 high-save Xiaohongshu notes (sort by relevance; prefer recent ones and ones from the same season as the trip). Extract:

- which areas/villages are worth walking vs. skippable (people are candid about this)
- specific shops, restaurants, viewpoints **with names** — these become your stops and backups
- seasonal facts (e.g. tea-picking season, cloud-sea season) and the exact spot for sunrise/sunset
- bookable experiences (price, duration, how far ahead to book)

Cross-check prices, opening hours and schedules with an official or recent source when possible. Anything you could not verify, label as such in the output — never present a guess as fact.

## 4. Hotels: compare, don't just list

For each base: filter on the booking site (price cap, rating ≥ 4.5–4.7, enough reviews), then open the top candidates and record:

- live price for the actual dates and party (include breakfast info)
- hygiene sub-score and 3–5 recent reviews; search reviews for 虫 / 蚊 / 蟑螂 / 潮 when the user cares about bugs
- distance/time to the sights (Amap), and any dealbreaker (shared bathroom, noise, remote)

Many users want to choose themselves: offer a wide, cheap-leaning shortlist per base (6–15 options) **grouped by area**, and say what each area implies for the daily plan ("stay here → sunrise is walkable; stay there → cheaper food but you need a car at 6 am"). Mark 1–2 as recommended, each card with a one-line "why / watch out". If the user already booked a base, drop that section. Mention that "new customer" discounts make prices account-specific, and name any platform you couldn't reach. Respect budget hints for food too — prefer local eateries with known prices over showpiece banquets.

## 5. Write the day plan

Every timeline item has: time, transport/type icon, **title**, one or two lines of detail (what to see, cost, how long), and — for every sight and every meal — a **backup** line ("人太多 / 下雨 / 订不上 → do this instead"). Backups should be real named alternatives from your research, not "find another place".

Add per day: a short footer with what to wear / bring and one tip. Add a Q&A card at the top for any question the user raised during planning (e.g. "can we go up the mountain on day 3?").

## 6. Render the deliverable

Use `assets/itinerary-template.html` as the design base. It is a finished real trip (Yunnan, 7 days) — replace its content, keep its components:

- cover with illustrated hero + 4 quick facts, and a route bar (stops + transport between them)
- legend of icons and the "备选" style
- Q&A card
- one `.day` card per day with `.item` timeline rows (`.hl` for key moments) and `.alt` backups
- "交通一张表" (`.tt`): one row per leg — date, train no. / departure, from → to, price, where to buy / backup — plus a `.carbox` ("山上叫车怎么办") whenever part of the trip has no ride-hailing
- hotel cards per base, grouped by area (`.area` headers, `.hotels.three` grid, `.h.top` + badge for recommended, price, score, why)
- checklist with *when* to do each thing (ticket sale dates!)
- sources footer

Keep the `<script>` at the end that writes `body[data-h]`; the render script needs it to size the long image.

Then run the render script: `powershell -File scripts/render.ps1 -Html trip.html -OutPrefix out/MyTrip` on Windows, or `scripts/render.sh trip.html out/MyTrip` on macOS/Linux. It measures page height, writes a 2× long PNG and a PDF. Look at the PNG (crop sections if it's very tall) before sending: check nothing overflows, backups are visible, and dates/weekdays match the calendar.

Name files by content and version, e.g. `云南7天行程长图_版纳-景迈山-普洱-昆明.png`; when superseding a file, rename the old one with a `旧版_` prefix rather than leaving two similar names.

## 7. Report back

In chat, keep it short: what changed, the key decisions and why, what the user must do next (book X, buy tickets at time Y), and what you could not verify. List sources as links.

## Reference files

- `references/research-playbook.md` — how to actually get data out of Xiaohongshu, Ctrip, Fliggy, Amap, train listings; known traps. Read before browsing.
- `references/quality-checklist.md` — run through it before delivering.
