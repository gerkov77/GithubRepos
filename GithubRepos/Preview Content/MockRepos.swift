//
//  MockRepos.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 22..
//

import Foundation

extension Repository {
    static let allMockRepos: [Repository] = {
        var all = [Repository]()
        
        (0..<100).forEach {
            all.append(Repository(id: $0, name: "repo-\($0)", owner: User(id: 1, login: "myLogin", avatarUrl: "https://avatars.githubusercontent.com/u/190200?v=4", publicRepos: 100), description: "Long long long story", createdAt: "sdfsdfsdfsf", language: "Swift"))
        }
        return all
    }()
}
