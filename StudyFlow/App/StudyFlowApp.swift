import SwiftUI
import SwiftData

@main
struct StudyFlowApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            BlockEntity.self,
            TaskEntity.self,
            AppSettingsEntity.self
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
