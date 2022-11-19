//
//  StatisticsView.swift
//  Droptick
//
//  Created by Владимир Семенов on 9/24/22.
//

import Foundation
import SwiftUI


extension Date {
    static var yesterday: Date { return Date().dayBefore }
    var dayBefore: Date {
        return Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -1, to: noon)!)
    }
    
    var weekBefore: Date {
        return Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -7, to: noon)!)
    }
    
    var monthBefore: Date {
        return Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .month, value: -1, to: noon)!)
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}


struct StatisticsView: View {
    var timeTracker: TimeTrackerViewModel
    var intervalTypes = ["Yesterday", "Week", "Month", "Custom"]
    @State var startDate = Date().weekBefore
    @State var endDate = Date().startOfCurrentDay
    @State var selection = 0
    let colors: [Color] = [.chart1, .chart2, .chart3, .chart4, .chart5, .gray.opacity(0.5)]

    @State private var selectedInterval = 0
    
    func sortedTodos(start: Date, end: Date) -> [TaskDisplay] {
        let todos = timeTracker.getSimpleDispleyTasksList(startDay: start, endDay: end)
        return todos.sorted{$0.duration > $1.duration}
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Total tracked time")
                .font(.system(size: 22, weight: .bold))
                .padding(.top, 20)
            PieChartView(
                values: sortedTodos(
                    start: startDate,
                    end: endDate
                )
                .map{Double($0.duration) / Double(sortedTodos(start: startDate, end: endDate).map{$0.duration}.reduce(0, +))}
            )
            if sortedTodos(start: startDate, end: endDate).count > 0 {
                HStack {
                    DatePicker("", selection: $startDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .clipped()
                        .labelsHidden()
                    Text("-")
                    DatePicker("", selection: $endDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .clipped()
                        .labelsHidden()
                }
                List {
                    ForEach(Array(zip(
                        sortedTodos(start: startDate, end: endDate).indices,
                        sortedTodos(start: startDate, end: endDate)
                    )), id: \.0) {i, task in
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(i < 5 ? colors[i] : colors[5])
                            StatsTaskCell(task: task, totalTimeTrackedForInterval: sortedTodos(start: startDate, end: endDate).map{$0.duration}.reduce(0, +))
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            else {
                //NoTaskView()
            }
        }
       
    }
    
    func minutesBetween(start: Date, end: Date) -> Int {
        return Int(end.timeIntervalSince(start) / 60)
    }
}



struct StatsTaskCell: View {

    let task: TaskDisplay
    let totalTimeTrackedForInterval: Int
    
    init(task: TaskDisplay, totalTimeTrackedForInterval: Int) {
        self.task = task
        self.totalTimeTrackedForInterval = totalTimeTrackedForInterval
    }

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .trailing) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(task.name)
                            .font(.system(size: 18 , weight: .bold))
                    }
                    Spacer()
                }
                .frame(height: 60)
            }
            .cornerRadius(10)
            VStack(alignment: .trailing) {
                Text("\(Int(Double(task.duration) * 100 / Double(totalTimeTrackedForInterval)))%")
                    .font(.system(size: 18, weight: .bold))
                HStack {
                    Image(systemName: "hourglass.bottomhalf.filled")
                        .font(.system(size: 14, weight: .bold))
                    Text(String(format: "%02d:%02d", convertToHours(minutes:task.duration), convertToMinutes(minutes: task.duration)))
                    
                }
                .foregroundColor(.orange)
                .font(.system(size: 16, weight: .bold))
            }
        }
        
    }
}
