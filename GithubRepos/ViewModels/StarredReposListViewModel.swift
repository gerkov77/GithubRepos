//
//  StarredReposViewModel.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 26..
//

import SwiftUI
import Combine
import CoreData

class StarredReposListViewModel: ObservableObject {
  let service = PersistenceService()
    @Published var repos: [StarredRepoViewModel] = []
    
    var bag = Set<AnyCancellable>()
    
    func fetchRepos() {
        service.fetchStarredRepos()
        service.$repos
            .removeDuplicates()
            .sink { repos in
                self.repos = repos.map(StarredRepoViewModel.init)
                    
            for repo in repos {
                print("stored repo: \(repo.serverId), \(repo.name), \(repo.owner?.login), \(repo.owner?.avatarUrl)")
            }
        }
        .store(in: &bag)
    }
    
    func delete(_ repo: StarredRepoViewModel) {
        service.delete(repo)
        fetchRepos()
    }
}

struct StarredRepoViewModel: Hashable {
    let repo: StarredRepo
    
    var id: NSManagedObjectID {
        return repo.objectID
    }
    
    var name: String {
        return repo.name
    }
    
    var avatarUrl: String {
        return repo.owner?.avatarUrl ?? ""
    }
    
    var ownerName: String {
        return repo.owner?.login ?? "Could not fetch username"
    }
}
