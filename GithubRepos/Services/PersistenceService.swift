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

class StarredRepoPublisher: ObservableObject {
    @Published var repos: [StarredRepo] = []
}

protocol PersistenceServiceProtocol: StarredRepoPublisher {
    var manager: CoreDataManagerProtocol { get }
    func fetchStarredRepos() throws
    func checkIfItemExist(id: Int, name: String) -> Bool
    func save(repo: Repository) throws
    func delete(_ repo: StarredRepoViewModel)
}

class PersistenceService:  StarredRepoPublisher, PersistenceServiceProtocol {

    enum PersistenceError: Error {
        case itemAlreadySaved
        case savingError
        case deleteError
        case itemNotFound

        var message: String {
            switch self {
            case .itemAlreadySaved:
                return "This repo is already starred"
            case .savingError:
                return "There was an error saving the repo"
            case .deleteError:
                return "There was an error deleting this entry"
            case .itemNotFound:
                return "The item to delete was not found"
            }
        }
    }

    var manager: CoreDataManagerProtocol = CoreDataManager.shared
    var bag = Set<AnyCancellable>()
}

extension PersistenceService {
    func fetchStarredRepos() throws {
        let request = StarredRepo.fetchRequest()
        request.sortDescriptors = [
            .init(key: "name",
                  ascending: true,
                  selector: #selector(NSString.caseInsensitiveCompare(_:)))
        ]
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: manager.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        do {
            try frc.performFetch()
            frc.fetchedObjects.publisher.sink { repos in
                self.repos = repos
            }
            .store(in: &self.bag)
        } catch let err as PersistenceService.PersistenceError {
            print(err.message)
            throw PersistenceError.itemNotFound
        }
    }
}

extension PersistenceService {
    func checkIfItemExist(id: Int, name: String) -> Bool {
        let context = manager.viewContext
        let request: NSFetchRequest<StarredRepo> = StarredRepo.fetchRequest()
        request.sortDescriptors =  [
            .init(key: "name",
                  ascending: true,
                  selector: #selector(NSString.caseInsensitiveCompare(_:)))
        ]
        request.fetchLimit =  1
        let stringId = String(id)
        request.predicate = NSPredicate(format: "serverId == %@", stringId)
        request.predicate = NSPredicate(format: "name == %@", name)

        do {
            let count = try context.count(for: request)
            if count > 0 {
                print(">> Count for predicate: \(count)")

                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
}

extension PersistenceService {
    func save(repo: Repository) throws {
        guard checkIfItemExist(id: repo.id, name: repo.name) == false else {
            throw PersistenceError.itemAlreadySaved
        }
        createStarredRepo(repo)
        manager.saveContext()
    }
}

extension PersistenceService {
    func delete(_ repo: StarredRepoViewModel) {
        guard let existingRepo = manager.getItemById(repo.id, requestedType: StarredRepo.self) else {
            return
        }
        manager.deleteItem(existingRepo)
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

extension PersistenceService {
    fileprivate func createOwner(forRepo repo: Repository,
                                 context: NSManagedObjectContext) -> Owner {
        let owner = Owner(context: context)
        owner.login = repo.owner.login
        owner.avatarUrl = repo.owner.avatarUrl
        return owner
    }
}

extension PersistenceService {
    fileprivate func addOwnerToStarredRepo(repo: Repository, stRepo: StarredRepo, context: NSManagedObjectContext) {
        let owner = createOwner(forRepo: repo, context: context)
        owner.addToRepos(stRepo)
        stRepo.owner = owner
    }
}

extension PersistenceService {
    fileprivate func setupStarredRepo(stRepo: StarredRepo,
                                      from repo: Repository,
                                      context: NSManagedObjectContext) {
        stRepo.createdAt = createDate(from: repo.createdAt)
        stRepo.language = repo.language
        stRepo.name = repo.name
        stRepo.info = repo.description
        stRepo.serverId = String(repo.id)
        addOwnerToStarredRepo(repo: repo,
                              stRepo: stRepo,
                              context: context)
    }
}

extension PersistenceService {
    fileprivate func createStarredRepo(_ repo: Repository) {
        let context = manager.container.viewContext
        let stRepo = StarredRepo(context: context)
        setupStarredRepo(stRepo: stRepo,
                         from: repo,
                         context: context)
    }
}
