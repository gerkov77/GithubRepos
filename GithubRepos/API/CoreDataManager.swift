//
//  CoreDataManager.swift
//  GithubRepos
//
//  Created by Gergely Kovacs on 2022. 08. 26..
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    var container: NSPersistentContainer { get }
    var viewContext: NSManagedObjectContext { get }
    func deleteItem<Item: NSManagedObject>(_ repo: Item)
    func getItemById<Item: NSManagedObject>(_ id: NSManagedObjectID, requestedType: Item.Type) -> Item?
    func saveContext()
}

struct CoreDataManager: CoreDataManagerProtocol {

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
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    internal let container: NSPersistentContainer

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
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func deleteItem<Item: NSManagedObject>(_ item: Item) {
        viewContext.delete(item)
        saveContext()
    }

    func getItemById<Item>(_ id: NSManagedObjectID,
                           requestedType: Item.Type) -> Item? where Item : NSManagedObject {
        do {
            return try viewContext.existingObject(with: id) as? Item
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
