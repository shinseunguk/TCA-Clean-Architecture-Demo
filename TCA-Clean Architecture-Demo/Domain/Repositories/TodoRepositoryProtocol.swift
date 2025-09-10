//
//  TodoRepositoryProtocol.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation

protocol TodoRepositoryProtocol {
    func fetchTodos() async throws -> [Todo]
    func fetchTodos(for userId: Int) async throws -> [Todo]
    func fetchTodo(by id: Int) async throws -> Todo
    func createTodo(_ todo: Todo) async throws -> Todo
    func updateTodo(_ todo: Todo) async throws -> Todo
    func deleteTodo(by id: Int) async throws
}