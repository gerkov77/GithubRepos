//
//  PersistenceService.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 26..
//

import UIKit
import CoreData
import SwiftUI
import Combine

class PersistenceService: ObservableObject {
    
    @Published var repos: [StarredRepo] = []
    @Published var currentRepoIsStarred: Bool = false
    let manager = CoreDataManager.shared
    
    var bag = Set<AnyCancellable>()
    
    func fetchStarredRepos() {
        let request = StarredRepo.fetchRequest()
            request.sortDescriptors = [.init(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: manager.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        do {
            try frc.performFetch()
            
                 frc.fetchedObjects.publisher.sink { repos in
                    self.repos = repos
                }
                 .store(in: &self.bag)
            
        
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
        stRepo.createdAt = createDate(from: repo.createdAt)
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
        
     fetchStarredRepos()
        print(">>repos in remove: \(repos)")
        guard let starred = self.repos.first(where: { starred in
                        starred.serverId == String(repo.id) &&
                        starred.name == repo.name
        }) else { return }
        guard let index = repos.firstIndex(of: starred) else { return}

        
     
        let owner = Owner(context: context)
        owner.removeFromRepos(starred)
        context.delete(starred)
//        let reposIndex = repos.firstIndex(of: starred)
        DispatchQueue.main.async {
            [weak self] in
            self?.repos.remove(at: index)
        }
        
        do {
            try context.save()
        }
        catch let err {
            print(err.localizedDescription)
        }
    }
}

extension PersistenceService {
    func createDate(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Calendar.current.locale
     
        let date = formatter.date(from: string) ?? Date.init(timeIntervalSince1970:  0)
       return date
    }
    
}
