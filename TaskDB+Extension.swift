//
//  TaskDB+Extension.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/13/22.
//

import Foundation


extension TaskDB {
    func toTimeTracker() -> TimeTracker.Task {
        return TimeTracker.Task(name: self.name!, duration: Int(self.duration), createdAt: self.createdAt!, publicID: self.publicID!)
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
