//
//  Owner+CoreDataProperties.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 26..
//
//

import Foundation
import CoreData


extension Owner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Owner> {
        return NSFetchRequest<Owner>(entityName: "Owner")
    }

    @NSManaged public var login: String?
    @NSManaged public var avatarUrl: String?
    @NSManaged public var repos: NSSet?

}

// MARK: Generated accessors for repos
extension Owner {

    @objc(addReposObject:)
    @NSManaged public func addToRepos(_ value: StarredRepo)

    @objc(removeReposObject:)
    @NSManaged public func removeFromRepos(_ value: StarredRepo)

    @objc(addRepos:)
    @NSManaged public func addToRepos(_ values: NSSet)

    @objc(removeRepos:)
    @NSManaged public func removeFromRepos(_ values: NSSet)

}

extension Owner : Identifiable {

}
