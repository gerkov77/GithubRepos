//
//  RepoDetailsViewModel.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 26..
//

import SwiftUI
import Combine

class RepoDetailsViewModel: ObservableObject {
    
    enum State: Comparable, Equatable {
        case idle
        case processing
    }
    
    @Published var repo: Repository?
    @Published var state: State = .idle
    @Published var isStarred: Bool = false {
        didSet {
            print(">> did set is starred: \(isStarred)")
        }
    }
    private(set) var apiService: RepoService = RepoService()
    private(set) var persistenceService: PersistenceService = PersistenceService()
    var bag = Set<AnyCancellable>()
    
    
    init() {}
    
    func fetchRepo(name: String, user: String) {
        guard state == .idle else {
            return
        }
        state = .processing
        Task {
            do {
                try await apiService.fetchRepo(user: user, repo: name)
                await MainActor.run { [weak self] in
                    apiService.$repo.sink { repo in
                        self?.repo = repo
                        self?.checkRepoStarred()
                    }
                    .store(in: &bag)
                    self?.state = .idle
                }
            }
            catch let err {
                print(">> error while fetching repo: \(err.localizedDescription)")
            }
        }
    }
}

extension RepoDetailsViewModel {
    var formattedDate: String  {
        var date = Date()
        if let unWrappedRepo = repo {
            let dateString = unWrappedRepo.createdAt
            date = dateFormatter.date(from: dateString) ?? Date.init(timeIntervalSince1970: 0)
        }
        return  dateFormatter.string(from: date)
    }
}

extension RepoDetailsViewModel {
    func saveToStarredRepos() {
        guard let unwrappedRepo = repo else { return }
        state = .processing
        Task {
            do {
                try  persistenceService.save(repo: unwrappedRepo)
                await MainActor.run { [weak self] in
                    self?.state = .idle
                    checkRepoStarred()
                }
            }
            catch let err as PersistenceService.PersistenceError {
                print("ERROR: \(err.message)")
                
            }
        }
    }
    
    func removeFromStarredRepos() {
       
        state = .processing
        guard let unwrappeRepo = repo else {
            return
        }
        persistenceService.remove(repo: unwrappeRepo)
        DispatchQueue.main.async { [weak self] in
                self?.state = .idle
                self?.isStarred = false
            }
    }
}

extension RepoDetailsViewModel {
    func checkRepoStarred() {
        guard let id = repo?.id,
              let name = repo?.name
        else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            _ =    self.isStarred = self.persistenceService.checkIfItemExist(id: id, name: name)
            self.persistenceService.$currentRepoIsStarred
                .removeDuplicates()
                .sink { result in
                    withAnimation {
                        self.isStarred = result
                    }
                }
                .store(in: &self.bag)
        }
    }
}

