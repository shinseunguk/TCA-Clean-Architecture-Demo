//
//  NetworkProvider.swift
//  TCA-Clean Architecture-Demo
//
//  Created by ukseung.dev on 9/10/25.
//

import Foundation
import Moya

protocol NetworkProviderProtocol {
    func request<T: Codable, Target: TargetType>(_ target: Target, type: T.Type) async throws -> T
}

final class NetworkProvider: NetworkProviderProtocol {
    private let provider: MoyaProvider<MultiTarget>
    
    init(provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>()) {
        self.provider = provider
    }
    
    func request<T: Codable, Target: TargetType>(_ target: Target, type: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(MultiTarget(target)) { result in
                switch result {
                case .success(let response):
                    do {
                        let statusCode = response.statusCode
                        
                        guard 200...299 ~= statusCode else {
                            continuation.resume(throwing: NetworkError.from(statusCode: statusCode))
                            return
                        }
                        
                        let decodedData = try JSONDecoder().decode(type, from: response.data)
                        continuation.resume(returning: decodedData)
                    } catch {
                        continuation.resume(throwing: NetworkError.decodingError)
                    }
                    
                case .failure(let error):
                    let networkError = self.mapMoyaError(error)
                    continuation.resume(throwing: networkError)
                }
            }
        }
    }
    
    private func mapMoyaError(_ error: MoyaError) -> NetworkError {
        switch error {
        case .underlying(let error, _):
            let nsError = error as NSError
            if nsError.code == NSURLErrorNotConnectedToInternet {
                return .noConnection
            } else if nsError.code == NSURLErrorTimedOut {
                return .timeout
            } else {
                return .unknown(nsError.localizedDescription)
            }
        case .statusCode(let response):
            return .from(statusCode: response.statusCode)
        case .stringMapping, .jsonMapping, .objectMapping:
            return .decodingError
        case .requestMapping:
            return .invalidURL
        default:
            return .unknown(error.localizedDescription)
        }
    }
}
