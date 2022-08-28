//
//  PersistenceService.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 26..
//

import UIKit
import CoreData
import SwiftUI

class PersistenceService: ObservableObject {
    
    @Published var repos: [StarredRepo] = []
    @Published var currentRepoIsStarred: Bool = false
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
            try frc.performFetch()
            
            DispatchQueue.main.async {
                [weak self] in
                if let fetchedRepos =  frc.fetchedObjects {
                    self?.repos = fetchedRepos
                }
            }
        }
        
        catch let err {
            print(err.localizedDescription)
        }
    }
    
    func checkIfItemExist(id: Int, name: String) -> Bool {

        let context = manager.container.viewContext
        let request = StarredRepo.fetchRequest()
        request.fetchLimit =  1
        let stringId = String(id)
        request.predicate = NSPredicate(format: "serverId == %@", stringId)
        request.predicate = NSPredicate(format: "name == %@", name)

        do {
            let count = try context.count(for: request)
            if count > 0 {
                print(">> Count for predicate: \(count)")
                DispatchQueue.main.async {
                    [weak self] in
                    self?.currentRepoIsStarred = true
                }
                return true
            }else {
                return false
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func save(repo: Repository) throws {
        guard checkIfItemExist(id: repo.id, name: repo.name) == false else {
            print(">>Already starred!")
        
            throw PersistenceError.itemAlreadySaved
        }
        
        let context = manager.container.viewContext
        let stRepo = StarredRepo(context: context)

        let owner = Owner(context: context)
        owner.login = repo.owner.login
        owner.avatarUrl = repo.owner.avatarUrl
        owner.addToRepos(stRepo)
        stRepo.createdAt = dateFormatter.date(from: repo.createdAt) ?? Date.init(timeIntervalSince1970: 0)
        stRepo.language = repo.language
        stRepo.owner = owner
        stRepo.name = repo.name
        stRepo.info = repo.description
        stRepo.serverId = String(repo.id)
        
        do {
            try context.save()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func fetchPreviewRepos() {
        
    }
    
    enum PersistenceError: Error {
        case itemAlreadySaved
        case savingError
        
        var message: String {
            switch self {
            case .itemAlreadySaved:
                return "This repo is already starred"
            case .savingError:
                return "There was an error saving the repo"
            }
        }
    }
}

extension PersistenceService {
    func remove(repo: Repository) {
        let context = manager.container.viewContext
        let request = StarredRepo.fetchRequest()
        request.fetchLimit =  1
        let stringId = String(repo.id)
        request.predicate = NSPredicate(format: "serverId == %@", stringId)
        request.predicate = NSPredicate(format: "name == %@", repo.name)
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: manager.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        guard let starred = self.repos.first(where: { starred in
                        starred.serverId == String(repo.id) &&
                        starred.name == repo.name
                    }),
            let index = frc.indexPath(forObject: starred) else { return }

        
     
        let owner = Owner(context: context)
        owner.removeFromRepos(starred)
        context.delete(starred)
//        let reposIndex = repos.firstIndex(of: starred)
        repos.remove(at: index.item)
        
        do {
            try context.save()
        }
        catch let err {
            print(err.localizedDescription)
        }
    }
}
