//
//  FetchTodosUseCase.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation

protocol FetchTodosUseCaseProtocol {
    func execute() async throws -> [Todo]
    func execute(for userId: Int) async throws -> [Todo]
}

final class FetchTodosUseCase: FetchTodosUseCaseProtocol {
    private let todoRepository: TodoRepositoryProtocol
    
    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
    }
    
    func execute() async throws -> [Todo] {
        do {
            let todos = try await todoRepository.fetchTodos()
            return todos.sorted { $0.id < $1.id }
        } catch {
            if let networkError = error as? NetworkError {
                throw networkError
            }
            throw NetworkError.unknown("할일 목록을 불러오는 중 오류가 발생했습니다.")
        }
    }
    
    func execute(for userId: Int) async throws -> [Todo] {
        do {
            let todos = try await todoRepository.fetchTodos(for: userId)
            return todos.sorted { $0.id < $1.id }
        } catch {
            if let networkError = error as? NetworkError {
                throw networkError
            }
            throw NetworkError.unknown("사용자의 할일 목록을 불러오는 중 오류가 발생했습니다.")
        }
    }
}
