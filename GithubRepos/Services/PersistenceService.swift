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
        let StringId = String(id)
        request.predicate = NSPredicate(format: "serverId == %@", StringId)
        request.predicate = NSPredicate(format: "name == %@", name)

        do {
            let count = try context.count(for: request)
            if count > 0 {
                print(">> Count for predicate: \(count)")
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
        stRepo.createdAt = dateFormatter.date(from: repo.createdAt) ?? Date()
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
