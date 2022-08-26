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
}

