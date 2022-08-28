//
//  ReposService.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 25..
//

import Foundation

 class ReposListService: ObservableObject {

    @Published var repos: [Repository] = []
    @Published var allReposCount: Int = 0
     private(set) var api: APIManager = APIManager.shared

    var hasMoreRepos = true
    var page = 1

     func fetchRepos(for user: String) async throws {
        if hasMoreRepos {

                let res = try await api.fetchRepos(endpoint: .getRepos(for: user, page: page))
                await MainActor.run(body: { [weak self] in

                    self?.repos.append(contentsOf: res)
                    if res.count < 10 {
                        hasMoreRepos = false
                    }
                })
            page += 1
        }
    }
     @MainActor
     func checkForMore() {
         if repos.count >= allReposCount {
             hasMoreRepos = false
         }
     }
}
