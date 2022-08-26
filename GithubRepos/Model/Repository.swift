//
//  Repository.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 22..
//

import Foundation

struct Repository: Identifiable, Codable, Equatable, Hashable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let name: String
    let owner: User
    
    func hash(into hasher: inout Hasher) {}
}

