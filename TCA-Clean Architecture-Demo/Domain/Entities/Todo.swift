//
//  Todo.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation

struct Todo: Identifiable, Equatable, Codable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
    
    init(id: Int, userId: Int, title: String, completed: Bool = false) {
        self.id = id
        self.userId = userId
        self.title = title
        self.completed = completed
    }
}

extension Todo {
    func toggleCompleted() -> Todo {
        return Todo(
            id: id,
            userId: userId,
            title: title,
            completed: !completed
        )
    }
}
