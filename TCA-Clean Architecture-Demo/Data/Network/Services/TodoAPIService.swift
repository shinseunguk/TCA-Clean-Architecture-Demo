//
//  TodoAPIService.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation

struct EmptyResponse: Codable {}

protocol TodoAPIProtocol {
    func fetchTodos() async throws -> [Todo]
    func fetchTodos(for userId: Int) async throws -> [Todo]
    func fetchTodo(by id: Int) async throws -> Todo
    func createTodo(_ request: CreateTodoRequest) async throws -> Todo
    func updateTodo(id: Int, _ todo: Todo) async throws -> Todo
    func deleteTodo(by id: Int) async throws
}

final class TodoAPIService: TodoAPIProtocol {
    private let networkProvider: NetworkProviderProtocol
    
    init(networkProvider: NetworkProviderProtocol) {
        self.networkProvider = networkProvider
    }
    
    func fetchTodos() async throws -> [Todo] {
        return try await networkProvider.request(TodoAPI.todos, type: [Todo].self)
    }
    
    func fetchTodos(for userId: Int) async throws -> [Todo] {
        return try await networkProvider.request(TodoAPI.userTodos(userId: userId), type: [Todo].self)
    }
    
    func fetchTodo(by id: Int) async throws -> Todo {
        return try await networkProvider.request(TodoAPI.todo(id: id), type: Todo.self)
    }
    
    func createTodo(_ request: CreateTodoRequest) async throws -> Todo {
        return try await networkProvider.request(TodoAPI.createTodo(request), type: Todo.self)
    }
    
    func updateTodo(id: Int, _ todo: Todo) async throws -> Todo {
        return try await networkProvider.request(TodoAPI.updateTodo(id: id, todo), type: Todo.self)
    }
    
    func deleteTodo(by id: Int) async throws {
        let _: EmptyResponse = try await networkProvider.request(TodoAPI.deleteTodo(id: id), type: EmptyResponse.self)
    }
}