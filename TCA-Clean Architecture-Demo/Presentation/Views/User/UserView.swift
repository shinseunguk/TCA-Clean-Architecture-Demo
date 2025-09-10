//
//  UserView.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import SwiftUI
import ComposableArchitecture

struct UserView: View {
    @Bindable var store: StoreOf<UserListFeature>
    
    var body: some View {
        NavigationView {
            Group {
                if store.isLoading {
                    ProgressView("사용자 목록을 불러오는 중...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(store.users) { user in
                            UserRowView(
                                user: user,
                                onSelect: { store.send(.selectUser(user)) },
                                onDelete: { store.send(.deleteUser(id: user.id)) }
                            )
                        }
                    }
                    .refreshable {
                        store.send(.fetchUsers)
                    }
                }
            }
            .navigationTitle("사용자 목록")
            .onAppear {
                store.send(.onAppear)
            }
            .alert(
                "오류",
                isPresented: .constant(store.errorMessage != nil),
                presenting: store.errorMessage
            ) { _ in
                Button("확인") {
                    store.send(.errorDismissed)
                }
            } message: { errorMessage in
                Text(errorMessage)
            }
            .sheet(
                item: .constant(store.selectedUser)
            ) { user in
                UserDetailView(user: user) {
                    store.send(.selectUser(nil))
                }
            }
        }
    }
}


#Preview {
    UserView(
        store: Store(initialState: UserListFeature.State()) {
            UserListFeature()
        }
    )
}


