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
        do {
            try   service.fetchStarredRepos()
        }
        catch let err as PersistenceService.PersistenceError {
            print(err.message)
        } catch {
            print(error.localizedDescription)
        }
      
        service.$repos
            .removeDuplicates()
            .sink { repos in
                self.repos = repos.map(StarredRepoViewModel.init)
        }
        .store(in: &bag)
    }
    
    func delete(_ repo: StarredRepoViewModel) {
        service.delete(repo)
        fetchRepos()
    }
}
