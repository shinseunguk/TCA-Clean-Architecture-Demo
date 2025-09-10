//
//  TodoClient.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct TodoClient {
    var fetchTodos: () async throws -> [Todo] = { [] }
    var fetchUserTodos: (_ userId: Int) async throws -> [Todo] = { _ in [] }
    var fetchTodo: (_ id: Int) async throws -> Todo = { _ in Todo(id: 0, userId: 0, title: "", completed: false) }
    var createTodo: (_ todo: Todo) async throws -> Todo = { $0 }
    var updateTodo: (_ todo: Todo) async throws -> Todo = { $0 }
    var deleteTodo: (_ id: Int) async throws -> Void = { _ in }
}

extension TodoClient: DependencyKey {
    static let liveValue = TodoClient(
        fetchTodos: {
            let networkProvider = NetworkProvider()
            let todoAPIService = TodoAPIService(networkProvider: networkProvider)
            let fetchTodosUseCase = FetchTodosUseCase(todoRepository: TodoRepository(todoAPIService: todoAPIService))
            return try await fetchTodosUseCase.execute()
        },
        fetchUserTodos: { userId in
            let networkProvider = NetworkProvider()
            let todoAPIService = TodoAPIService(networkProvider: networkProvider)
            let fetchTodosUseCase = FetchTodosUseCase(todoRepository: TodoRepository(todoAPIService: todoAPIService))
            return try await fetchTodosUseCase.execute(for: userId)
        },
        fetchTodo: { id in
            let networkProvider = NetworkProvider()
            let todoAPIService = TodoAPIService(networkProvider: networkProvider)
            let todoRepository = TodoRepository(todoAPIService: todoAPIService)
            return try await todoRepository.fetchTodo(by: id)
        },
        createTodo: { todo in
            let networkProvider = NetworkProvider()
            let todoAPIService = TodoAPIService(networkProvider: networkProvider)
            let todoRepository = TodoRepository(todoAPIService: todoAPIService)
            return try await todoRepository.createTodo(todo)
        },
        updateTodo: { todo in
            let networkProvider = NetworkProvider()
            let todoAPIService = TodoAPIService(networkProvider: networkProvider)
            let todoRepository = TodoRepository(todoAPIService: todoAPIService)
            return try await todoRepository.updateTodo(todo)
        },
        deleteTodo: { id in
            let networkProvider = NetworkProvider()
            let todoAPIService = TodoAPIService(networkProvider: networkProvider)
            let todoRepository = TodoRepository(todoAPIService: todoAPIService)
            try await todoRepository.deleteTodo(by: id)
        }
    )
}

extension DependencyValues {
    var todoClient: TodoClient {
        get { self[TodoClient.self] }
        set { self[TodoClient.self] = newValue }
    }
}
