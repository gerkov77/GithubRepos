//
//  ApiService.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 24..
//

import Foundation

protocol APIManagerProtocol {
    func fetchItems(endpoint: Endpoint) async throws -> [Repository]
    func fetchItem(endpoint: Endpoint) async throws -> Repository
}

struct APIManager: APIManagerProtocol {

    static let shared  = APIManager()

    private init() {}

    enum ApiError: Error {
        case invaludUrl
        case invalidData
        case unableToComplete

        var message: String {
            switch self {
            case .invaludUrl:
                return "There was a problem with the url"
            case .invalidData:
                return "There was a problem with the received data"
            case .unableToComplete:
                return "App was unable to complete the operation, check your internet connection"
            }
        }
    }
}

extension APIManager {
    func fetchItems<T: Codable>(endpoint: Endpoint) async throws -> [T] {
        guard let url: URL =  endpoint.url else {
            throw ApiError.invaludUrl
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ApiError.unableToComplete
        }
        print(">>reponse: \(response)")
        print(">>data: \(data)")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let reposResult = try decoder.decode(Array<T>.self, from: data)
        print(reposResult)
        return reposResult
    }
}

extension APIManager {
    func fetchItem<T: Codable>(endpoint: Endpoint) async throws -> T {
        guard let url: URL =  endpoint.url else {
            throw ApiError.invaludUrl
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ApiError.unableToComplete
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let result = try decoder.decode(T.self, from: data)
        print(result)
        return result
    }
}
