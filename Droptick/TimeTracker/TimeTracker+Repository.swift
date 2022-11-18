import Foundation
import CoreData


protocol TimeTrackerRepositoryInterface {
    func getAll() -> [TimeTracker.Task]
    func create(task: TimeTracker.Task)
    func delete(task: TimeTracker.Task)
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
    private func getAllRaw() -> [TaskDB] {
        let result = repository.get(predicate: nil, sortDescriptors: nil)
        switch result {
        case .success(let tasksDB):
            // Transform the NSManagedObject objects to domain objects
            return tasksDB
        case .failure(let error):
            // FIXME: Can be a source of unhandled errors
            print(error)
            return []
        }
    }
    
    @discardableResult func getAll() -> [TimeTracker.Task] {
        return self.getAllRaw().map { taskDB -> TimeTracker.Task in
            return taskDB.toTimeTracker()
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
    
    func delete(task: TimeTracker.Task) {
        let tasks = repository.get(predicate: nil, sortDescriptors: nil)
        switch tasks {
        case .success(let fetched):
            guard let taskToDelete = fetched.first(where: {$0.publicID == task.publicID}) else {
                return
            }
            print(taskToDelete)
            switch repository.delete(entity: taskToDelete) {
            case .success(_):
                repository.save()
                return
            case .failure(let err):
                print("Error deleting \(err)")
            }
        case .failure(_):
            print("Failure 10239")
            return
        }
    }
}


class FakeTimeTrackerRepository: TimeTrackerRepositoryInterface {
    var tasks: [TimeTracker.Task ] = []
    
    func getAll() -> [TimeTracker.Task] {
        return self.tasks
    }
    
    func create(task: TimeTracker.Task) {
        tasks.append(task)
    }
    
    func delete(task: TimeTracker.Task) {
        guard let index = tasks.firstIndex(where: {$0.publicID == task.publicID}) else {
            return
        }
        tasks.remove(at: index)
    }
}
