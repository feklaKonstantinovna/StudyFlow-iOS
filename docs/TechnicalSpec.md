# Technical Spec — MVP

## Architecture
MVVM + light Clean Architecture.

- **Domain**: Entities + simple use cases
- **Data**: SwiftData models + repositories
- **Features**: SwiftUI views + ViewModels

## Data model (MVP)
- `BlockEntity` — id, title, icon, startMinutes, duration, isBreak, isCompleted, date
- `TaskEntity` — id, title, isCompleted, blockId
- `DayProgress` — computed

## Key screens
1. `RootTabView`
2. `TodayView`
3. `BlockEditorView`
4. `AnalyticsView` (simple)
5. `SettingsView` (placeholder)
