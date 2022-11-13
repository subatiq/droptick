//
//  TimeTracker+Repository.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/14/22.
//

import Foundation
import CoreData


protocol Repository {
    /// The entity managed by the repository.
    associatedtype Entity

    /// Gets an array of entities.
    /// - Parameters:
    ///   - predicate: The predicate to be used for fetching the entities.
    ///   - sortDescriptors: The sort descriptors used for sorting the returned array of entities.
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error>

    /// Creates an entity.
    func create() -> Result<Entity, Error>

    /// Deletes an entity.
    /// - Parameter entity: The entity to be deleted.
    func delete(entity: Entity) -> Result<Bool, Error>
}


/// Enum for CoreData related errors
enum CoreDataError: Error {
    case invalidManagedObjectType
}

/// Generic class for handling NSManagedObject subclasses.
class CoreDataRepository<T: NSManagedObject>: Repository {
    typealias Entity = T

    /// The NSManagedObjectContext instance to be used for performing the operations.
    private let managedObjectContext: NSManagedObjectContext

    /// Designated initializer.
    /// - Parameter managedObjectContext: The NSManagedObjectContext instance to be used for performing the operations.
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    /// Gets an array of NSManagedObject entities.
    /// - Parameters:
    ///   - predicate: The predicate to be used for fetching the entities.
    ///   - sortDescriptors: The sort descriptors used for sorting the returned array of entities.
    /// - Returns: A result consisting of either an array of NSManagedObject entities or an Error.
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error> {
        // Create a fetch request for the associated NSManagedObjectContext type.
        let fetchRequest = Entity.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            // Perform the fetch request
            if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [Entity] {
                return .success(fetchResults)
            } else {
                return .failure(CoreDataError.invalidManagedObjectType)
            }
        } catch {
            return .failure(error)
        }
    }

    /// Creates a NSManagedObject entity.
    /// - Returns: A result consisting of either a NSManagedObject entity or an Error.
    func create() -> Result<Entity, Error> {
        let className = String(describing: Entity.self)
        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className, into: managedObjectContext) as? Entity else {
            return .failure(CoreDataError.invalidManagedObjectType)
        }
        return .success(managedObject)
    }

    /// Deletes a NSManagedObject entity.
    /// - Parameter entity: The NSManagedObject to be deleted.
    /// - Returns: A result consisting of either a Bool set to true or an Error.
    func delete(entity: Entity) -> Result<Bool, Error> {
        managedObjectContext.delete(entity)
        return .success(true)
    }
    
    func save() {
        try? self.managedObjectContext.save()
    }
}
