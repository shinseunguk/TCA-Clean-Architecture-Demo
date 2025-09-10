//
//  NetworkConfig.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation

struct NetworkConfig {
    static let baseURL = "https://jsonplaceholder.typicode.com"
    static let timeout: TimeInterval = 30.0
    
    enum Endpoint {
        case users
        case user(id: Int)
        case todos
        case userTodos(userId: Int)
        case todo(id: Int)
        
        var path: String {
            switch self {
            case .users:
                return "/users"
            case .user(let id):
                return "/users/\(id)"
            case .todos:
                return "/todos"
            case .userTodos(let userId):
                return "/todos?userId=\(userId)"
            case .todo(let id):
                return "/todos/\(id)"
            }
        }
        
        var url: URL? {
            return URL(string: NetworkConfig.baseURL + path)
        }
    }
}
