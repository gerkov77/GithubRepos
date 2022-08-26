//
//  StarredRepo+CoreDataProperties.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 26..
//
//

import Foundation
import CoreData


extension StarredRepo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StarredRepo> {
        return NSFetchRequest<StarredRepo>(entityName: "StarredRepo")
    }

    @NSManaged public var serverId: Int64
    @NSManaged public var name: String
    @NSManaged public var info: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var language: String?
    @NSManaged public var owner: Owner?

}

extension StarredRepo : Identifiable {

}
