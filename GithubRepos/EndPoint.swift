//
//  EndPoint.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 24..
//

import Foundation

let token = "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"


struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
//    static func search(matching query: String,
//                       sortedBy sorting: Sorting = .recency) -> Endpoint {
//        return Endpoint(
//            path: "/search/repositories",
//            queryItems: [
//                URLQueryItem(name: "q", value: query),
//                URLQueryItem(name: "sort", value: sorting.rawValue)
//            ]
//        )
//    }
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
