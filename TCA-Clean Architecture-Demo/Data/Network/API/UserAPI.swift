//
//  UserAPI.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation
import Moya

enum UserAPI {
    case users
    case user(id: Int)
    case createUser(User)
    case updateUser(id: Int, User)
    case deleteUser(id: Int)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .users:
            return "/users"
        case .user(let id), .updateUser(let id, _), .deleteUser(let id):
            return "/users/\(id)"
        case .createUser:
            return "/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .users, .user:
            return .get
        case .createUser:
            return .post
        case .updateUser:
            return .put
        case .deleteUser:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .users, .user, .deleteUser:
            return .requestPlain
        case .createUser(let user), .updateUser(_, let user):
            return .requestJSONEncodable(user)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .users:
            return """
            [{"id": 1, "name": "Sample User", "username": "sample", "email": "sample@example.com"}]
            """.data(using: .utf8)!
        default:
            return """
            {"id": 1, "name": "Sample User", "username": "sample", "email": "sample@example.com"}
            """.data(using: .utf8)!
        }
    }
}