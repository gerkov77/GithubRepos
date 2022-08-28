//
//  StarredRepoViewModel.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 28..
//

import CoreData

struct StarredRepoViewModel: Hashable {
    let repo: StarredRepo

    var id: NSManagedObjectID {
        return repo.objectID
    }

    var name: String {
        return repo.name
    }

    var avatarUrl: String {
        return repo.owner?.avatarUrl ?? ""
    }

    var ownerName: String {
        return repo.owner?.login ?? "Could not fetch username"
    }
}
