# Self-drive and mixed-transport planning

## Inputs that change the route

Extract dates, hard return time, pickup/return point, maximum driving hours, driver rotation, must-see/optional/excluded/already-visited places, nature/culture preference, hiking window and lodging/food policy. For EVs include vehicle/battery, usable range and charging constraints. Do not treat historic preferences from another traveller as defaults.

## Route design

1. Fix pickup, hard return and must-see points; sort by geography.
2. Distinguish the main circuit from detours and out-and-back branches. Compare actual added mapped distance/time before calling something “on the way”.
3. Group nearby sights but retain specific attractions, viewpoints, parking or trailhead POIs. Towns are overnight/resupply/turning nodes; explain their role.
4. Fit driving and visits to the traveller's limits. Map time excludes stops, meals, queues and closures; make room for these without inventing precise road forecasts.
5. Offer a ranked cut list. A low-value photo stop that adds substantial driving should be optional.

Every day records: exact start → ordered POIs → end; mapped km and pure driving time; visit reasons and durations; operating/arrival constraints; resupply/charging; first stop to cut; next-day connection.

Today's end and tomorrow's start must be the same POI. Do not pad a route with irrelevant metro stations or generic city centres. Actual pickup/return locations are legitimate transport anchors.

## EVs and hiking

For EVs verify compatible charging, operating status/source date, arrival reserve and a fallback station; distinguish charging time from driving time. Do not promise mountain range from nominal battery capacity alone.

For uncertain hiking duration, allocate a window and daily continue/exit decisions. Keep offline main, return and exit tracks in a trail tool. Local motorcycles or informal lifts are an auxiliary option only if contacts/pickup points are verified, not guaranteed rescue. Amap is for drivable access; it does not validate hiking terrain.

## Amap roadbook workflow

Distinguish distance lookup (`/dir`) from saved day-by-day roadbooks (`/plan`). Editing needs the user's requested target and authorization. When the user already authorized editing, continue within that scope; ask only for unresolved route choices or new material changes.

1. Read the existing plan's days and POIs before changing it. Save the relevant prior order as a recovery record.
2. Prefer a supported authorized API/connector when available; otherwise use the user's logged-in browser and its current documented controls. Never invent private endpoints or selectors.
3. Edit one day at a time. Choose exact POIs, disambiguating district, coordinates, entrance and neighbouring points.
4. Save and read back POI order, km, driving time and rendered route. Then move to the next day.
5. Recheck cross-day continuity and final return after all changes; synchronize the selected guide formats.

For disconnected lines check mismatched daily endpoints, same-name/wrong-region POIs, non-drivable points, unsupported roads and day-by-day display. Do not attribute a blank or straight line to a software bug until checking the actual routed legs.

Pause the affected operation at login/CAPTCHA, ambiguous target/POI, unexpected overwrite, save/readback mismatch or a material route overrun. Continue independent research. Record the last verified day and outstanding issue. Readback is required before claiming completion; route-panel text alone may verify km/time but not a missing rendered line.
