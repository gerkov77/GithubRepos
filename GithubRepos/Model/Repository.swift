//
//  Repository.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 22..
//

import Foundation

struct Repository: Identifiable, Codable {
  
    let id: Int
    let name: String
    let owner: User
    let description: String?
    let createdAt: String
    let language: String?
    
   
}

extension Repository: Equatable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Repository : Hashable {
    func hash(into hasher: inout Hasher) {}
}
