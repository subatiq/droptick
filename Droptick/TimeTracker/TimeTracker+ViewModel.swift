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
    
    func getSimpleDisplayTasksList() -> [TaskDisplay] {
        var displayedTasks = [String : TaskDisplay]()
        for task in self.model.tasks.filter({$0.createdAt.normalize() > Date().startOfCurrentDay.normalize()}) {
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
    
    func getAllTasks(for day: Date) -> [TimeTracker.Task] {
        return model.tasks.filter{
            $0.createdAt.normalize() > day.startOfCurrentDay.normalize() &&
            $0.createdAt.normalize() < day.endOfCurrentDay.normalize()
        }.sorted {
            $0.createdAt > $1.createdAt
        }
    }
    
    func addTask(name: String, duration: Int) {
        let task = TimeTracker.Task(name: name, duration: duration)
        model.tasks.append(task)
        repository.create(task: task)
    }
    
    func delete(task: TimeTracker.Task) {
        repository.delete(task: task)
        guard let index = model.tasks.firstIndex(where: {$0.publicID == task.publicID}) else {
            return
        }
        model.tasks.remove(at: index)
    }
    
    func getTotalTimeUntracked() -> Int {
        return self.model.secondsPassedSinceMidnight - self.model.tasks
            .filter{$0.createdAt > Date().startOfCurrentDay}
            .map{$0.duration}.reduce(0, +) * 60
    }
    
}
