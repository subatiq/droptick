//
//  DataManager.swift
//  TodoApp
//
//  Created by Afees Lawal on 05/08/2020.
//

import Foundation

protocol DataManager {
    func fetchAll() -> [TimeTracker.Task]
    func add(task: TimeTracker.Task)
    func update(task: TimeTracker.Task, originalTask: TimeTracker.Task)
    func delete(task: TimeTracker.Task)
}
