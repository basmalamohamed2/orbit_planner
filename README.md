
https://github.com/user-attachments/assets/6d1a3299-ee10-473c-b559-d8129ed2b63f
# Orbit Planner

**A note & to-do app where your tasks orbit you, and finished tasks become stars.**

Built with Flutter. Every planet, orbit and star is drawn in code with `CustomPainter`: no image assets.

**[▶ Live demo](https://basmalamohamed2.github.io/orbit_planner/)**

---

## The idea

Most to-do apps are a flat list. Orbit Planner turns your list into a small solar system:

- **You are the sun** in the middle.
- **Every task is a planet.** Its **size** is the priority, its **color** is the category (Study, Work, Personal).
- **The closer the deadline, the closer the orbit.** Due within 3 days: inner orbit. Within a week: middle. Later: outer.
- **Notes are moons** that circle their planet.
- **Complete a task and it shrinks into a star** that joins your night sky.

## Features

**Planning**
- Animated **Orbit view**: planets drift slowly along hand-drawn dashed orbits. Tap one to see its details, edit it, or complete it.
- **Add / edit sheet** with a live preview: the planet grows with the priority slider, changes color with the category, and tells you which orbit it will land on.
- Deadline with an **optional time**. Tasks without a time are "all day".
- **List view** with category filters, swipe-to-delete with **Undo**, and a completed section.
- **Moon notes**: attach short notes to any task. Each note becomes a moon.

**Motivation**
- **Complete → star animation**: the planet shrinks, a star pops in its place.
- **Night sky**: every finished task is a star that twinkles. Stars keep their place when you add new ones.
- **Stats**: total stars, day streak, and your favorite category.

**Reminders (Android)**
- Local notifications: **on time, 15 min before, or 1 hour before**. Tasks without a time remind you at 9:00 AM.
- Reminders follow your tasks automatically: completing, deleting or editing a task updates its notification.
- Tapping a notification opens that task.

**Comfort**
- **Responsive**: bottom bar on phones, navigation rail on tablets, extended rail on desktop.
- **Light, dark or system theme**, and a **gentle motion** switch. Motion also stops if the device has "reduce motion" on.
- A 3-slide **onboarding** (also drawn in code) that shows once.
- Everything is **saved on the device** and survives restarts.

> Reminders are Android-only: browsers cannot schedule notifications for a future time, so on the web the setting is disabled and says why.

## Tech stack

| | |
|---|---|
| Framework | Flutter, Dart 3 |
| State management | `provider` with `ChangeNotifier` view models (MVVM) |
| Drawing & animation | `CustomPainter`, `AnimationController`, `RepaintBoundary` |
| Storage | `shared_preferences` (tasks stored as versioned JSON) |
| Notifications | `flutter_local_notifications`, `timezone` |
| Typography | `google_fonts` (Newsreader + Lato) |
| Icons | `flutter_launcher_icons` |
| CI / hosting | GitHub Actions → GitHub Pages |

## Architecture

Feature-first, with a small clean-architecture split inside each feature: **domain** (models and interfaces, no Flutter), **data** (implementations), **presentation** (screens and view models).

```
lib/
├── main.dart                 # composition root: the only place that picks real implementations
├── app/
│   ├── shell/                # adaptive navigation (bottom bar ↔ rail)
│   └── reminder_coordinator.dart
├── core/
│   ├── theme/                # ThemeData + ThemeExtension (design tokens)
│   ├── responsive/           # breakpoints and layout helpers
│   ├── shapes/               # shared canvas helpers (ellipse, star, planet)
│   └── motion/               # animation on/off logic
└── features/
    ├── onboarding/
    ├── tasks/                # domain · data · presentation (orbit/, screens, widgets, view_models)
    ├── achievements/         # stats + night sky
    ├── notifications/        # ReminderService interface, planner, implementations
    └── settings/
```

Decisions worth a look:

- **Repository interfaces.** `TasksViewModel` depends on `TaskRepository`, not on `shared_preferences`. Storage moved from memory to the device without touching a single screen. `ReminderService` works the same way: real notifications on Android, a no-op implementation on the web.
- **Pure logic, separate from widgets.** Orbit layout (`OrbitLayout`), reminder planning (`ReminderPlanner`), deadline labels and achievement stats are plain Dart functions, easy to reason about and test.
- **Fast painting.** The orbit rings and sun are a static layer cached with `RepaintBoundary`. Only the planets repaint each frame, driven directly by the animation (no widget rebuilds). Hidden tabs pause their animations with `TickerMode`.
- **`ReminderCoordinator`.** A small object that listens to the tasks and the settings and keeps the scheduled notifications in sync, rescheduling only what changed. View models know nothing about notifications.
- **Stable randomness.** Star positions come from a hash of the task id, not `Random`, so the sky does not reshuffle.
- **Safe storage.** Enums are saved by name, a corrupted task is skipped instead of crashing the app, and the optional deadline time was added without breaking data saved by older versions.
- **Design system in the theme.** Colors and type live in `ThemeData` and a `ThemeExtension`, so dark mode and every component follow from one place. Flat shapes with hard offset shadows give the paper-cut look.

## Run it

You need the Flutter SDK. Check your setup with `flutter doctor`.

```bash
git clone https://github.com/basmalamohamed2/orbit_planner.git
cd orbit_planner
flutter pub get

flutter run -d chrome          # web
flutter run                    # a connected Android device or emulator
```

Build:

```bash
flutter build apk --release    # build/app/outputs/flutter-apk/app-release.apk
flutter build web --release
```

The web version is deployed automatically to GitHub Pages on every push to `main` (see `.github/workflows/deploy_web.yml`).

## Demo

Uploading OrbitPlannerDemo.mp4…
