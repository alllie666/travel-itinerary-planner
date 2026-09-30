# Anonymized co-creation cases

These examples capture planning decisions, not current destination recommendations. Names, travel dates, flight/booking numbers, accounts, private chat links and precise camping locations are omitted. Do not infer live fares or schedules from them.

## Case A — Flexible nature-focused self-drive

**Input:** A multi-day mountain circuit, long driving days accepted, repeated sights excluded, food/lodging chosen en route, EV constraints, uncertain multi-day hiking duration.

**Problems:** A distant photo stop created a long detour; the itinerary named towns without explaining visits; a short first driving day ignored the traveller's capacity; different end/start POIs broke the daily route; hiking was fixed too rigidly.

**Resulting workflow:** Build the geographic circuit first; remove low-value detours; keep exact sights/access points; balance mapped driving with visits; use a hiking window and exit branches; verify Amap day connections and synchronize Feishu.

**Exercise:** Given “up to eight hours of driving, no fixed hotels, natural sights only, hiking may end early, Amap + Feishu”, the Skill should route to self-drive, omit hotel/restaurant shortlists, explain each sight, include cut order and read back both remote outputs. It should not impose relaxed public-transport pacing or fabricate kilometres.

## Case B — Relaxed public-transport and food trip

**Input:** A week across several bases by train/bus, shared accommodation budget, comfort preferences, named food/experiences, one memorable early start, phone-friendly guide.

**Problems:** Rural direct buses were missing from map proposals; a hotel looked nearby but was impractical without a car; outbound trains existed but return departures did not match the day; a very tall image was awkward on a phone.

**Resulting workflow:** Research recent same-season notes; verify operator schedules and both train directions; compare dated hotel prices, hygiene and reachability; include named backups; render swipable pages.

**Exercise:** Given “public transport, research hotels, one sunrise, paged images only”, the Skill should verify last departures and hotel access, preserve named meal backups, render pages and omit Amap roadbook editing and unsolicited PDFs.

## Case C — Mixed transport with output preference

**Exercise:** Given “train to a regional hub, rent an EV for three days, return by train, HTML only”, verify scheduled legs and pickup/return time, plan charging and driving limits, and deliver an editable HTML guide. If later asked to write a named Amap plan, reuse the same route version and verify the write; do not create another unrelated itinerary.
