import Foundation
import SwiftData

@Model
final class AppSettingsEntity {
    @Attribute(.unique) var id: String
    var examDate: Date?
    var points: Int
    var hasCompletedOnboarding: Bool

    init(
        id: String = "settings",
        examDate: Date? = nil,
        points: Int = 0,
        hasCompletedOnboarding: Bool = false
    ) {
        self.id = id
        self.examDate = examDate
        self.points = points
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
}
