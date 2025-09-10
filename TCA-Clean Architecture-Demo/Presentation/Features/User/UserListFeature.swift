//
//  UserListFeature.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct UserListFeature {
    @ObservableState
    struct State: Equatable {
        var users: [User] = []
        var isLoading = false
        var errorMessage: String?
        var selectedUser: User?
    }
    
    enum Action {
        case onAppear
        case fetchUsers
        case usersResponse(Result<[User], Error>)
        case selectUser(User?)
        case deleteUser(id: Int)
        case errorDismissed
    }
    
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchUsers)
                
            case .fetchUsers:
                state.isLoading = true
                state.errorMessage = nil
                return .run { send in
                    await send(.usersResponse(Result {
                        try await userClient.fetchUsers()
                    }))
                }
                
            case .usersResponse(.success(let users)):
                state.isLoading = false
                state.users = users
                return .none
                
            case .usersResponse(.failure(let error)):
                state.isLoading = false
                if let networkError = error as? NetworkError {
                    state.errorMessage = networkError.localizedDescription
                } else {
                    state.errorMessage = "알 수 없는 오류가 발생했습니다."
                }
                return .none
                
            case .selectUser(let user):
                state.selectedUser = user
                return .none
                
            case .deleteUser(let id):
                return .run { send in
                    await send(.usersResponse(Result {
                        try await userClient.deleteUser(id)
                        return try await userClient.fetchUsers()
                    }))
                }
                
            case .errorDismissed:
                state.errorMessage = nil
                return .none
            }
        }
    }
}
