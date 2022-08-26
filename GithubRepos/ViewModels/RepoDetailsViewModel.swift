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
    private(set) var apiService: RepoService = RepoService()
    private(set) var storageService: PersistenceService = PersistenceService()
    var bag = Set<AnyCancellable>()
    
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
             date = dateFormatter.date(from: dateString) ?? Date()
        }
        return  dateFormatter.string(from: date)
    }
}

extension RepoDetailsViewModel {
    func saveToStarredRepos() {
        guard let unwrappedRepo = repo else { return }
        storageService.save(repo: unwrappedRepo)
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.locale = Calendar.current.locale
    return  formatter
}()
