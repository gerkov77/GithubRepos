//
//  ReposService.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 25..
//

import Foundation

class ReposPublisher {
    @Published var repos: [Repository] = []
}

protocol ReposListServiceProtocol: ReposPublisher {
    var api: APIManagerProtocol { get }
    var hasMoreRepos: Bool { get }
    func fetchRepos(for user: String) async throws
    func checkForMore()
    func resetSearch()
}

 class ReposListService: ReposPublisher, ReposListServiceProtocol, ObservableObject {

    @Published var allReposCount: Int = 0
     private(set)var api: APIManagerProtocol = APIManager.shared

    private var haveMore = true
    private var page = 1

     func fetchRepos(for user: String) async throws {
        if haveMore {

                let res = try await api.fetchItems(endpoint: .getRepos(for: user, page: page))
                await MainActor.run(body: { [weak self] in

                    self?.repos.append(contentsOf: res)
                    if res.count < 10 {
                        haveMore = false
                    }
                })
            page += 1
        }
    }
     @MainActor
     func checkForMore() {
         if repos.count >= allReposCount {
             haveMore = false
         }
     }

     func resetSearch() {
         haveMore = true
         page = 1
     }

     var hasMoreRepos: Bool {
         return self.haveMore
     }
}
