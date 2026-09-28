import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Аккаунт") {
                    Label("Войти (скоро)", systemImage: "person.crop.circle")
                        .foregroundStyle(.secondary)
                }

                Section("Учёба") {
                    Label("Дата экзамена (скоро)", systemImage: "calendar")
                    Label("Шаблоны (скоро)", systemImage: "doc.on.doc")
                }

                Section("О приложении") {
                    HStack {
                        Text("Версия")
                        Spacer()
                        Text("0.1.0 MVP")
                            .foregroundStyle(.secondary)
                    }
                    Text("StudyFlow iOS — нативный клиент трекера учёбы")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Настройки")
        }
    }
}

#Preview {
    SettingsView()
}
