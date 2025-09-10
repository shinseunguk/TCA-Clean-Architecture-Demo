//
//  UserAPIService.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation

protocol UserAPIProtocol {
    func fetchUsers() async throws -> [User]
    func fetchUser(by id: Int) async throws -> User
    func createUser(_ user: User) async throws -> User
    func updateUser(id: Int, _ user: User) async throws -> User
    func deleteUser(by id: Int) async throws
}

final class UserAPIService: UserAPIProtocol {
    private let networkProvider: NetworkProviderProtocol
    
    init(networkProvider: NetworkProviderProtocol) {
        self.networkProvider = networkProvider
    }
    
    func fetchUsers() async throws -> [User] {
        return try await networkProvider.request(UserAPI.users, type: [User].self)
    }
    
    func fetchUser(by id: Int) async throws -> User {
        return try await networkProvider.request(UserAPI.user(id: id), type: User.self)
    }
    
    func createUser(_ user: User) async throws -> User {
        return try await networkProvider.request(UserAPI.createUser(user), type: User.self)
    }
    
    func updateUser(id: Int, _ user: User) async throws -> User {
        return try await networkProvider.request(UserAPI.updateUser(id: id, user), type: User.self)
    }
    
    func deleteUser(by id: Int) async throws {
        let _: EmptyResponse = try await networkProvider.request(UserAPI.deleteUser(id: id), type: EmptyResponse.self)
    }
}