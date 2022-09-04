//
//  RepoService.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 25..
//

import Foundation
import CoreText

class RepoPublisher: ObservableObject {
    @Published var repo: Repository?
}

protocol RepoServiceProtocol: RepoPublisher {
    var api: ApiManagerProtocol { get }
    func fetchRepo(user: String, repo: String) async throws
}

class RepoService: RepoPublisher, RepoServiceProtocol {

    private(set) var api: ApiManagerProtocol =  APIManager.shared

    func fetchRepo(user: String, repo: String) async throws {
        let repo =  try await api.fetchItem(
            endpoint: .getRepo(user: user, repo: repo),
            requestedType: Repository.self)
        await MainActor.run(body: { [weak self] in
            self?.repo = repo
        })
    }
}
