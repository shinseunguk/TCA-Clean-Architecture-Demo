//
//  UserRepositoryProtocol.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func fetchUsers() async throws -> [User]
    func fetchUser(by id: Int) async throws -> User
    func createUser(_ user: User) async throws -> User
    func updateUser(_ user: User) async throws -> User
    func deleteUser(by id: Int) async throws
}