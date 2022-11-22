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
        ScrollView {
            VStack {
                ForEach(self.timeTracker.getSimpleDisplayTasksList(), id: \.name) { task in
                    TaskCell(task: task, timeTracker: timeTracker)
                }
            }
        }
    }
}

struct TaskCell: View {

    let task: TaskDisplay
    let timeTracker: TimeTrackerViewModel
    @State var showingStats: Bool = false

    var body: some View {
        Button {showingStats.toggle()}
            
    label: {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray.opacity(0.12))
                .cornerRadius(20)
            
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
                .cornerRadius(20)
                
                HStack {
                    Image(systemName: "hourglass.bottomhalf.filled")
                        .font(.system(size: 14, weight: .bold))
                    Text(String(format: "%02d:%02d", convertToHours(minutes:task.duration), convertToMinutes(minutes: task.duration)))
                    
                }
                .font(.system(size: 16, weight: .bold))
                
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        }
        .foregroundColor(Color.primary)
        
    }
    .sheet(isPresented: $showingStats) {
        EditTask(task: task, timeTracker: timeTracker)
    }
        
    }
}
