//
//  DetailRow.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import SwiftUI

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    DetailRow(title: "이름", value: "홍길동")
}