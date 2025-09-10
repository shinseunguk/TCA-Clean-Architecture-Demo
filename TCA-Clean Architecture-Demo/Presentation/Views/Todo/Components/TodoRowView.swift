//
//  TodoRowView.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import SwiftUI

struct TodoRowView: View {
    let todo: Todo
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.completed ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .strikethrough(todo.completed)
                    .foregroundColor(todo.completed ? .gray : .primary)
                
                Text("User ID: \(todo.userId)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TodoRowView(
        todo: Todo(id: 1, userId: 1, title: "Sample Todo", completed: false),
        onToggle: {},
        onDelete: {}
    )
}