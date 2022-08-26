
//  EndpointTests.swift
//  GithubReposTests
//
//  Created by Gergely Kovacs on 2022. 08. 24..
//
@testable import GithubRepos
import XCTest

class EndpointTests: XCTestCase {

    func test_Endpoint_getRepos_ConstructsCorrectUrl() {
        XCTAssertEqual(Endpoint.getRepos(for: "gerkov77", page: 1).url, URL(string:"https://api.github.com/users/gerkov77/repos?page=1&per_page=10"))
    }
}
