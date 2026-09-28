import SwiftUI
import SwiftData

struct AnalyticsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var completedToday = 0
    @State private var totalToday = 0
    @State private var streak = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    statCard(
                        title: "Сегодня",
                        value: totalToday == 0 ? "—" : "\(completedToday)/\(totalToday)",
                        subtitle: totalToday == 0 ? "Нет блоков" : "\(Int(Double(completedToday)/Double(max(totalToday,1))*100))%",
                        icon: "sun.max.fill",
                        color: .accentPurple
                    )

                    statCard(
                        title: "Streak",
                        value: "\(streak) дн.",
                        subtitle: streak > 0 ? "Так держать!" : "Начни сегодня",
                        icon: "flame.fill",
                        color: .warningAmber
                    )

                    Text("Более подробная аналитика появится в следующих версиях.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Прогресс")
            .onAppear { loadStats() }
        }
    }

    private func statCard(title: String, value: String, subtitle: String, icon: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(color)
                .frame(width: 48, height: 48)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.title2.bold())
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func loadStats() {
        let day = Date().startOfDay
        let next = Calendar.current.date(byAdding: .day, value: 1, to: day)!

        let descriptor = FetchDescriptor<BlockEntity>(
            predicate: #Predicate { $0.date >= day && $0.date < next }
        )

        if let entities = try? modelContext.fetch(descriptor) {
            let main = entities.filter { !$0.isBreak }
            totalToday = main.count
            completedToday = main.filter { $0.isCompleted }.count
        }

        // Simple streak: consecutive days with at least one completed main block
        var currentStreak = 0
        for i in 0..<14 {
            guard let d = Calendar.current.date(byAdding: .day, value: -i, to: day) else { break }
            let n = Calendar.current.date(byAdding: .day, value: 1, to: d)!
            let desc = FetchDescriptor<BlockEntity>(
                predicate: #Predicate { $0.date >= d && $0.date < n }
            )
            let blocks = (try? modelContext.fetch(desc)) ?? []
            let main = blocks.filter { !$0.isBreak }
            if main.isEmpty {
                if i == 0 { continue }
                break
            }
            let done = main.filter { $0.isCompleted }.count
            if done > 0 {
                currentStreak += 1
            } else {
                break
            }
        }
        streak = currentStreak
    }
}

#Preview {
    AnalyticsView()
        .modelContainer(for: [BlockEntity.self, TaskEntity.self, AppSettingsEntity.self], inMemory: true)
}
