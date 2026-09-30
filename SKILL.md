---
name: travel-itinerary-planner
description: Research and plan China trips by public transport, self-drive or mixed transport; adapt to the user's pace and produce their chosen HTML, images, PDF, Feishu guide or Amap roadbook. Use for multi-day itineraries, route revisions, travel-guide formatting and trip-specific hotel or transport research.
---

# Travel Itinerary Planner

Produce a trip plan the actual travellers can follow: every day has a route, every stop has a reason, and uncertain transport or activities have workable alternatives. Match the user's transport, pace and chosen deliverables; a relaxed public-transport trip is one supported scenario, not a universal default.

Use one entrypoint with conditional references: read [self-drive planning](references/self-drive-planning.md) for driving legs, [delivery formats](references/delivery-formats.md) when choosing or producing outputs, and [anonymized cases](examples/README.md) only when an example helps. Mixed trips apply each transport mode to its own legs.

The workflow below exists because the easy failure modes are specific and repeatable: plans built from stale blog posts, transport legs that don't connect (last bus already gone), "sunrise every morning" schedules nobody enjoys, and hotels that look close on a map but need a car. Each step guards against one of those.

## 0. Before you start: tools and limits

Check which of these you have, and say up front what you'll do without the missing ones:

- **Browser with the user's logins** (e.g. Claude in Chrome) — needed for Xiaohongshu search, Ctrip/Fliggy live prices, Ctrip train lists, Amap routing. Read `references/research-playbook.md` before the first browser step; it has site-specific tricks that save a lot of flailing.
- **Web search / fetch** — fallback for official schedules, news, blog guides.
- **Headless Edge or Chrome** — renders the HTML template into PNG + PDF (`scripts/render.ps1` on Windows, `scripts/render.sh` on macOS/Linux).
- **Feishu tools / lark-cli** — needed only for a requested Feishu guide. Use the environment's document skill and current CLI help; do not assume authentication or hardcode an account.
- **Amap roadbook editing** — needs access to the exact plan and a supported interface or logged-in browser. Route-distance lookup alone does not prove roadbook-edit access.

Hard limits you must respect: never log in for the user, never type passwords, never solve CAPTCHAs or "security verification" pages, never book or pay. When a site needs login or shows verification, stop, tell the user which site and what you need, and continue with other work meanwhile.

### 使用前准备（向用户说明）

浏览器操作高德路书、小红书或账号专属报价时，请用户在 AI 实际控制的电脑浏览器及对应配置中登录。手机、另一浏览器或另一配置的登录态不能视为当前可用；先检查实际页面。高德还需要准确的目标路书 URL 和编辑权限。飞书 CLI/连接器需要独立授权与文档权限，不能用网页登录代替。

遇到扫码、短信验证码、滑块或安全校验，暂停该平台操作，由用户手动完成；收到完成通知后重新读取页面确认恢复，再接着做。继续不依赖该平台的工作。没有相应登录/权限/工具时交付可完成的本地内容，并逐项标记远程交付缺口。

## 1. Collect requirements (one round, then act)

Ask only what changes the plan. Use a single multi-question prompt if possible:

| Must know | Why it matters |
|-|-|
| Destination(s), dates, departure city | Everything else hangs on this |
| Hard end constraint (flight/train out, time) | Work transport backwards from it |
| Transport mode (self-drive / public only) | Decides where to stay and what's reachable |
| Party size, budget per night, comfort needs (e.g. "clean, no bugs") | Hotel filters |
| Interests and pace (sunrise/sunset? hiking? food? how packed?) | What fills the days |
| Output format (HTML / paged or long image / PDF / Feishu / Amap) | Deliverable |
| Existing material (their draft plan, screenshots) | Keep it, don't rewrite it |

Also extract must-see / optional / excluded / already-visited places, driving limits and rental pickup/return, EV constraints, hiking flexibility, and whether hotels/meals need research or are self-managed. Infer these from supplied material before asking. For formats, offer HTML, paged images, long image, PDF, Feishu guide and Amap roadbook; combinations are allowed. If unspecified, recommend a small combination for the use case and continue with an editable HTML draft while the choice is pending.

If asked only to format or supplement a draft, preserve its content and mark additions. If asked to revise the route, change the necessary order/points and give a retain/remove/add/reorder summary; do not preserve a broken route verbatim.

For an explicitly relaxed trip, suggest at most one early start in a 3-day stretch, rest after long transit and about three anchored activities per day. User-stated pace and daily driving capacity take precedence; do not impose this on active hiking or long-distance self-drive trips.

## 2. Build the route skeleton first

1. Fix the start point, the hard end, and the must-see places.
2. Order by geography; identify each **transfer day**. For scheduled transport, compute end-to-end with first/last departures, travel time and ticket-sale dates. For self-drive, read `references/self-drive-planning.md` and compare mapped driving time, detours and daily limits. Include airport/station-to-car or local transfer time for mixed trips.
3. Decide base locations (where to sleep) by **reachability without a car** if the user isn't driving. Measure walking/driving time from each candidate hotel to the main sights in Amap. A cheap, highly rated hotel 18 km from everything is a bad pick for bus travellers.
4. Only then fill days with sights.

When the user asks "can we do X on day N?", answer with the concrete constraint (which last departure, what time you'd arrive) and the trade-off of the only workable alternative, then give a recommendation.

**Transport must be concrete for its mode.** For scheduled legs write the verified train number or bus time, backup departures, stations/stops, duration, price and ticket-sale details. Check both outbound and return services. For local hired cars, record mapped distance/time, observed price, ride-hailing availability and pickup point. Never fill unseen numbers or prices. For self-drive, use the driving-day fields in the self-drive reference instead of inventing departure schedules.

Search hard for official operators before settling for multi-transfer routes: regional bus companies often post current timetables on their own Xiaohongshu / WeChat accounts (e.g. a direct 8-seat shuttle that removes a transfer entirely). A newer official timetable beats an older blog post.

## 3. Research each place (Xiaohongshu first)

For each destination, read 3–6 high-save Xiaohongshu notes (sort by relevance; prefer recent ones and ones from the same season as the trip). Extract:

- which areas/villages are worth walking vs. skippable (people are candid about this)
- specific shops, restaurants, viewpoints **with names** — these become your stops and backups
- seasonal facts (e.g. tea-picking season, cloud-sea season) and the exact spot for sunrise/sunset
- bookable experiences (price, duration, how far ahead to book)

Cross-check prices, opening hours and schedules with an official or recent source when possible. Anything you could not verify, label as such in the output — never present a guess as fact.

## 4. Hotels: compare, don't just list

Run this section only if the user wants hotel research. If lodging or food is self-managed, retain geographic overnight/end areas and supply resupply guidance where useful; do not force hotel shortlists or named restaurants into the trip.

For each base: filter on the booking site (price cap, rating ≥ 4.5–4.7, enough reviews), then open the top candidates and record:

- live price for the actual dates and party (include breakfast info)
- hygiene sub-score and 3–5 recent reviews; search reviews for 虫 / 蚊 / 蟑螂 / 潮 when the user cares about bugs
- distance/time to the sights (Amap), and any dealbreaker (shared bathroom, noise, remote)

Many users want to choose themselves: offer a wide, cheap-leaning shortlist per base (6–15 options) **grouped by area**, and say what each area implies for the daily plan ("stay here → sunrise is walkable; stay there → cheaper food but you need a car at 6 am"). Mark 1–2 as recommended, each card with a one-line "why / watch out". If the user already booked a base, drop that section. Mention that "new customer" discounts make prices account-specific, and name any platform you couldn't reach. Respect budget hints for food too — prefer local eateries with known prices over showpiece banquets.

## 5. Write the day plan

Every planned stop has a time or flexible window, title, reason to go and expected duration. Bookable sights or researched meals get a real named backup. For flexible roadside stops, a clear skip/return strategy may be more useful than another detour. Do not invent timed meals when the user plans to eat as they go. Flexible multi-day hiking gets a duration window and exit conditions, not fictional guaranteed progress.

Add per day: a short footer with what to wear / bring and one tip. Add a Q&A card at the top for any question the user raised during planning (e.g. "can we go up the mountain on day 3?").

## 6. Render the deliverable

Read `references/delivery-formats.md` and produce only the requested outputs. The template and rendering instructions below apply to HTML/image/PDF delivery; skip rendering for Feishu-only or Amap-only work. All outputs must derive from the same approved itinerary version.

Use `assets/itinerary-template.html` as the design base. It is a finished real trip (Yunnan, 7 days) — replace its content, keep its components:

- cover with illustrated hero + 4 quick facts, and a route bar (stops + transport between them)
- legend of icons and the "备选" style
- Q&A card
- one `.day` card per day with `.item` timeline rows (`.hl` for key moments) and `.alt` backups
- "交通一张表" (`.tt`): one row per leg — date, train no. / departure, from → to, price, where to buy / backup — plus a `.carbox` ("山上叫车怎么办") whenever part of the trip has no ride-hailing
- hotel cards per base, grouped by area (`.area` headers, `.hotels.three` grid, `.h.top` + badge for recommended, price, score, why)
- checklist with *when* to do each thing (ticket sale dates!)
- sources footer

Keep the `<script>` at the end: it writes `body[data-h]` (used to size screenshots) and, when the URL has `#page=N`, shows only the blocks marked `data-page="N"` with a small title + "N / total" header.

**For phone-image delivery, prefer paged images unless the user chose a long image.** A single 9,000-px image is hard to read on a phone. Tag every top-level block with `data-page`: page 1 = cover + route + legend + Q&A, then one page per day, then transport, hotels if researched (split by base if long), checklist + sources. Render only selected formats:

- Windows: `& scripts/render-pages.ps1 -Html trip.html -OutDir out/pages -Names "01_封面与路线,02_10.5_…,…"` for selected pages (call with `&` so Chinese file names survive). `scripts/render.ps1 -Html trip.html -OutPrefix out/MyTrip` produces both PDF and long PNG; see the delivery reference for this limitation.
- macOS/Linux: `bash scripts/render.sh trip.html out/MyTrip 760 both` (long PNG + PDF); select `png` or `pdf` as the fourth argument for a single format. For pages use `bash scripts/render-pages.sh trip.html out/pages`.

Look at a few pages before sending: nothing overflows, backups are visible, and dates/weekdays match the calendar. Send the pages in order with a caption telling the user they can multi-select them in WeChat.

Name newly generated files by content and version. Preserve user files; supersede by writing a new version rather than renaming or overwriting unknown prior outputs.

## 7. Report back

In chat, keep it short: what changed, the key decisions and why, what the user must do next (book X, buy tickets at time Y), and what you could not verify. List sources as links.

## Reference files

- `references/research-playbook.md` — how to actually get data out of Xiaohongshu, Ctrip, Fliggy, Amap, train listings; known traps. Read before browsing.
- `references/quality-checklist.md` — run through it before delivering.
