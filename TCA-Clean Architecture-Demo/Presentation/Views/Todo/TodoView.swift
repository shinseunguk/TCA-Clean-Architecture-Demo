//
//  TodoView.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import SwiftUI
import ComposableArchitecture

struct TodoView: View {
    @Bindable var store: StoreOf<TodoListFeature>
    
    var body: some View {
        NavigationView {
            Group {
                if store.isLoading {
                    ProgressView("할일 목록을 불러오는 중...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(store.todos) { todo in
                            TodoRowView(
                                todo: todo,
                                onToggle: { store.send(.view(.toggleTodoCompleted(todo))) },
                                onDelete: { store.send(.view(.deleteTodo(id: todo.id))) }
                            )
                        }
                    }
                    .refreshable {
                        store.send(.view(.onAppear))
                    }
                }
            }
            .navigationTitle("할일 목록")
            .onAppear {
                store.send(.view(.onAppear))
            }
            .alert(
                "오류",
                isPresented: .constant(store.errorMessage != nil),
                presenting: store.errorMessage
            ) { _ in
                Button("확인") {
                    store.send(.view(.errorDismissed))
                }
            } message: { errorMessage in
                Text(errorMessage)
            }
        }
    }
}


#Preview {
    TodoView(
        store: Store(initialState: TodoListFeature.State()) {
            TodoListFeature()
        }
    )
}

