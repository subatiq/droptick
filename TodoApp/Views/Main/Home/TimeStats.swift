//
//  TaskCell.swift
//  TodoApp
//
//  Created by Afees Lawal on 06/08/2020.
//


import SwiftUI


class TimeStatsModel: ObservableObject {
    let workTime: Int = 7 * 60
    let sleepTime: Int = 8 * 60
    let totalTime: Int = 24 * 60
    
    func freeTime() -> Int {
        return totalTime - sleepTime - workTime
    }
}


struct TimeStats: View {
    var timeLeft: TimeStatsModel = TimeStatsModel()
    @State var totalTimeLeft: Int = 24 * 60
    @ObservedObject var viewModel: TaskListViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("DAY")
                Text(String(timeLeft.totalTime))
                Text("|")
                Text("SLEEP")
                Text(String(timeLeft.sleepTime))
                Text("|")
                Text("WORK")
                Text(String(timeLeft.workTime))
            }
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.gray)
            HStack(alignment: .top) {
                Spacer()
                VStack(alignment: .trailing) {
                   
                    Text(String(totalTimeLeft))
                        .font(.system(size: 60, weight: .black))
                    Text("Free minutes left today".uppercased())
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 120)
                }
            }
            .padding()
            .padding(.top, 0)
            .onReceive(viewModel.objectWillChange) { _ in
                self.viewModel.fetchTodos()
                totalTimeLeft = timeLeft.freeTime() - viewModel.totalDuration()
//                print("TRIG")
            }
            .onAppear {
                self.viewModel.fetchTodos()
                totalTimeLeft = timeLeft.freeTime() - viewModel.totalDuration()
            }
        }
        
        
        
    }
}

struct TimeStats_Previews: PreviewProvider {
    static var previews: some View {
        TimeStats(viewModel: TaskListViewModel(dataManager: MockDataManager()))
    }
}
