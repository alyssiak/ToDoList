//
//  CoreDataStack.swift
//  ToDoList
//
//  Created by Alice Kamyshenko on 26.09.2025.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    private let inMemory: Bool
    init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
       
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }
        
        if let description = container.persistentStoreDescriptions.first {
            description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
            description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? { fatalError("Unresolved error \(error), \(error.userInfo)") }
            }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    func backgroundContext() -> NSManagedObjectContext  {
        let ctx = persistentContainer.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return ctx
    }
    
    func save(_ context: NSManagedObjectContext? = nil) throws {
        let ctx = context ?? viewContext
        var caughtError: Error?
        ctx.performAndWait {
            if ctx.hasChanges {
                do {
                    try ctx.save()
                }
                catch {
                    caughtError = error
                }
            }
        }
        if let e = caughtError { throw e }
    }
    
}
