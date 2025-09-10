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
    
    enum Action: FeatureAction {
        enum ViewAction {
            case onAppear
            case toggleTodoCompleted(Todo)
            case deleteTodo(id: Int)
            case errorDismissed
        }
        
        enum InnerAction {
            case setLoading(Bool)
            case setError(String?)
        }
        
        enum AsyncAction {
            case todosResponse(Result<[Todo], Error>)
            case updateTodoResponse(Result<Todo, Error>)
            case deleteTodoResponse(Result<Void, Error>)
        }
        
        enum ScopeAction {
        }
        
        enum DelegateAction {
            case fetchUserTodos(userId: Int)
        }
        
        static func view(_ action: ViewAction) -> Self {
            switch action {
            case .onAppear: return .onAppear
            case .toggleTodoCompleted(let todo): return .toggleTodoCompleted(todo)
            case .deleteTodo(let id): return .deleteTodo(id: id)
            case .errorDismissed: return .errorDismissed
            }
        }
        
        static func inner(_ action: InnerAction) -> Self {
            switch action {
            case .setLoading(let isLoading): return .setLoading(isLoading)
            case .setError(let error): return .setError(error)
            }
        }
        
        static func async(_ action: AsyncAction) -> Self {
            switch action {
            case .todosResponse(let result): return .todosResponse(result)
            case .updateTodoResponse(let result): return .updateTodoResponse(result)
            case .deleteTodoResponse(let result): return .deleteTodoResponse(result)
            }
        }
        
        static func scope(_ action: ScopeAction) -> Self {
            switch action {}
        }
        
        static func delegate(_ action: DelegateAction) -> Self {
            switch action {
            case .fetchUserTodos(let userId): return .fetchUserTodos(userId: userId)
            }
        }
        
        case onAppear
        case toggleTodoCompleted(Todo)
        case deleteTodo(id: Int)
        case errorDismissed
        
        case setLoading(Bool)
        case setError(String?)
        
        case todosResponse(Result<[Todo], Error>)
        case updateTodoResponse(Result<Todo, Error>)
        case deleteTodoResponse(Result<Void, Error>)
        
        case fetchUserTodos(userId: Int)
    }
    
    @Dependency(\.todoClient) var todoClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .concatenate([
                    .send(.setLoading(true)),
                    .send(.setError(nil)),
                    .run { send in
                        await send(.todosResponse(Result {
                            try await todoClient.fetchTodos()
                        }))
                    }
                ])
                
            case .toggleTodoCompleted(let todo):
                let updatedTodo = todo.toggleCompleted()
                return .run { send in
                    await send(.updateTodoResponse(Result {
                        try await todoClient.updateTodo(updatedTodo)
                    }))
                }
                
            case .deleteTodo(let id):
                return .run { send in
                    await send(.deleteTodoResponse(Result {
                        try await todoClient.deleteTodo(id)
                    }))
                }
                
            case .errorDismissed:
                return .send(.setError(nil))
                
            case .setLoading(let isLoading):
                state.isLoading = isLoading
                return .none
                
            case .setError(let error):
                state.errorMessage = error
                return .none
                
            case .todosResponse(.success(let todos)):
                state.todos = todos
                return .send(.setLoading(false))
                
            case .todosResponse(.failure(let error)):
                let errorMessage: String
                if let networkError = error as? NetworkError {
                    errorMessage = networkError.localizedDescription
                } else {
                    errorMessage = "알 수 없는 오류가 발생했습니다."
                }
                return .concatenate([
                    .send(.setLoading(false)),
                    .send(.setError(errorMessage))
                ])
                
            case .updateTodoResponse(.success):
                return .concatenate([
                    .send(.setLoading(false)),
                    .run { send in
                        await send(.todosResponse(Result {
                            try await todoClient.fetchTodos()
                        }))
                    }
                ])
                
            case .updateTodoResponse(.failure(let error)):
                let errorMessage: String
                if let networkError = error as? NetworkError {
                    errorMessage = networkError.localizedDescription
                } else {
                    errorMessage = "업데이트 중 오류가 발생했습니다."
                }
                return .concatenate([
                    .send(.setLoading(false)),
                    .send(.setError(errorMessage))
                ])
                
            case .deleteTodoResponse(.success):
                return .concatenate([
                    .send(.setLoading(false)),
                    .run { send in
                        await send(.todosResponse(Result {
                            try await todoClient.fetchTodos()
                        }))
                    }
                ])
                
            case .deleteTodoResponse(.failure(let error)):
                let errorMessage: String
                if let networkError = error as? NetworkError {
                    errorMessage = networkError.localizedDescription
                } else {
                    errorMessage = "삭제 중 오류가 발생했습니다."
                }
                return .concatenate([
                    .send(.setLoading(false)),
                    .send(.setError(errorMessage))
                ])
                
            case .fetchUserTodos(let userId):
                state.selectedUserId = userId
                return .concatenate([
                    .send(.setLoading(true)),
                    .send(.setError(nil)),
                    .run { send in
                        await send(.todosResponse(Result {
                            try await todoClient.fetchUserTodos(userId)
                        }))
                    }
                ])
            }
        }
    }
}
