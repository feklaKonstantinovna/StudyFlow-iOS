import Foundation

struct Block: Identifiable, Equatable {
    let id: String
    var title: String
    var icon: String
    var startMinutes: Int          // minutes from 00:00
    var durationMinutes: Int
    var isBreak: Bool
    var isCompleted: Bool
    var date: Date
    var tasks: [TaskItem]

    var startTimeText: String {
        let h = startMinutes / 60
        let m = startMinutes % 60
        return String(format: "%02d:%02d", h, m)
    }

    var endMinutes: Int { startMinutes + durationMinutes }

    var endTimeText: String {
        let h = endMinutes / 60
        let m = endMinutes % 60
        return String(format: "%02d:%02d", h, m)
    }
}

struct TaskItem: Identifiable, Equatable {
    let id: String
    var title: String
    var isCompleted: Bool
}
