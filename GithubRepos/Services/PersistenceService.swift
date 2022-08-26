//
//  PersistenceService.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 26..
//

import UIKit
import CoreData

class PersistenceService: ObservableObject {
    
    @Published var repos: [StarredRepo] = []
    
    let manager = CoreDataManager.shared
    
    func fetchStarredRepos() {
        let request = StarredRepo.fetchRequest()
        request.sortDescriptors = [.init(key: "createdAt", ascending: false)]
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: manager.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        do {
            defer {
                if let objects = frc.fetchedObjects {
                    repos = objects
                }
                 }
        
            try frc.performFetch()
        }
        catch let err {
            print(err.localizedDescription)
        }
    }
    
    func save(repo: Repository) {
        let context = manager.container.viewContext
        let stRepo = StarredRepo(context: context)

        let owner = Owner(context: context)
        owner.login = repo.owner.login
        owner.avatarUrl = repo.owner.avatarUrl
        owner.addToRepos(stRepo)
        stRepo.createdAt = dateFormatter.date(from: repo.createdAt) ?? Date()
        stRepo.language = repo.language
        stRepo.owner = owner
        stRepo.name = repo.name
        stRepo.info = repo.description
        stRepo.serverId = Int64(repo.id)
        
        do {
            try context.save()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func fetchPreviewRepos() {
        
    }
}
