//
//  StarredReposViewModel.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 26..
//

import SwiftUI
import Combine

class StarredReposViewModel: ObservableObject {
  let service = PersistenceService()
    @Published var repos: [StarredRepo]?
    
    var bag = Set<AnyCancellable>()
    
    func fetchRepos() {
        service.fetchStarredRepos()
        service.$repos.sink { repos in
            self.repos = repos
            for repo in repos {
                print("stored repo: \(repo.serverId), \(repo.name), \(repo.owner?.login), \(repo.owner?.avatarUrl)")
            }
        }
        .store(in: &bag)
    }
}
