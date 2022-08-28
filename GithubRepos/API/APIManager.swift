//
//  ApiService.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 24..
//

import Foundation

protocol APIManagerProtocol {
    func fetchRepos(endpoint: Endpoint) async throws -> [Repository]
}

struct APIManager: APIManagerProtocol {
    
    static let shared  = APIManager()
   
    private init() {}
   
    enum GitHubApiError: Error {
        case invaludUrl
        case invalidData
        case unableToComplete
    }
}

extension APIManager {
    func fetchRepos(endpoint: Endpoint) async throws -> [Repository] {
        guard let url: URL =  endpoint.url else {
            throw GitHubApiError.invaludUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw GitHubApiError.unableToComplete
        }
        print(">>reponse: \(response)")
        print(">>data: \(data)")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let reposResult = try decoder.decode(Array<Repository>.self, from: data)
        print(reposResult)
        return reposResult
    }
}

extension APIManager {
    func fetchRepo(endpoint: Endpoint) async throws -> Repository {
        guard let url: URL =  endpoint.url else {
            throw GitHubApiError.invaludUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw GitHubApiError.unableToComplete
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let result = try decoder.decode(Repository.self, from: data)
        print(result)
        return result
    }
}
