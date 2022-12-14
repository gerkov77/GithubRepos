//
//  EndPoint.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 24..
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    static func getRepos(for user: String, page: Int) -> Endpoint {
        return Endpoint(
            path: "/users/\(user)/repos", queryItems: [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
            ])
    }

    static func getRepo(user: String, repo: String) -> Endpoint {
        return Endpoint(
            path: "/repos/\(user)/\(repo)", queryItems: [])
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
}

enum Sorting: String {
    case numberOfStars = "stars"
    case numberOfForks = "forks"
    case recency = "updated"
}
