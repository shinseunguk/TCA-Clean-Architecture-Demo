//
//  NetworkError.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation

enum NetworkError: Error, Equatable {
    case noConnection
    case timeout
    case serverError(Int)
    case invalidURL
    case invalidResponse
    case decodingError
    case unauthorized
    case forbidden
    case notFound
    case unknown(String)
    
    var localizedDescription: String {
        switch self {
        case .noConnection:
            return "인터넷 연결을 확인해주세요."
        case .timeout:
            return "요청 시간이 초과되었습니다."
        case .serverError(let code):
            return "서버 오류가 발생했습니다. (코드: \(code))"
        case .invalidURL:
            return "잘못된 URL입니다."
        case .invalidResponse:
            return "잘못된 응답입니다."
        case .decodingError:
            return "데이터 파싱에 실패했습니다."
        case .unauthorized:
            return "인증이 필요합니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다."
        case .unknown(let message):
            return "알 수 없는 오류: \(message)"
        }
    }
    
    static func from(statusCode: Int) -> NetworkError {
        switch statusCode {
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 500...599:
            return .serverError(statusCode)
        default:
            return .unknown("HTTP \(statusCode)")
        }
    }
}
