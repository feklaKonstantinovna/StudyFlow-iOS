import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var vm = TodayViewModel()
    @State private var showAddBlock = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerCard
                    progressCard

                    if vm.blocks.isEmpty {
                        emptyState
                    } else {
                        blocksList
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Сегодня")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddBlock = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showAddBlock) {
                AddBlockView(date: vm.selectedDate) {
                    vm.loadBlocks()
                }
            }
            .onAppear {
                vm.configure(context: modelContext)
                vm.addSampleDayIfEmpty()
            }
        }
    }

    private var headerCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(Date().formatted(.dateTime.weekday(.wide).day().month(.wide)))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Твой план на день")
                    .font(.title2.bold())
            }
            Spacer()
            Text("🔥")
                .font(.largeTitle)
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Прогресс")
                    .font(.headline)
                Spacer()
                Text("\(vm.completedCount)/\(vm.totalMainBlocks)")
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: vm.progress)
                .tint(.accentPurple)
                .scaleEffect(x: 1, y: 1.5, anchor: .center)

            Text("\(vm.progressPercent)% выполнено")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var blocksList: some View {
        LazyVStack(spacing: 12) {
            ForEach(vm.blocks) { block in
                BlockCardView(
                    block: block,
                    onToggleBlock: { vm.toggleBlockComplete(id: block.id) },
                    onToggleTask: { taskId in
                        vm.toggleTaskComplete(blockId: block.id, taskId: taskId)
                    },
                    onDelete: { vm.deleteBlock(id: block.id) }
                )
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Пока нет блоков")
                .font(.headline)
            Text("Добавь первый блок или загрузи пример дня")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Загрузить пример") {
                vm.addSampleDayIfEmpty()
            }
            .buttonStyle(.borderedProminent)
            .tint(.accentPurple)
        }
        .padding(40)
    }
}

#Preview {
    TodayView()
        .modelContainer(for: [BlockEntity.self, TaskEntity.self, AppSettingsEntity.self], inMemory: true)
}
