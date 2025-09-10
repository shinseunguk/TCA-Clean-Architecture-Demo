//
//  TodoListFeature.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TodoListFeature {
    @ObservableState
    struct State: Equatable {
        var todos: [Todo] = []
        var isLoading = false
        var errorMessage: String?
        var selectedUserId: Int?
    }
    
    enum Action {
        case onAppear
        case fetchTodos
        case fetchUserTodos(userId: Int)
        case todosResponse(Result<[Todo], Error>)
        case toggleTodoCompleted(Todo)
        case deleteTodo(id: Int)
        case errorDismissed
    }
    
    @Dependency(\.todoClient) var todoClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchTodos)
                
            case .fetchTodos:
                state.isLoading = true
                state.errorMessage = nil
                return .run { send in
                    await send(.todosResponse(Result {
                        try await todoClient.fetchTodos()
                    }))
                }
                
            case .fetchUserTodos(let userId):
                state.isLoading = true
                state.errorMessage = nil
                state.selectedUserId = userId
                return .run { send in
                    await send(.todosResponse(Result {
                        try await todoClient.fetchUserTodos(userId)
                    }))
                }
                
            case .todosResponse(.success(let todos)):
                state.isLoading = false
                state.todos = todos
                return .none
                
            case .todosResponse(.failure(let error)):
                state.isLoading = false
                if let networkError = error as? NetworkError {
                    state.errorMessage = networkError.localizedDescription
                } else {
                    state.errorMessage = "알 수 없는 오류가 발생했습니다."
                }
                return .none
                
            case .toggleTodoCompleted(let todo):
                let updatedTodo = todo.toggleCompleted()
                return .run { send in
                    await send(.todosResponse(Result {
                        let _ = try await todoClient.updateTodo(updatedTodo)
                        return try await todoClient.fetchTodos()
                    }))
                }
                
            case .deleteTodo(let id):
                return .run { send in
                    await send(.todosResponse(Result {
                        try await todoClient.deleteTodo(id)
                        return try await todoClient.fetchTodos()
                    }))
                }
                
            case .errorDismissed:
                state.errorMessage = nil
                return .none
            }
        }
    }
}