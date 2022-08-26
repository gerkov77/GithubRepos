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
    var service = ReposListService()
    var bag = Set<AnyCancellable>()
    
    init() {
        state = .idle
    }
    
    func fetchRepos(userName: String) {
        guard state == .idle else { return }
        state = .loading
        Task {
            do {
                try await service.fetchRepos(for: userName)
                await MainActor.run { [weak self] in
                    service.$repos.sink { repos in
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
        if service.hasMoreRepos {
            print(">>has more repos")
            state = .idle
        } else {
            print(">>loaded all repos")
            state = .loadedAll
        }
    }
    
    func resetSearch() {
        service.hasMoreRepos = true
        service.page = 1
    }
}
