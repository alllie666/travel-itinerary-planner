# Research playbook (site-specific tactics)

Learned the hard way while planning real trips. Sites change; if a tactic stops working, fall back to the UI and note it.

## General browser etiquette

- Open your own tab; close the tabs you opened when done. Leave the user's tabs alone.
- Prefer reading text (`get_page_text`, or a small JS snippet returning `innerText`) over screenshots.
- If a page redirects to a login page or shows "Security Verification" / slider CAPTCHA: stop, tell the user the site name, and move on. Do not retry in a loop — repeated automated hits make verification more likely.
- Pages that look blank often just haven't finished loading: wait 3–5 s, then read again.

## Xiaohongshu (小红书)

- Search URL: `https://www.xiaohongshu.com/search_result?keyword=<urlencoded>&source=web_search_result_notes`
- Search results require login. Logged-out, the page shows only a "登录" button and no notes.
- **Do not open note URLs directly** (`/explore/<id>` without `xsec_token`) — this returns "page isn't available" and can trigger security verification. Instead open notes from the search page:
  - list cards: `document.querySelectorAll('section.note-item')` → title/author/likes via `innerText`
  - open one: `section.querySelector('a.cover').click()`; it opens as a modal
  - read: `#detail-title` and `#detail-desc` `innerText`; date is in `.bottom-container`
  - the modal often won't close with Escape — just navigate back to the search URL before opening the next one
- Good query patterns: `<地点> 必去景点 攻略`, `<地点> 采茶体验`, `<地点>住哪个寨子`, `<城市>市区 <活动> 半天`. The "大家都在搜" box suggests better queries.
- Prefer notes from the same season as the trip and with high saves; extract named shops/restaurants for main picks and backups.
- **Transport gold:** search `<A> <B> 班车 时间` / `<景区> 交通` — regional bus companies (e.g. 云南金孔雀交运集团) post official timetables as images. Open the note, take a screenshot and zoom into the table to read every departure, price and pickup point. Recent traveller notes add durations, seat tips and "no ride-hailing here" facts.
- Images carry the data more often than text: when `#detail-desc` is thin, screenshot the modal and zoom.

## Ctrip hotels (携程)

- Detail page with dates: `https://hotels.ctrip.com/hotels/detail/?hotelId=<id>&checkIn=YYYY-MM-DD&checkOut=YYYY-MM-DD&adult=2&crn=1` (needs login for prices).
- Room prices are not in plain page text; use a find/accessibility query for "room names with current prices", or read the room-selection region.
- Useful JS on a detail page: address (`/云南[^\n]{0,40}/`-style match), hygiene score block (`卫生\n4.x\n设施…`), recent reviews (date line + following text), and a regex for 虫|蚊|蟑螂|蚂蚁|潮 to surface bug complaints.
- **List page URL keyword parameters are ignored.** Use the UI: click the destination box, type the city, pick a location chip (e.g. a scenic area or station) or type in "位置/品牌/酒店", then press 搜索. Apply price / rating / review-count filters by clicking them (use a find query to get their refs).
- On the list page, hotel cards have numeric `id` attributes = hotelId; map over them to get name, score, review count, distance line and prices in one pass.
- Prices tagged 新客/十亿豪补 are account-specific — say so.

## Ctrip trains (携程火车票)

- `https://trains.ctrip.com/webapp/train/list?ticketType=0&dStation=<出发城市>&aStation=<到达城市>&dDate=YYYY-MM-DD&trainsType=gaotie-dongche`
- Page text lists departure time, duration, train number, arrival time/station, price and sale status ("10月1日05:00开售" = not yet on sale; tell the user the exact sale time).
- Fetching this URL without a browser session hits a verification redirect — use the browser.
- Query both directions separately (A→B and B→A); small stations may have only 3–4 trains a day each way.
- Ctrip's intercity-bus list URL returned 404 in testing; use operator timetables (above) instead.

## Fliggy (飞猪)

- `https://hotel.fliggy.com/hotel_list3.htm?cityName=<城市>&checkIn=…&checkOut=…&keywords=<酒店名>`
- Shows "请登录查看报价" and redirects to Taobao login when not logged in, even if the user says they logged in elsewhere (different Chrome profile/window). If the header still shows 注册/登录, report it once and stop trying.

## Amap (高德) web

- Route planner: `https://www.amap.com/dir?type=<0 drive|1 transit|2 walk>&fname=…&flat=…&flon=…&fid=…&dname=…` — easiest is to open `/dir`, click the start/end inputs, type a name, and pick a suggestion; the resulting URL carries lat/lon/POI id you can reuse.
- Once you know both POIs' `lat/lon/id` (from a previous route URL), navigate straight to `/dir?type=0&fname=…&flat=…&flon=…&fid=…&dname=…&dlat=…&dlon=…&did=…` and wait ~10 s — much faster than typing. The input boxes sometimes drop typed text while the page re-renders; re-`find` the textbox and type again.
- The map tiles may stay blank; the route panel text (time, km, via) still works — read it with page text or a zoomed screenshot of the left panel.
- Amap web **does not show hotel prices** and **does not know many intercity/rural bus lines** (it proposed a detour via a train when a direct bus existed). Use it for distances and walk/drive times, not for bus schedules.
- Villages closed to cars return "暂无驾车路线方案" — switch to walking.
- Small workshops may not exist as POIs; say "not on the map, book via the host/notes".
- Shareable marker links for the output: `https://uri.amap.com/marker?position=<lon>,<lat>&name=<名称>`.

## Official / ticketing sources

- Many rural Yunnan bus tickets are sold in WeChat mini-programs (e.g. 「金孔雀票务」) that you cannot open. Give the user the exact route to search, and note that last-departure times must be confirmed there.
- Scenic-area shuttle timetables change; cite the source and date, and add a "confirm the day before" item.

## Honesty rules

- Distinguish verified (with source/date) from inferred.
- When two sources disagree (e.g. old vs. new bus timetable), use the newer one and mention the discrepancy.
- Never fill a price or phone number you did not see.
