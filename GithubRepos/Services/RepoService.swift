//
//  RepoService.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 25..
//

import Foundation

class RepoPublisher {
    @Published var repo: Repository?
}

protocol RepoServiceProtocol: RepoPublisher {
    var api: APIManagerProtocol { get }
    func fetchRepo(user: String, repo: String) async throws
}

class RepoService: RepoPublisher, RepoServiceProtocol, ObservableObject {

    private(set) var api: APIManagerProtocol =  APIManager.shared

    func fetchRepo(user: String, repo: String) async throws {
        let repo =  try await api.fetchItem(endpoint: .getRepo(user: user, repo: repo))
        await MainActor.run(body: { [weak self] in
            self?.repo = repo
        })
    }
}
