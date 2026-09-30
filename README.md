# travel-itinerary-planner

A [Claude Code](https://docs.claude.com/en/docs/claude-code/overview) **skill** that turns "help me plan a 3-day trip" into a researched, relaxed, phone-friendly travel guide — a designed long image plus a PDF — built from live data instead of stale blog posts.

It was distilled from planning a real 7-day Yunnan trip (Xishuangbanna → Jingmai Mountain → Pu'er → Kunming) by public transport, and is tuned for travel **within mainland China**, where the best information lives on Xiaohongshu, Ctrip, Fliggy and Amap.

## What it does

- **Asks once, then acts** — destination, dates, hard end time (flight/train), transport mode, budget, pace and interests.
- **Builds the route skeleton first** and checks every transfer end-to-end (last departures, ticket sale dates, return trains in both directions).
- **Researches on Xiaohongshu** (high-save, same-season notes) for which villages/areas are worth it, named restaurants and shops, bookable experiences (e.g. tea picking), and official operator timetables.
- **Compares hotels on live prices** for your exact dates and party size, checks hygiene scores and recent reviews for bug/noise complaints, measures reachability without a car, and groups options by area so you can choose.
- **Writes concrete transport**: train numbers, bus departure times with backups, pickup points, prices, where to buy, and how to get a car where there is no ride-hailing.
- **Gives every sight and every meal a backup** for crowds, rain or sold-out bookings.
- **Renders a polished deliverable** (illustrated cover, route bar, per-day timelines, transport table, hotel cards, checklist) with a headless browser: a set of **phone-sized page images** (one per day / section, easy to swipe or send in WeChat), plus a PDF and an optional single long image.

## Prerequisites

| Requirement | Why | Notes |
|-|-|-|
| **Claude Code** (CLI, desktop app or IDE extension) | Runs the skill | Skills are loaded from `~/.claude/skills/` or a project's `.claude/skills/` |
| **A browser Claude can drive, with your logins** — e.g. [Claude in Chrome](https://claude.com/chrome) | Xiaohongshu search, Ctrip/Fliggy live prices, Ctrip train lists and Amap routing only work in a logged-in browser | Log in yourself to **Xiaohongshu (小红书)**, **Ctrip (携程)**, **Amap (高德)**; optionally Fliggy (飞猪). Claude will never enter passwords or solve CAPTCHAs — it pauses and asks you |
| **Web search / fetch** tools | Official schedules, news, fallback research | Built into Claude Code |
| **Microsoft Edge or Google Chrome** installed | Headless rendering of the HTML template to PNG/PDF | Used by `scripts/render.ps1` (Windows) or `scripts/render.sh` (macOS/Linux) |
| **PowerShell 5.1+** (Windows) or **bash** (macOS/Linux) | Runs the render script | No Python required |
| A Chinese-capable font | Rendering | Windows: Microsoft YaHei / KaiTi (preinstalled). macOS: PingFang SC. Linux: install Noto Sans CJK SC |

Without a logged-in browser the skill still works, but falls back to web search only: no live hotel prices, fewer first-hand notes, and it will tell you which parts are unverified.

## Install

```bash
# Personal skill (available in every project)
git clone https://github.com/alllie666/travel-itinerary-planner ~/.claude/skills/travel-itinerary-planner
```

On Windows, clone into `%USERPROFILE%\.claude\skills\travel-itinerary-planner`.

## Use

Just ask in Chinese or English, for example:

- `帮我做一个景迈山三天两夜的攻略，从西双版纳出发，两个人，不自驾，住宿300以内，想看一次日出`
- `这是我写好的版纳行程（截图），帮我补全，交通写清楚，做成长图`
- `Plan 4 relaxed days in Dali and Shaxi by public transport, hotels under 400 CNY, output a PDF`

The skill will ask a few questions in one go, research, check in with you on real decisions (e.g. "stay in town or near the airport the night before your flight?"), and deliver `…长图.png` + `….pdf`.

## Repository layout

```
SKILL.md                         workflow the model follows
references/research-playbook.md  site-specific tactics for Xiaohongshu, Ctrip, Fliggy, Amap, trains
references/quality-checklist.md  pre-delivery checklist
assets/itinerary-template.html   design template (a finished real trip; replace content, keep components)
scripts/render-pages.ps1         HTML → one 2x PNG per page (Windows)
scripts/render.ps1               HTML → 2x PNG + PDF (Windows)
scripts/render.sh                HTML → 2x PNG + PDF (macOS / Linux)
```

## Limitations

- Websites change; selectors and URL tricks in the playbook may break. The skill is told to fall back to the normal UI.
- Some tickets (e.g. regional buses sold in WeChat mini-programs) can't be checked by Claude; the guide marks them "confirm before".
- Prices include account-specific discounts and move quickly; each guide states when prices were looked up.
- The skill never books, pays, logs in, or bypasses verification.
- `scripts/render.ps1` is tested on Windows 10 + Edge. `scripts/render.sh` follows the same steps but has not been tested on macOS/Linux yet — issues and PRs welcome.

## Authors & contributors

- [@alllie666](https://github.com/alllie666)
- [@BetteDavisEyes](https://github.com/BetteDavisEyes)

## License

MIT — see [LICENSE](LICENSE).
