//
//  RepoService.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 25..
//

import Foundation

class RepoService: ObservableObject {

    @Published var repo: Repository?
    private(set) var api: APIManagerProtocol =  APIManager.shared

    func fetchRepo(user: String, repo: String) async throws {

        let repo =  try await api.fetchRepo(endpoint: .getRepo(user: user, repo: repo))

        await MainActor.run(body: { [weak self] in
            self?.repo = repo
        })

    }
}
