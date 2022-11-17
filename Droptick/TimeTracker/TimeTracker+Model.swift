//
//  TimeTracker.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/12/22.
//

import Foundation
import SwiftUI

extension Date {
    var startOfCurrentDay: Date {
        return Calendar.current.startOfDay(for: Date.now)
    }
    var secondsSinceMidnight: Int {
        return Int(self.timeIntervalSince(startOfCurrentDay))
    }
    var minutesSinceMidnight: Int {
        return secondsSinceMidnight / 60
    }
}


struct TimeTracker {
    var tasks: [Task]
    var secondsPassedSinceMidnight: Int
    
    init(tasks: [Task] = [], secondsPassedSinceMidnight: Int = Date().secondsSinceMidnight) {
        self.tasks = tasks
        self.secondsPassedSinceMidnight = secondsPassedSinceMidnight
    }
    
    struct Task {
        let publicID: UUID
        var name: String
        var duration: Int
        let createdAt: Date
        
        init(name: String, duration: Int, createdAt: Date = Date.now, publicID: UUID = UUID()) {
            self.name = name
            self.duration = duration
            self.createdAt = createdAt
            self.publicID = publicID
        }
    }
}
