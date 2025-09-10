//
//  UserRepository.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation

final class UserRepository: UserRepositoryProtocol {
    private let userAPIService: UserAPIProtocol
    
    init(userAPIService: UserAPIProtocol) {
        self.userAPIService = userAPIService
    }
    
    func fetchUsers() async throws -> [User] {
        return try await userAPIService.fetchUsers()
    }
    
    func fetchUser(by id: Int) async throws -> User {
        return try await userAPIService.fetchUser(by: id)
    }
    
    func createUser(_ user: User) async throws -> User {
        return try await userAPIService.createUser(user)
    }
    
    func updateUser(_ user: User) async throws -> User {
        return try await userAPIService.updateUser(id: user.id, user)
    }
    
    func deleteUser(by id: Int) async throws {
        try await userAPIService.deleteUser(by: id)
    }
}
