//
//  CoreDataManager.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 26..
//

import Foundation
import CoreData


struct CoreDataManager {
    
    static let shared = CoreDataManager()

    static var preview: CoreDataManager = {
        let result = CoreDataManager(inMemory: true)
        let viewContext = result.container.viewContext
        for num in 0..<10 {
            let newItem = StarredRepo(context: viewContext)
            newItem.createdAt = Date()
            newItem.name = "\(num)"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GithubReposModels")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores(completionHandler: { (_ , error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func deleteRepo(_ repo: StarredRepo) {
        viewContext.delete(repo)
        saveContext()
    }
    
    func getRepoById(_ id: NSManagedObjectID) -> StarredRepo? {
        do {
            return try viewContext.existingObject(with: id) as? StarredRepo
        } catch {
            return nil
        }
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
                viewContext.rollback()
            }
        }
    }
}
