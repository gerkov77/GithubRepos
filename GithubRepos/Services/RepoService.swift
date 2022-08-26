//
//  RepoService.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 25..
//

import Foundation

class RepoService: ObservableObject {
    
    @Published var repo: Repository?
    var api: APIManager =  APIManager.shared
    
    func fetchRepo(user: String, repo: String) {
        Task {
            do {
                let repo =  try await api.fetchRepo(endpoint: .getRepo(user: user, repo: repo))
            
                await MainActor.run(body: { [weak self] in 
                    self?.repo = repo
                })
            }
            catch let err  {
                print(err.localizedDescription)
            }
        }
    }
}
