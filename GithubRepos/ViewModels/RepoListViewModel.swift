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
    @Published var state: State = .idle {
        didSet {
            print("state is now \(state)")
        }
    }
    
    private var apiService = ReposListService()
    private var storageService = PersistenceService()
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
                await MainActor.run { [weak self] in
                    apiService.$repos.sink { repos in
                        self?.repos = repos
                    }
                    .store(in: &bag)
                    finishedLoading()
                }
            }
            catch let err {
                await MainActor.run { [weak self] in
                    self?.state = .error(">>Could not load repos –\(err.localizedDescription)")
                    print(err.localizedDescription)
                    }
            }
        }
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
    
    func resetSearch() {
        apiService.hasMoreRepos = true
        apiService.page = 1
    }
}


extension RepoListViewModel {
    
    func saveRepo(repo: Repository) {
        
    }
}
