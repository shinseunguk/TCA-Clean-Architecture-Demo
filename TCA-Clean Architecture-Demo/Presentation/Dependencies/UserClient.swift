//
//  UserClient.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct UserClient {
    var fetchUsers: () async throws -> [User] = { [] }
    var fetchUser: (_ id: Int) async throws -> User = { _ in User(id: 0, name: "", username: "", email: "", phone: nil, website: nil, address: nil, company: nil) }
    var createUser: (_ user: User) async throws -> User = { $0 }
    var updateUser: (_ user: User) async throws -> User = { $0 }
    var deleteUser: (_ id: Int) async throws -> Void = { _ in }
}

extension UserClient: DependencyKey {
    static let liveValue = UserClient(
        fetchUsers: {
            let networkProvider = NetworkProvider()
            let userAPIService = UserAPIService(networkProvider: networkProvider)
            let fetchUsersUseCase = FetchUsersUseCase(userRepository: UserRepository(userAPIService: userAPIService))
            return try await fetchUsersUseCase.execute()
        },
        fetchUser: { id in
            let networkProvider = NetworkProvider()
            let userAPIService = UserAPIService(networkProvider: networkProvider)
            let fetchUsersUseCase = FetchUsersUseCase(userRepository: UserRepository(userAPIService: userAPIService))
            return try await fetchUsersUseCase.execute(by: id)
        },
        createUser: { user in
            let networkProvider = NetworkProvider()
            let userAPIService = UserAPIService(networkProvider: networkProvider)
            let userRepository = UserRepository(userAPIService: userAPIService)
            return try await userRepository.createUser(user)
        },
        updateUser: { user in
            let networkProvider = NetworkProvider()
            let userAPIService = UserAPIService(networkProvider: networkProvider)
            let userRepository = UserRepository(userAPIService: userAPIService)
            return try await userRepository.updateUser(user)
        },
        deleteUser: { id in
            let networkProvider = NetworkProvider()
            let userAPIService = UserAPIService(networkProvider: networkProvider)
            let userRepository = UserRepository(userAPIService: userAPIService)
            try await userRepository.deleteUser(by: id)
        }
    )
}

extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
