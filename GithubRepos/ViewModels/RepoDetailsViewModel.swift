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

    private(set) var apiService: RepoService = RepoService()
    private(set) var persistenceService: PersistenceService = PersistenceService()

    @Published var repo: Repository?
    @Published var state: State = .idle
    @Published var isStarred: Bool = false {
        didSet {
            print(">> did set is starred: \(isStarred)")
        }
    }

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
                    apiService.$repo
                        .removeDuplicates()
                        .sink { repo in
                            self?.repo = repo
                            self?.checkExists()
                        }
                        .store(in: &bag)
                    self?.state = .idle
                }
            } catch let err {
                print(">> error while fetching repo: \(err.localizedDescription)")
            }
        }
    }
}

extension RepoDetailsViewModel {
    func addRepo() {
        guard let unwrappedRepo = repo else { return }
        state = .processing
        Task {
            do {
                try  persistenceService.save(repo: unwrappedRepo)
                await MainActor.run { [weak self] in
                    self?.state = .idle
                    checkExists()
                }
            } catch let err as PersistenceService.PersistenceError {
                print("ERROR: \(err.message)")
            }
        }
    }
}

extension RepoDetailsViewModel {
    func checkExists() {
        guard let id = repo?.id,
              let name = repo?.name
        else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let checkResult = self.persistenceService.checkIfItemExist(id: id, name: name)
            
            withAnimation {
                self.isStarred = checkResult
            }
        }
    }
}

extension RepoDetailsViewModel {
    var formattedDate: String {
        var date = Date()
        let formatter = DateFormatter()
        
        if let unWrappedRepo = repo {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            formatter.locale = Calendar.current.locale
            let dateString = unWrappedRepo.createdAt
            date = formatter.date(from: dateString) ?? Date.init(timeIntervalSince1970:  0)
            formatter.dateStyle = .medium
        }
        return  formatter.string(from: date)
    }
}
