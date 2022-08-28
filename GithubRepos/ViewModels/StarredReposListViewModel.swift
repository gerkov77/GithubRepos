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
    @Published var searchText = ""

    var bag = Set<AnyCancellable>()

    func fetchRepos() {
        do {
            try   service.fetchStarredRepos()
        } catch let err as PersistenceService.PersistenceError {
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
        filterStarredRepos()
    }

    func delete(_ repo: StarredRepoViewModel) {
        service.delete(repo)
        fetchRepos()
    }
}

extension StarredReposListViewModel {
    func filterStarredRepos() {
        let searchTextFilteredReposPublisher: AnyPublisher<[StarredRepo], Never> = $searchText
            .combineLatest(service.$repos)
            .receive(on: DispatchQueue.main)
            .map { (text, repos) -> [StarredRepo] in
                guard !text.isEmpty else { return repos}
                let lowerText = text.lowercased()
                let filteredProds = repos.filter {
                    return $0.name.lowercased().contains(lowerText)
                }
                print(">> filtered products : \(filteredProds)")
                return filteredProds
            }
            .eraseToAnyPublisher()
        searchTextFilteredReposPublisher.sink { [weak self] repos in
            self?.repos = repos.map(StarredRepoViewModel.init)
        }
        .store(in: &bag)
    }
}
