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
    
    func getSimpleDispleyTasksList(startDay start: Date, endDay end: Date) -> [TaskDisplay] {
        var displayedTasks = [String : TaskDisplay]()
        for task in self.model.tasks.filter({
            $0.createdAt.normalize() > start.startOfCurrentDay.normalize() && $0.createdAt.normalize() < end.endOfCurrentDay.normalize()
            
        }) {
            let taskName = task.name.trimmingCharacters(in: .whitespacesAndNewlines)
            if !displayedTasks.contains(where: {$0.key == taskName}) {
                displayedTasks[taskName.trimmingCharacters(in: .whitespacesAndNewlines)] = TaskDisplay(name: taskName, duration: Int(task.duration), updatedAt: task.createdAt)
            }
            else {
                let displayedLastUpdate = displayedTasks[taskName]!.updatedAt
                let newUpdate = displayedLastUpdate > task.createdAt ? displayedLastUpdate : task.createdAt
                displayedTasks[taskName]!.duration += task.duration
                displayedTasks[taskName]!.updatedAt = newUpdate
            }
        }
        
        return Array(displayedTasks.values).sorted {$0.updatedAt > $1.updatedAt}
    }
    
    func getSimpleDisplayTasksList() -> [TaskDisplay] {
        getSimpleDispleyTasksList(startDay: Date.now, endDay: Date.now)
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
        let task = TimeTracker.Task(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            duration: duration
        )
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
