//
//  APIManager.swift
//  upstox
//
//  Created by Jayesh Agrawal on 16/11/24.
//

import Foundation

enum APIError: Error {
    case internetUnavailable
}

protocol APIManaging {
    func execute<Value: Decodable>(_ request: Request<Value>, url: URL) async throws -> Result<Value, Error>
}

final class APIManager: APIManaging {

    static let shared = APIManager()
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func execute<Value: Decodable>(_ request: Request<Value>,
                                   url: URL) async throws -> Result<Value, Error> {
        guard UCommonFunctions.isNetworkAvailable() else {
            return .failure(APIError.internetUnavailable)
        }
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest(for: request, url: url))
            let fetchedData = try JSONDecoder().decode(Value.self, from: data)
            return .success(fetchedData)
        } catch {
            return .failure(error)
        }
    }

    private func urlRequest<Value>(for request: Request<Value>, url: URL) -> URLRequest {
        var result = URLRequest(url: url)
        result.httpMethod = request.method.rawValue
        result.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return result
    }
}
