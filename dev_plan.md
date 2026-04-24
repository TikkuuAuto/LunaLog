# Luna Log — Next Phase Execution Guide for Codex

## Goal

Take the current Luna Log Flutter MVP and turn it into a more usable alpha build with:

1. persistent local storage
2. cleaner app architecture
3. better state management
4. app identity updates (package name, icon, splash)
5. improved UI consistency
6. minimal stats and streak feedback
7. first batch of pixel-art icons/assets generated and wired into the app

Project root:

```text
D:\LunaLog
```

---

## Current status

The MVP already has:

- Flutter Android project set up and runnable
- Home / Log / Archive / Settings pages
- language toggle
- theme toggle
- signal text generation
- record creation flow
- monthly/archive display
- analyze/test/debug build passed
- app installed successfully on emulator

Known limitations:

- data is currently in memory only
- UI is still MVP-level
- package name is still default
- app icon and splash are still default Flutter
- no real local persistence
- no formal pixel asset integration yet

---

## Execution priority

Please execute in this order:

1. local persistence
2. model cleanup + state management
3. package/app identity update
4. UI cleanup and design tokens
5. stats + streak basics
6. pixel icon/asset generation and integration
7. final validation

Do not jump ahead to audio, cloud sync, complex animation, or external music APIs.

---

# Phase 1 — Local persistence

## Objective

Persist records and app settings locally so data survives app restarts.

## Preferred implementation

Use a lightweight and reliable local solution.

Priority choice:
- use `Hive` for speed and simplicity

Acceptable alternative:
- `Isar` if implementation remains clean and fast

## Data to persist

### Daily log
Persist at least:

- id
- createdAt
- dateKey (YYYY-MM-DD)
- mood
- energy
- focus
- sleep
- soundtrack
- note
- generatedSignalText

### App settings
Persist at least:

- language
- themeMode
- firstLaunchCompleted
- optional future flags

### Optional future-ready fields
Please add room for future expansion, even if not used yet:

- baseProgressLevel
- unlockedCompanions
- streakCountCached

## Tasks

- add persistence dependency
- define storage adapters / serializers
- save log entries on create
- load latest log for Home screen
- load all logs for Archive screen
- save and restore language setting
- save and restore theme setting
- handle empty state gracefully

## Acceptance criteria

- records remain after app restart
- language persists after restart
- theme persists after restart
- Home reflects the latest saved entry
- Archive reads from persistent storage
- app still builds and runs on Android emulator

---

# Phase 2 — Models and architecture cleanup

## Objective

Separate UI state from app data and prepare for scaling.

## Required models

Create or refactor into clear models such as:

- `DailyLog`
- `AppSettings`
- `SignalState` or equivalent derived view model
- optional `BaseProgress`

## Suggested folder structure

Use a feature-first structure like this:

```text
lib/
  app/
  features/
    home/
    log/
    archive/
    settings/
    stats/
  shared/
    models/
    services/
    storage/
    theme/
    widgets/
    utils/
```

## Rules

- keep domain models separate from widgets
- keep storage logic separate from UI
- avoid large monolithic files
- avoid mixing generated signal logic directly inside widgets

---

# Phase 3 — State management

## Objective

Use a cleaner state management approach than scattered local state.

## Preferred choice

Use `Riverpod`.

If already partially using another simple solution, it is acceptable to migrate carefully.
Do not over-engineer.

## Tasks

- add Riverpod
- create providers for:
  - app settings
  - logs repository
  - latest log
  - archive/month data
  - streak/stat summary
- move business logic out of widgets where reasonable

## Acceptance criteria

- log creation updates Home and Archive through shared state
- theme changes propagate correctly
- language changes propagate correctly
- persistence reads/writes are coordinated through providers/services

---

# Phase 4 — App identity polish

## Objective

Remove default Flutter identity and make the app feel like Luna Log.

## Tasks

### Package and app name
- replace default package id `com.example.luna_log`
- use a real package name, e.g.:
  - `com.tikkuu.lunalog`
  - or another clean production-style identifier if needed
- update app display name to `Luna Log`

### App icon
Generate and integrate a first-pass app icon:
- pixel-art moon logo
- dark navy background
- clear silhouette
- readable at small sizes
- consistent with Luna Log style

### Splash screen
Create a simple splash:
- dark lunar-themed background
- centered moon/signal mark
- minimal and clean
- not photorealistic

## Acceptance criteria

- custom app name visible on emulator
- custom app icon visible on launcher
- splash screen no longer uses default Flutter style

---

# Phase 5 — UI cleanup and design tokens

## Objective

Keep the current product direction, but make the MVP feel more consistent and intentional.

## UI direction to preserve

- obvious pixel-art style
- dark lunar station mood
- game-like moon base feeling
- “small world” feeling
- not too realistic
- not too illustration-heavy in a painterly way

## Tasks

### Design tokens
Create reusable tokens/constants for:

- colors
- spacing
- radii
- shadows/glows if used
- typography scale
- chip styles
- card styles

### Theme support
Keep both:
- dark theme
- light theme

Language switch should stay inside Settings, not on the main screen.

### Cleanup targets
Review and improve:

- Home hierarchy
- Log page density
- Archive readability
- chip consistency
- card spacing
- title/body text sizes
- button consistency
- empty states

## Guidance

Do not redesign the whole app from scratch.
Perform a clean iterative polish that stays close to the current MVP.

---

# Phase 6 — Stats and streak basics

## Objective

Add the smallest useful feedback loop beyond raw logging.

## Required stats
Implement a simple Stats screen or section with at least:

- total logs this month
- current streak
- longest streak
- most common mood
- most common soundtrack
- optional short summary line

## Streak logic

Define streak based on consecutive daily logs by date.

Requirements:

- one log per day counts for streak
- multiple logs in one day should not multiply streak count
- handle date comparison robustly

## Acceptance criteria

- stats render from real persisted data
- streak updates correctly after new entries
- screen handles no-data state gracefully

---

# Phase 7 — Pixel icons and first asset pack

## Objective

Generate a first usable batch of pixel-art UI assets and wire them into the app.

Important:
Do not try to crop assets from previous mockup screenshots.
Rebuild assets cleanly in a consistent style.

## Style rules

All generated assets must follow this style:

- retro pixel art
- lunar station
- cozy sci-fi
- obvious pixel feel
- dark navy + cyan + lavender palette
- readable at small size
- not photorealistic
- clean silhouette-first design
- consistent with Luna Log UI

## Asset output rules

- use transparent PNG backgrounds where possible
- use `snake_case` file names
- organize by folders
- create an asset manifest file

## Required first batch

### Brand
Generate:
- `moon_logo_main`
- `moon_logo_small`
- `sparkle_star`
- `signal_beacon_icon`

### Navigation icons
Generate default + active states for:
- `nav_home`
- `nav_log`
- `nav_add`
- `nav_stats`
- `nav_me`

### Common UI icons
Generate:
- `icon_settings`
- `icon_calendar`
- `icon_play`
- `icon_check`

### State icons
Generate:
- mood levels 1–5
- energy levels 1–5
- focus levels 1–5
- sleep levels 1–5

Suggested names:

```text
mood_1_very_low
mood_2_low
mood_3_neutral
mood_4_good
mood_5_bright

energy_1
energy_2
energy_3
energy_4
energy_5

focus_1
focus_2
focus_3
focus_4
focus_5

sleep_1
sleep_2
sleep_3
sleep_4
sleep_5
```

## Optional if time allows
Generate first small base assets:
- `base_habitat_dome`
- `base_command_tower`
- `base_antenna_array`
- `rover_main`
- `ground_beacon_light`

Do this only after brand/nav/state assets are complete.

---

# Asset folder structure

Please create and use a structure like:

```text
assets/
  brand/
  nav/
  ui/
    common/
  status/
    mood/
    energy/
    focus/
    sleep/
  base/
```

Also create:

```text
assets/assets_manifest.json
```

And a Dart mapping file such as:

```text
lib/shared/assets/app_icons.dart
```

---

# Asset integration tasks

After generating assets:

1. add them to `pubspec.yaml`
2. create a typed asset mapping file
3. replace placeholder/default icons where appropriate
4. update bottom navigation to use custom icons
5. update logo/app header usage
6. use state icons in Log / Home / Archive where sensible

Do not block the entire app on having every final asset.
Integrate the first batch incrementally.

---

# Phase 8 — Validation and cleanup

## Required checks

Run and confirm:

```bash
flutter analyze
flutter test
flutter build apk --debug
```

Also:
- run app on emulator
- verify persistence across restart
- verify theme persistence
- verify language persistence
- verify stats and streak behavior
- verify custom icons render cleanly

## Deliverables

At the end, provide:

1. summary of what changed
2. list of key files created/modified
3. any unresolved issues
4. suggested next-phase tasks

Also save at least one updated emulator screenshot to the project root, for example:

```text
D:\LunaLog\pixel10-lunalog-v2.png
```

---

# Constraints

## Do
- keep changes incremental
- prefer maintainable code over clever code
- preserve the current product concept
- use clean naming
- leave comments only when useful

## Do not
- introduce cloud sync
- add external music APIs
- add complex animation systems
- add heavy game mechanics
- overbuild the architecture
- replace the whole UI with a different style

---

# Recommended execution order (checklist)

- [ ] add local persistence
- [ ] define/refactor models
- [ ] add Riverpod providers
- [ ] connect Home / Log / Archive to persisted data
- [ ] persist theme and language
- [ ] update package name and app label
- [ ] generate and apply app icon + splash
- [ ] add design tokens and clean UI
- [ ] implement basic stats and streak
- [ ] generate first icon asset batch
- [ ] integrate first icon asset batch
- [ ] run analyze / test / debug build
- [ ] verify on emulator
- [ ] export updated screenshot
- [ ] provide final summary

---

# Notes for implementation style

Treat this as an alpha-hardening pass, not a brand-new prototype.

The target outcome is:

- still recognizably the same Luna Log app
- significantly more usable
- visually more coherent
- technically ready for further iterations
- with the first real asset pipeline started
