//
//  Service.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 25..
//

import Foundation

protocol RepoServiceProtocol {
    
    func fetchRepos(for user: String) async throws
    func update()
    func remove()
    func removeAll()
}
