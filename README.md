# StudyFlow iOS

Native iOS app for **StudyFlow** — study tracker with daily schedule, goals, kanban, analytics, widgets & Live Activities.

## Stack
- Swift 5.10+
- SwiftUI
- SwiftData
- iOS 17+
- Architecture: MVVM + Clean

## Features (MVP)
- Today schedule (blocks + tasks)
- Mark complete
- Templates (basic)
- Local persistence (SwiftData)
- Dark / Light mode
- Basic analytics (progress, streak)
- Onboarding placeholder

## Project structure
```
StudyFlow/
├── App/
├── Core/
├── Domain/
├── Data/
├── Features/
│   ├── Today/
│   ├── Calendar/
│   ├── Kanban/
│   ├── Goals/
│   ├── Analytics/
│   ├── Timer/
│   ├── Auth/
│   └── Settings/
├── Widgets/          (later)
└── LiveActivities/   (later)
```

## How to run
1. Open `StudyFlow.xcodeproj` in Xcode 16+
2. Select iPhone 15/16 simulator
3. Cmd+R

## Backend
Compatible with existing StudyTracker backend (`/data` sync will be added in next iterations).

## License
Private / All rights reserved.
