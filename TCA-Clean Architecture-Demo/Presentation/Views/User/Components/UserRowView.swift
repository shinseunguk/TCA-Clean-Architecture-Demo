//
//  UserRowView.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import SwiftUI

struct UserRowView: View {
    let user: User
    let onSelect: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                
                Text("@\(user.username)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(user.email)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
        }
    }
}

#Preview {
    UserRowView(
        user: User(
            id: 1,
            name: "John Doe",
            username: "johndoe",
            email: "john@example.com",
            phone: nil,
            website: nil,
            address: nil,
            company: nil
        ),
        onSelect: {},
        onDelete: {}
    )
}