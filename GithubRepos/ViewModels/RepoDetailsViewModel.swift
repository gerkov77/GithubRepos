//
//  RepoDetailsViewModel.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 26..
//

import SwiftUI
import Combine

class RepoDetailsViewModel: ObservableObject {
    
    @Published var repo: Repository?
    let service: RepoService = RepoService()
    var bag = Set<AnyCancellable>()
    
    func fetchRepo(name: String, user: String) {
        Task {
            do {
             try await service.fetchRepo(user: user, repo: name)
                await MainActor.run { [weak self] in
                    service.$repo.sink { repo in
                        self?.repo = repo
                    }
                    .store(in: &bag)
                }
            }
            catch let err {
                print(">> error while fetching repo: \(err.localizedDescription)")
            }
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Calendar.current.locale
        return  formatter
    }()
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
