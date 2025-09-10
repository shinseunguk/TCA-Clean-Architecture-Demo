//
//  MainTabView.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    var body: some View {
        TabView {
            TodoView(
                store: Store(initialState: TodoListFeature.State()) {
                    TodoListFeature()
                }
            )
            .tabItem {
                Image(systemName: "checkmark.circle")
                Text("할일")
            }
            
            UserView(
                store: Store(initialState: UserListFeature.State()) {
                    UserListFeature()
                }
            )
            .tabItem {
                Image(systemName: "person.2")
                Text("사용자")
            }
        }
    }
}

#Preview {
    MainTabView()
}
