//
//  TaskDB+Extension.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/13/22.
//

import Foundation


extension TaskDB {
    func toDisplay() -> TaskDisplay {
        return TaskDisplay(name: self.name!, duration: Int(self.duration))
    }
    
    func toTimeTracker() -> TimeTracker.Task {
        return TimeTracker.Task(name: self.name!, duration: Int(self.duration))
    }
    
    func from(task: TimeTracker.Task) -> TaskDB {
        let taskDB = TaskDB()
        taskDB.publicID = task.publicID
        taskDB.name = task.name
        taskDB.duration = Int64(task.duration)
        taskDB.createdAt = task.createdAt
        
        return taskDB
    }
}
