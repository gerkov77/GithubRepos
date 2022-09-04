//
//  ApiManagerProtocol.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 09. 04..
//

import Foundation

protocol ApiManagerProtocol {
    func fetchItem<Item: Codable>(endpoint: Endpoint, requestedType: Item.Type) async throws -> Item
    func fetchItems<Item: Codable>(endpoint: Endpoint, requestedType: [Item.Type]) async throws -> [Item]
}
