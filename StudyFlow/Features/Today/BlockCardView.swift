import SwiftUI

struct BlockCardView: View {
    let block: Block
    var onToggleBlock: () -> Void
    var onToggleTask: (String) -> Void
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(block.icon)
                    .font(.title2)
                    .frame(width: 40, height: 40)
                    .background(Color.accentPurple.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text(block.title)
                        .font(.headline)
                        .strikethrough(block.isCompleted)
                        .foregroundStyle(block.isCompleted ? .secondary : .primary)

                    Text("\(block.startTimeText) – \(block.endTimeText) · \(block.durationMinutes) мин")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if !block.isBreak {
                    Button(action: onToggleBlock) {
                        Image(systemName: block.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title2)
                            .foregroundStyle(block.isCompleted ? Color.successGreen : Color.secondary)
                    }
                }
            }

            if !block.tasks.isEmpty && !block.isBreak {
                Divider()
                ForEach(block.tasks) { task in
                    HStack {
                        Button {
                            onToggleTask(task.id)
                        } label: {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(task.isCompleted ? Color.successGreen : Color.secondary)
                        }
                        Text(task.title)
                            .font(.subheadline)
                            .strikethrough(task.isCompleted)
                            .foregroundStyle(task.isCompleted ? .secondary : .primary)
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(block.isBreak ? 0.7 : 1)
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Удалить", systemImage: "trash")
            }
        }
    }
}
