import SwiftUI
import SwiftData

struct AddBlockView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let date: Date
    var onSave: () -> Void

    @State private var title = ""
    @State private var icon = "📚"
    @State private var startHour = 9
    @State private var startMinute = 0
    @State private var duration = 45
    @State private var isBreak = false

    private let icons = ["📚", "📐", "🇬🇧", "⚛️", "🃏", "🧠", "✍️", "💻", "☀️", "☕️", "🍽", "🏃"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Основное") {
                    TextField("Название блока", text: $title)

                    Toggle("Перерыв", isOn: $isBreak)

                    Picker("Иконка", selection: $icon) {
                        ForEach(icons, id: \.self) { Text($0) }
                    }
                }

                Section("Время") {
                    Picker("Час", selection: $startHour) {
                        ForEach(6..<23) { Text("\($0)").tag($0) }
                    }
                    Picker("Минуты", selection: $startMinute) {
                        ForEach([0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55], id: \.self) {
                            Text(String(format: "%02d", $0)).tag($0)
                        }
                    }
                    Stepper("Длительность: \(duration) мин", value: $duration, in: 5...180, step: 5)
                }
            }
            .navigationTitle("Новый блок")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        save()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func save() {
        let startMinutes = startHour * 60 + startMinute
        let block = BlockEntity(
            title: title.trimmingCharacters(in: .whitespaces),
            icon: icon,
            startMinutes: startMinutes,
            durationMinutes: duration,
            isBreak: isBreak,
            date: date
        )
        if !isBreak {
            block.tasks.append(TaskEntity(title: "Основная задача"))
        }
        modelContext.insert(block)
        try? modelContext.save()
        onSave()
        dismiss()
    }
}
