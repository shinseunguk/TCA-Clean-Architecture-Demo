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
                                onSelect: { store.send(.view(.selectUser(user))) },
                                onDelete: { store.send(.view(.deleteUser(id: user.id))) }
                            )
                        }
                    }
                    .refreshable {
                        store.send(.view(.onAppear))
                    }
                }
            }
            .navigationTitle("사용자 목록")
            .onAppear {
                store.send(.view(.onAppear))
            }
            .alert(
                "오류",
                isPresented: .constant(store.errorMessage != nil),
                presenting: store.errorMessage
            ) { _ in
                Button("확인") {
                    store.send(.view(.errorDismissed))
                }
            } message: { errorMessage in
                Text(errorMessage)
            }
            .sheet(
                item: .constant(store.selectedUser)
            ) { user in
                UserDetailView(user: user) {
                    store.send(.view(.selectUser(nil)))
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


