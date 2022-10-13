//
//  RepoListViewModel.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 24..
//

import Foundation
import Combine

final class RepoListViewModel: ObservableObject {

    enum State: Comparable {
        case idle
        case loading
        case loadedAll
        case error(String)
    }

    @Published var repos: [Repository] = []
    @Published var state: State = .idle
    @Published var shouldShowNetworkError: Bool = false

    private(set) var apiService: ReposListServiceProtocol = ReposListService()
    private(set) var storageService: PersistenceServiceProtocol = PersistenceService()
    private var bag = Set<AnyCancellable>()

    init() {
        state = .idle
    }

    func fetchRepos(userName: String) {
        guard state == .idle else { return }
        state = .loading
        Task {
            do {
                try await apiService.fetchRepos(for: userName)
                   await fillRepos()
            } catch let err {
             await showError(error: err)
            }
        }
    }

    @MainActor
    func fillRepos() {
        apiService.$repos.sink { [weak self] repos in
            self?.repos = repos
        }
        .store(in: &bag)
        finishedLoading()
    }

    @MainActor
    func finishedLoading() {
        if apiService.hasMoreRepos {
            print(">>has more repos")
            state = .idle
        } else {
            print(">>loaded all repos")
            state = .loadedAll
        }
    }

    @MainActor
    func showError(error: Error) {
            self.state = .error(">>Could not load repos –\(error.localizedDescription)")
            print(error.localizedDescription)
            shouldShowNetworkError = true
    }

    func resetSearch() {
        apiService.resetSearch()
    }
}
