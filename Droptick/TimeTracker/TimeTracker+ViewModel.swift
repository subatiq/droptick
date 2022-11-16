//
//  TimeTracker.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/12/22.
//

import SwiftUI


struct TaskDisplay {
    let name: String
    var duration: Int
    var updatedAt: Date
}


class TimeTrackerViewModel: ObservableObject {
    @Published var model: TimeTracker
    let repository: TimeTrackerRepositoryInterface
    
    init(model: TimeTracker, repo: TimeTrackerRepositoryInterface) {
        self.model = model
        self.repository = repo
        self.model.tasks = self.repository.getAll()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.updateTimePassed()
        }
    }
    
    private func updateTimePassed() {
        self.model.secondsPassedSinceMidnight = Date().secondsSinceMidnight
    }
    
    func getTasksList() -> [TaskDisplay] {
        var displayedTasks = [String : TaskDisplay]()
        for task in self.model.tasks.filter({$0.createdAt.normalize() > Date().startOfCurrentDay.normalize()}) {
            print(task.createdAt)
            if !displayedTasks.contains(where: {$0.key == task.name}) {
                displayedTasks[task.name] = TaskDisplay(name: task.name, duration: Int(task.duration), updatedAt: task.createdAt)
            }
            else {
                let displayedLastUpdate = displayedTasks[task.name]!.updatedAt
                let newUpdate = displayedLastUpdate > task.createdAt ? displayedLastUpdate : task.createdAt
                displayedTasks[task.name]!.duration += task.duration
                displayedTasks[task.name]!.updatedAt = newUpdate
            }
        }
        
        return Array(displayedTasks.values).sorted {$0.updatedAt > $1.updatedAt}
    }
    
    func addTask(name: String, duration: Int) {
        let task = TimeTracker.Task(name: name, duration: duration)
        model.tasks.append(task)
        repository.create(task: task)
    }
    
    func delete(task: TimeTracker.Task) {
        if let index = model.tasks.firstIndex(where: {checkedTask in checkedTask.publicID == task.publicID}) {
            delete(atIndex: IndexSet(integer: index))
        }
    }
    
    func delete(atIndex index: IndexSet) {
        // FIXME: TaskDisplay and Task will handle it differently
        model.tasks.remove(atOffsets: index)
    }
    
    func getTotalTimeUnused() -> Int {
        return self.model.secondsPassedSinceMidnight - self.model.tasks
            .filter{$0.createdAt > Date().startOfCurrentDay}
            .map{$0.duration}.reduce(0, +) * 60
    }
    
}
