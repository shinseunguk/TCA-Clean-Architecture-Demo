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
    
    enum Action: FeatureAction {
        enum ViewAction {
            case onAppear
            case selectUser(User?)
            case deleteUser(id: Int)
            case errorDismissed
        }
        
        enum InnerAction {
            case setLoading(Bool)
            case setError(String?)
        }
        
        enum AsyncAction {
            case usersResponse(Result<[User], Error>)
            case deleteUserResponse(Result<Void, Error>)
        }
        
        enum ScopeAction {
        }
        
        enum DelegateAction {
            case userSelected(User)
            case userDeleted(id: Int)
        }
        
        static func view(_ action: ViewAction) -> Self {
            switch action {
            case .onAppear: return .onAppear
            case .selectUser(let user): return .selectUser(user)
            case .deleteUser(let id): return .deleteUser(id: id)
            case .errorDismissed: return .errorDismissed
            }
        }
        
        static func inner(_ action: InnerAction) -> Self {
            switch action {
            case .setLoading(let isLoading): return .setLoading(isLoading)
            case .setError(let error): return .setError(error)
            }
        }
        
        static func async(_ action: AsyncAction) -> Self {
            switch action {
            case .usersResponse(let result): return .usersResponse(result)
            case .deleteUserResponse(let result): return .deleteUserResponse(result)
            }
        }
        
        static func scope(_ action: ScopeAction) -> Self {
            switch action {}
        }
        
        static func delegate(_ action: DelegateAction) -> Self {
            switch action {
            case .userSelected(let user): return .userSelected(user)
            case .userDeleted(let id): return .userDeleted(id: id)
            }
        }
        
        case onAppear
        case selectUser(User?)
        case deleteUser(id: Int)
        case errorDismissed
        
        case setLoading(Bool)
        case setError(String?)
        
        case usersResponse(Result<[User], Error>)
        case deleteUserResponse(Result<Void, Error>)
        
        case userSelected(User)
        case userDeleted(id: Int)
    }
    
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .concatenate([
                    .send(.setLoading(true)),
                    .send(.setError(nil)),
                    .run { send in
                        await send(.usersResponse(Result {
                            try await userClient.fetchUsers()
                        }))
                    }
                ])
                
            case .selectUser(let user):
                state.selectedUser = user
                if let user = user {
                    return .send(.userSelected(user))
                }
                return .none
                
            case .deleteUser(let id):
                return .run { send in
                    await send(.deleteUserResponse(Result {
                        try await userClient.deleteUser(id)
                    }))
                }
                
            case .errorDismissed:
                return .send(.setError(nil))
                
            case .setLoading(let isLoading):
                state.isLoading = isLoading
                return .none
                
            case .setError(let error):
                state.errorMessage = error
                return .none
                
            case .usersResponse(.success(let users)):
                state.users = users
                return .send(.setLoading(false))
                
            case .usersResponse(.failure(let error)):
                let errorMessage: String
                if let networkError = error as? NetworkError {
                    errorMessage = networkError.localizedDescription
                } else {
                    errorMessage = "알 수 없는 오류가 발생했습니다."
                }
                return .concatenate([
                    .send(.setLoading(false)),
                    .send(.setError(errorMessage))
                ])
                
            case .deleteUserResponse(.success):
                return .concatenate([
                    .send(.setLoading(false)),
                    .run { send in
                        await send(.usersResponse(Result {
                            try await userClient.fetchUsers()
                        }))
                    }
                ])
                
            case .deleteUserResponse(.failure(let error)):
                let errorMessage: String
                if let networkError = error as? NetworkError {
                    errorMessage = networkError.localizedDescription
                } else {
                    errorMessage = "삭제 중 오류가 발생했습니다."
                }
                return .concatenate([
                    .send(.setLoading(false)),
                    .send(.setError(errorMessage))
                ])
                
            case .userSelected:
                return .none
                
            case .userDeleted:
                return .none
            }
        }
    }
}
