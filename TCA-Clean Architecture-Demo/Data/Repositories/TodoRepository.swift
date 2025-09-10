//
//  TodoRepository.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation

final class TodoRepository: TodoRepositoryProtocol {
    private let todoAPIService: TodoAPIProtocol
    
    init(todoAPIService: TodoAPIProtocol) {
        self.todoAPIService = todoAPIService
    }
    
    func fetchTodos() async throws -> [Todo] {
        return try await todoAPIService.fetchTodos()
    }
    
    func fetchTodos(for userId: Int) async throws -> [Todo] {
        return try await todoAPIService.fetchTodos(for: userId)
    }
    
    func fetchTodo(by id: Int) async throws -> Todo {
        return try await todoAPIService.fetchTodo(by: id)
    }
    
    func createTodo(_ todo: Todo) async throws -> Todo {
        let request = CreateTodoRequest.from(todo)
        return try await todoAPIService.createTodo(request)
    }
    
    func updateTodo(_ todo: Todo) async throws -> Todo {
        return try await todoAPIService.updateTodo(id: todo.id, todo)
    }
    
    func deleteTodo(by id: Int) async throws {
        try await todoAPIService.deleteTodo(by: id)
    }
}
