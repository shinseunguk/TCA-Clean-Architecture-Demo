//
//  UserDetailView.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    DetailRow(title: "이름", value: user.name)
                    DetailRow(title: "사용자명", value: user.username)
                    DetailRow(title: "이메일", value: user.email)
                    
                    if let phone = user.phone {
                        DetailRow(title: "전화번호", value: phone)
                    }
                    
                    if let website = user.website {
                        DetailRow(title: "웹사이트", value: website)
                    }
                    
                    if let address = user.address {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("주소")
                                .font(.headline)
                            Text("\(address.street), \(address.suite)")
                            Text("\(address.city) \(address.zipcode)")
                        }
                    }
                    
                    if let company = user.company {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("회사")
                                .font(.headline)
                            Text(company.name)
                            Text(company.catchPhrase)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("사용자 상세")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") {
                        onDismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    UserDetailView(
        user: User(
            id: 1,
            name: "홍길동",
            username: "gildong",
            email: "gildong@example.com",
            phone: "010-1234-5678",
            website: "https://example.com",
            address: Address(
                street: "강남대로",
                suite: "123동 456호",
                city: "서울",
                zipcode: "12345",
                geo: nil
            ),
            company: Company(
                name: "예시 회사",
                catchPhrase: "혁신적인 솔루션",
                bs: "비즈니스 솔루션"
            )
        ),
        onDismiss: {}
    )
}