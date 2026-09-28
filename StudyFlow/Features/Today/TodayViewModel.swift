import Foundation
import SwiftData
import SwiftUI

@Observable
final class TodayViewModel {
    var blocks: [Block] = []
    var selectedDate: Date = Date().startOfDay

    private var modelContext: ModelContext?

    var completedCount: Int {
        blocks.filter { !$0.isBreak && $0.isCompleted }.count
    }

    var totalMainBlocks: Int {
        blocks.filter { !$0.isBreak }.count
    }

    var progress: Double {
        guard totalMainBlocks > 0 else { return 0 }
        return Double(completedCount) / Double(totalMainBlocks)
    }

    var progressPercent: Int {
        Int(progress * 100)
    }

    func configure(context: ModelContext) {
        self.modelContext = context
        loadBlocks()
    }

    func loadBlocks() {
        guard let context = modelContext else { return }
        let day = selectedDate.startOfDay
        let next = Calendar.current.date(byAdding: .day, value: 1, to: day)!

        let descriptor = FetchDescriptor<BlockEntity>(
            predicate: #Predicate { $0.date >= day && $0.date < next },
            sortBy: [SortDescriptor(\.startMinutes)]
        )

        do {
            let entities = try context.fetch(descriptor)
            blocks = entities.map { $0.toDomain() }
        } catch {
            print("Fetch error: \(error)")
            blocks = []
        }
    }

    func toggleBlockComplete(id: String) {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<BlockEntity>(
            predicate: #Predicate { $0.id == id }
        )
        guard let entity = try? context.fetch(descriptor).first else { return }
        entity.isCompleted.toggle()
        try? context.save()
        loadBlocks()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    func toggleTaskComplete(blockId: String, taskId: String) {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<TaskEntity>(
            predicate: #Predicate { $0.id == taskId }
        )
        guard let entity = try? context.fetch(descriptor).first else { return }
        entity.isCompleted.toggle()
        try? context.save()
        loadBlocks()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    func addSampleDayIfEmpty() {
        guard blocks.isEmpty, let context = modelContext else { return }

        let samples: [(String, String, Int, Int, Bool)] = [
            ("Подъём и завтрак", "☀️", 8 * 60, 30, true),
            ("Математика", "📐", 9 * 60, 50, false),
            ("Перерыв", "☕️", 9 * 60 + 50, 15, true),
            ("Английский", "🇬🇧", 10 * 60 + 5, 45, false),
            ("Обед", "🍽", 12 * 60, 60, true),
            ("Физика", "⚛️", 13 * 60, 50, false),
            ("Повторение Anki", "🃏", 15 * 60, 30, false),
        ]

        for (title, icon, start, duration, isBreak) in samples {
            let block = BlockEntity(
                title: title,
                icon: icon,
                startMinutes: start,
                durationMinutes: duration,
                isBreak: isBreak,
                date: selectedDate
            )
            if !isBreak {
                let task = TaskEntity(title: "Основная задача")
                block.tasks.append(task)
            }
            context.insert(block)
        }
        try? context.save()
        loadBlocks()
    }

    func deleteBlock(id: String) {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<BlockEntity>(
            predicate: #Predicate { $0.id == id }
        )
        if let entity = try? context.fetch(descriptor).first {
            context.delete(entity)
            try? context.save()
            loadBlocks()
        }
    }
}
