import Foundation
import CoreData


protocol TimeTrackerRepositoryInterface {
    func getAll() -> [TimeTracker.Task]
    func create(task: TimeTracker.Task)
}

class TimeTrackerRepository {
    private let repository: CoreDataRepository<TaskDB>

    /// Designated initializer
    /// - Parameter context: The context used for storing and quering Core Data.
    init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<TaskDB>(managedObjectContext: context)
    }
}

extension TimeTrackerRepository: TimeTrackerRepositoryInterface {
    @discardableResult func getAll() -> [TimeTracker.Task] {
        let result = repository.get(predicate: nil, sortDescriptors: nil)
        switch result {
        case .success(let tasksDB):
            // Transform the NSManagedObject objects to domain objects
            let tasks = tasksDB.map { taskDB -> TimeTracker.Task in
                return taskDB.toTimeTracker()
            }
            
            return tasks
        case .failure(let error):
            // FIXME: Can be a source of unhandled errors
            return [TimeTracker.Task(name: error.localizedDescription, duration: 100)]
        }
    }

    func create(task: TimeTracker.Task) {
        let result = repository.create()
        switch result {
        case .success(let taskDB):
            taskDB.publicID = task.publicID
            taskDB.name = task.name
            taskDB.duration = Int64(task.duration)
            taskDB.createdAt = task.createdAt
            
            self.repository.save()
            
        case .failure(_):
            return
        }
    }
    
}
