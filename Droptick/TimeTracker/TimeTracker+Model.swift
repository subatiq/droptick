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
    var secondsPassedSinceMidnight: Int = Date().secondsSinceMidnight
    
    struct Task {
        let publicID: UUID = UUID()
        var name: String
        var duration: Int
        let createdAt: Date = Date.now
    }
}
