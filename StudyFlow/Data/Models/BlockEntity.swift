import Foundation
import SwiftData

@Model
final class BlockEntity {
    @Attribute(.unique) var id: String
    var title: String
    var icon: String
    var startMinutes: Int
    var durationMinutes: Int
    var isBreak: Bool
    var isCompleted: Bool
    var date: Date
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \TaskEntity.block)
    var tasks: [TaskEntity] = []

    init(
        id: String = UUID().uuidString,
        title: String,
        icon: String = "📚",
        startMinutes: Int,
        durationMinutes: Int = 45,
        isBreak: Bool = false,
        isCompleted: Bool = false,
        date: Date = Date().startOfDay
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.startMinutes = startMinutes
        self.durationMinutes = durationMinutes
        self.isBreak = isBreak
        self.isCompleted = isCompleted
        self.date = date.startOfDay
        self.createdAt = Date()
    }

    func toDomain() -> Block {
        Block(
            id: id,
            title: title,
            icon: icon,
            startMinutes: startMinutes,
            durationMinutes: durationMinutes,
            isBreak: isBreak,
            isCompleted: isCompleted,
            date: date,
            tasks: tasks.map { $0.toDomain() }
        )
    }
}
