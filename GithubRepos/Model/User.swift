//
//  User.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 24..
//

import Foundation

struct User: Identifiable, Codable {
    let id: Int
    let login: String
    let avatarUrl: String
    let publicRepos: Int?
}
