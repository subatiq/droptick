//
//  TasksList.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/18/22.
//

import SwiftUI

struct FullTaskListView: View {

    @ObservedObject var timeTracker: TimeTrackerViewModel

    var body: some View {
        List {
            ForEach(self.timeTracker.getAllTasks(for: Date.now), id: \.publicID) { task in
                FullTaskCell(task: task)
            }
            .onDelete{offsets in
                for index in offsets {
                    let task = self.timeTracker.getAllTasks(for: Date.now)[index]
                    timeTracker.delete(task: task)
                    
                }
                
            }
        }
        
        .listStyle(PlainListStyle())
    }
}

struct FullTaskCell: View {

    let task: TimeTracker.Task

    var body: some View {
        HStack(alignment: .center) {
            
            VStack(alignment: .trailing) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(task.name)
                            .font(.system(size: 16 , weight: .bold))
                            .opacity(0.85)
                        Text("Created at \(task.createdAt.normalize().formatted())")
                            .font(.system(size: 12))
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
            .font(.system(size: 16, weight: .bold))
            
        }
        
    }
}
