import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Сегодня", systemImage: "sun.max.fill")
                }

            AnalyticsView()
                .tabItem {
                    Label("Прогресс", systemImage: "chart.bar.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
        }
        .tint(Color.accentPurple)
    }
}

#Preview {
    RootTabView()
        .modelContainer(for: [BlockEntity.self, TaskEntity.self, AppSettingsEntity.self], inMemory: true)
}
