//
//  TasksList.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/12/22.
//

import SwiftUI

struct TaskListView: View {

    @ObservedObject var timeTracker: TimeTrackerViewModel

    var body: some View {
        List {
            ForEach(self.timeTracker.getTasksList(), id: \.name) { task in
                TaskCell(task: task)
            }
            .onDelete(perform: timeTracker.delete)
        }
        
        .listStyle(PlainListStyle())
    }
}

struct TaskCell: View {

    let task: TaskDisplay

    var body: some View {
        HStack(alignment: .center) {
            
            VStack(alignment: .trailing) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(task.name)
                            .font(.system(size: 16 , weight: .bold))
                            .opacity(0.75)
                    }
                    Spacer()
                }
                .frame(height: 60)
            }
            .cornerRadius(10)
            
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
