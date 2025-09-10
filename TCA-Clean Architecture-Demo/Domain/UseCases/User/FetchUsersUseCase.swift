//
//  FetchUsersUseCase.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation

protocol FetchUsersUseCaseProtocol {
    func execute() async throws -> [User]
    func execute(by id: Int) async throws -> User
}

final class FetchUsersUseCase: FetchUsersUseCaseProtocol {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute() async throws -> [User] {
        do {
            let users = try await userRepository.fetchUsers()
            return users.sorted { $0.id < $1.id }
        } catch {
            if let networkError = error as? NetworkError {
                throw networkError
            }
            throw NetworkError.unknown("사용자 목록을 불러오는 중 오류가 발생했습니다.")
        }
    }
    
    func execute(by id: Int) async throws -> User {
        do {
            return try await userRepository.fetchUser(by: id)
        } catch {
            if let networkError = error as? NetworkError {
                throw networkError
            }
            throw NetworkError.unknown("사용자 정보를 불러오는 중 오류가 발생했습니다.")
        }
    }
}
