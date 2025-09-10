//
//  TodoAPI.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation
import Moya

struct CreateTodoRequest: Codable {
    let userId: Int
    let title: String
    let completed: Bool
    
    init(userId: Int, title: String, completed: Bool = false) {
        self.userId = userId
        self.title = title
        self.completed = completed
    }
    
    static func from(_ todo: Todo) -> CreateTodoRequest {
        return CreateTodoRequest(
            userId: todo.userId,
            title: todo.title,
            completed: todo.completed
        )
    }
}

enum TodoAPI {
    case todos
    case userTodos(userId: Int)
    case todo(id: Int)
    case createTodo(CreateTodoRequest)
    case updateTodo(id: Int, Todo)
    case deleteTodo(id: Int)
}

extension TodoAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .todos:
            return "/todos"
        case .userTodos(let userId):
            return "/todos?userId=\(userId)"
        case .todo(let id), .updateTodo(let id, _), .deleteTodo(let id):
            return "/todos/\(id)"
        case .createTodo:
            return "/todos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .todos, .userTodos, .todo:
            return .get
        case .createTodo:
            return .post
        case .updateTodo:
            return .put
        case .deleteTodo:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .todos, .userTodos, .todo, .deleteTodo:
            return .requestPlain
        case .createTodo(let request):
            return .requestJSONEncodable(request)
        case .updateTodo(_, let todo):
            return .requestJSONEncodable(todo)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .todos, .userTodos:
            return """
            [{"id": 1, "userId": 1, "title": "Sample Todo", "completed": false}]
            """.data(using: .utf8)!
        default:
            return """
            {"id": 1, "userId": 1, "title": "Sample Todo", "completed": false}
            """.data(using: .utf8)!
        }
    }
}