# travel-itinerary-planner

A **skill for Claude Code and Codex** that turns a travel request into a researched itinerary by public transport, self-drive or mixed transport, with the user's choice of HTML, images, PDF, Feishu guide or Amap roadbook.

It grew from a shared self-drive planning Runbook/Skill and a real public-transport trip. This version brings both experiences into one entrypoint, with separate instructions for the different modes. It targets mainland China, using Xiaohongshu, booking platforms, official sources and Amap. [Anonymized cases](examples/README.md) explain the lessons without private chat or booking data.

## What it does

- **Asks once, then acts** — destination, dates, hard end time (flight/train), transport mode, budget, pace and interests.
- **Builds the route skeleton first** and checks every transfer end-to-end (last departures, ticket sale dates, return trains in both directions).
- **Handles self-drive and mixed trips** — mapped daily driving, detour value, exact scenic POIs, continuous daily endpoints, EV charging and flexible hiking windows.
- **Researches on Xiaohongshu** (high-save, same-season notes) for which villages/areas are worth it, named restaurants and shops, bookable experiences (e.g. tea picking), and official operator timetables.
- **Compares hotels on live prices** for your exact dates and party size, checks hygiene scores and recent reviews for bug/noise complaints, measures reachability without a car, and groups options by area so you can choose.
- **Writes concrete transport**: train numbers, bus departure times with backups, pickup points, prices, where to buy, and how to get a car where there is no ride-hailing.
- **Adds practical alternatives** for crowds, rain or sold-out bookings: named backups for planned sights/meals, skip/return choices for flexible roadside stops.
- **Renders a polished deliverable** (illustrated cover, route bar, per-day timelines, transport table, hotel cards, checklist) with a headless browser: a set of **phone-sized page images** (one per day / section, easy to swipe or send in WeChat), plus a PDF and an optional single long image.
- **Lets users choose outputs** — editable HTML, paged/long images, PDF, a collaborative Feishu guide, or a saved Amap driving roadbook. Hotel/meal research is optional when users arrange it on the road.
- **Reads back remote writes** — a saved button or command response alone is not completion; Feishu content and Amap days, POIs and route connections are checked.

## Prerequisites

| Requirement | Why | Notes |
|-|-|-|
| **Claude Code or Codex** | Runs the skill | Install in the agent's supported skill directory |
| **A browser the agent can drive, with your logins** — e.g. [Claude in Chrome](https://claude.com/chrome) or available Codex browser tools | Account-specific research and saved roadbooks need browser access | Log in yourself to the selected services; the agent pauses at verification |
| **Web search / fetch** tools | Official schedules, news, fallback research | Use tools available in the agent environment |
| **Microsoft Edge or Google Chrome** installed | Headless rendering of the HTML template to PNG/PDF | Used by `scripts/render.ps1` (Windows) or `scripts/render.sh` (macOS/Linux) |
| **PowerShell 5.1+** (Windows) or **bash** (macOS/Linux) | Runs the render script | No Python required |
| A Chinese-capable font | Rendering | Windows: Microsoft YaHei / KaiTi (preinstalled). macOS: PingFang SC. Linux: install Noto Sans CJK SC |
| Feishu document tools or `lark-cli` (optional) | Feishu delivery | Only required if selected; current user authentication and document access needed |
| Logged-in Amap roadbook editor or supported connector (optional) | Saved driving roadbook | Route lookup alone does not provide editing access; user supplies target plan |

Without a logged-in browser the skill still works, but falls back to web search only: no live hotel prices, fewer first-hand notes, and it will tell you which parts are unverified.

## Install

```bash
# Personal skill (available in every project)
git clone https://github.com/alllie666/travel-itinerary-planner ~/.claude/skills/travel-itinerary-planner
```

On Windows, clone into `%USERPROFILE%\.claude\skills\travel-itinerary-planner`.

For Codex, clone into its skills directory (default `~/.codex/skills/travel-itinerary-planner`); on Windows use the equivalent user-profile directory. If that directory already exists, inspect local changes before updating it.

## Use

Just ask in Chinese or English, for example:

- `帮我做一个景迈山三天两夜的攻略，从西双版纳出发，两个人，不自驾，住宿300以内，想看一次日出`
- `这是我写好的版纳行程（截图），帮我补全，交通写清楚，做成长图`
- `Plan 4 relaxed days in Dali and Shaxi by public transport, hotels under 400 CNY, output a PDF`
- `帮我规划云南自驾，住宿吃饭自己安排，每天最多开6小时，先分析绕路，输出HTML，确认后再更新我给的高德路书`
- `高铁到目的地后租电车三天，帮我衔接取还车，输出飞书攻略和分页图片`

The skill extracts requirements, resolves only missing decisions, researches the route and delivers the selected formats. It keeps the same itinerary version across files and remote tools. It never books or pays. Existing authorization to edit a named guide or roadbook carries forward; unresolved route choices still need the traveller's decision.

## Repository layout

```
SKILL.md                         workflow the model follows
references/research-playbook.md  site-specific tactics for Xiaohongshu, Ctrip, Fliggy, Amap, trains
references/quality-checklist.md  pre-delivery checklist
references/self-drive-planning.md driving / EV / hiking and Amap roadbook workflow
references/delivery-formats.md   output selection and Feishu delivery
examples/README.md              anonymized cases and evaluation scenarios
assets/itinerary-template.html   design template (a finished real trip; replace content, keep components)
scripts/render-pages.ps1         HTML → one 2x PNG per page (Windows)
scripts/render.ps1               HTML → 2x PNG + PDF (Windows)
scripts/render.sh                HTML → 2x PNG + PDF (macOS / Linux)
scripts/render-pages.sh          HTML → paged 2x PNG (macOS / Linux)
```

## Limitations

- Websites change; selectors and URL tricks in the playbook may break. The skill is told to fall back to the normal UI.
- Some tickets (e.g. regional buses sold in WeChat mini-programs) can't be checked by Claude; the guide marks them "confirm before".
- Prices include account-specific discounts and move quickly; each guide states when prices were looked up.
- The skill never books, pays, logs in, or bypasses verification.
- Windows rendering scripts were previously tested on Windows 10 + Edge. Cross-platform behavior still depends on browser/font availability; inspect generated files before delivery.
- Feishu and Amap delivery require available tools and access. Without them, local outputs still work and remote delivery is reported as blocked, not fabricated.

## Authors & contributors

- [@alllie666](https://github.com/alllie666)
- [@BetteDavisEyes](https://github.com/BetteDavisEyes)

## License

MIT — see [LICENSE](LICENSE).
