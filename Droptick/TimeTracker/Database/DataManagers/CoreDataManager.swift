//
//  TodoDataManager.swift
//  TodoApp
//
//  Created by Afees Lawal on 13/08/2020.
//

import Foundation
import CoreData

final class CoreDataManager {
    private let persistentManager = CoreDataPersistenceManager()

    private func getTodoMO(for task: TimeTracker.Task) -> TaskDB? {
        let predicate = NSPredicate(format: "uuid = %@", task.publicID as CVarArg)
        let result = persistentManager.fetchFirst(TaskDB.self, predicate: predicate)
        switch result {
        case .success(let taskDB):
            return taskDB
        case .failure(_):
            return nil
        }
    }
}

extension CoreDataManager: DataManager {
    func fetchAll() -> [TimeTracker.Task] {
        let result: Result<[TaskDB], Error> = persistentManager.fetch(TaskDB.self, predicate: nil)
        switch result {
        case .success(let taskDB):
            return taskDB.map { $0.toTimeTracker() }
        case .failure(_):
            return []
        }
        
    }

    func add(task: TimeTracker.Task) {
        let entity =  NSEntityDescription.entity(forEntityName: "TaskDB",
                                                 in: persistentManager.context)!
        let newTask = TaskDB(entity: entity, insertInto: persistentManager.context)
        newTask.publicID = UUID()
        newTask.name = newTask.name
        newTask.duration = Int64(task.duration)
        newTask.createdAt = task.createdAt
        persistentManager.create(newTask)
    }
    
    func update(task: TimeTracker.Task, originalTask: TimeTracker.Task) {
        guard let taskDB = getTodoMO(for: originalTask) else { return }
        taskDB.duration += Int64(task.duration)
        persistentManager.update(taskDB)
    }
    
    func delete(task: TimeTracker.Task) {
        guard let todoMO = getTodoMO(for: task) else { return }
        persistentManager.delete(todoMO)
    }
}
