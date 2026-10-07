# Learning Dashboard — Flutter

## Demo Credentials

| Email | Password |
|-------|----------|
| test@demo.com | demo123 |

## Quick Start

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## Architecture

CLEAN + MVVM. GetX (Login, Dashboard) + Riverpod Notifier (Detail). Drift (SQLite) offline-first. See `help/` folder for detailed HTML guides per screen.

## Courses Catalog

`assets/mock/courses.json` contains **50 courses** — AI related, Python related, and React Native (RN) related.

## Lazy Loading (Dashboard)

The dashboard list loads courses lazily, **20 rows at a time**:

1. First load shows 20 courses (state `success`)
2. Scroll near bottom → `loadMore()` appends the next 20 courses
3. While loading more, a **small centered loading spinner** shows at the bottom of the list
4. Repeats until all 50 courses are visible (20 → 40 → 50)
5. Pull-to-refresh resets back to the first 20

```
Dashboard opens
     │
     ▼
getCourses() → 50 courses (cached in Drift)
     │
     ▼
UI shows first 20 ─────┐
     │                  │
User scrolls to bottom  │
     │                  │
     ▼                  │
loadMore() ──▶ isLoadingMore = true
              └─▶ small spinner at bottom center
              └─▶ +20 courses appended
              └─▶ isLoadingMore = false
     │
     ▼
Repeat until hasMore = false

Files:
- lib/presentation/viewmodels/course_dashboard_viewmodel.dart (pageSize=20, loadMore, isLoadingMore, scrollController)
- lib/presentation/screens/course_dashboard_screen.dart (ListView.builder bottom loading row)
```
