import Foundation
import SwiftData

@Model
final class TaskEntity {
    @Attribute(.unique) var id: String
    var title: String
    var isCompleted: Bool
    var createdAt: Date

    var block: BlockEntity?

    init(
        id: String = UUID().uuidString,
        title: String,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = Date()
    }

    func toDomain() -> TaskItem {
        TaskItem(id: id, title: title, isCompleted: isCompleted)
    }
}
