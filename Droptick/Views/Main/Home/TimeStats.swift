//
//  TaskCell.swift
//  TodoApp
//
//  Created by Afees Lawal on 06/08/2020.
//


import SwiftUI


class TimeStatsModel: ObservableObject {
    @Published var sleepTime: Int = UserDefaults.standard.integer(forKey: "SleepToday")
}


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


struct TimeStats: View {
    @ObservedObject var timeLeft: TimeStatsModel = TimeStatsModel()
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    @State var secondsLeft: Int = Date().secondsSinceMidnight - 60 * Date().minutesSinceMidnight
    @State var minutesToday = Date().minutesSinceMidnight
    @State var totalTimePassed: Int = Date().minutesSinceMidnight
    
    @ObservedObject var viewModel: TaskListViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
//                    Text("Left today".uppercased())
//                        .font(.system(size: 14, weight: .bold))
//                        .foregroundColor(.gray)
//                    Text("\(minutesToTimeFormat(minutes: 1440 - minutesToday))")
//                        .font(.system(size: 20, weight: .bold))
//                        .padding(.bottom, 5)
                    Text("Sleep time".uppercased())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                    Text(minutesToTimeFormat(minutes:timeLeft.sleepTime))
                        .font(.system(size: 24, weight: .bold))
                    
                }
                .multilineTextAlignment(.leading)
                .padding(.leading, 15)
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Time untracked".uppercased())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                    HStack(alignment: .bottom) {
                        Text(minutesToTimeFormat(minutes: totalTimePassed))
                            .font(.system(size: 50, weight: .black))
                    }
                    Text("\(totalTimePassed >= 0 ? String(format: ":%02d",secondsLeft) : "")")
                        .font(.system(size: 30, weight: .black))
                        .foregroundColor(.gray.opacity(0.5))
                    
                }
                .multilineTextAlignment(.trailing)
                .padding(.trailing, 20)

            }
            .onReceive(viewModel.objectWillChange) { _ in
                self.viewModel.fetchTodos()
                totalTimePassed = Date().minutesSinceMidnight - viewModel.totalDuration() - timeLeft.sleepTime
            }
            .onAppear {
                self.viewModel.fetchTodos()
                totalTimePassed = Date().minutesSinceMidnight - viewModel.totalDuration() - timeLeft.sleepTime
            }
            .onReceive(timer) {date in
                for todo in self.viewModel.todos() {
                    if todo.createdAt < Date.now.startOfCurrentDay {
                        viewModel.delete(todo: todo)
                    }
                }
                
                _ = readSleep(from: Calendar(identifier: .iso8601).startOfDay(for: Date.now), to: Date.now)
                timeLeft.sleepTime = UserDefaults.standard.integer(forKey: "SleepToday")
                
                self.viewModel.fetchTodos()
                secondsLeft = Date().secondsSinceMidnight - 60 * Date().minutesSinceMidnight
                minutesToday = Date().minutesSinceMidnight
                totalTimePassed = Date().minutesSinceMidnight - viewModel.totalDuration() - timeLeft.sleepTime
                
                UserDefaults(suiteName: "group.com.subatiq.sandleak")?.set(viewModel.totalDuration(), forKey: "totalTimeUsed")
                UserDefaults(suiteName: "group.com.subatiq.sandleak")?.set(timeLeft.sleepTime, forKey: "sleepTime")
            }
        }
        
        
        
    }
}

func minutesToTimeFormat(minutes: Int) -> String {
    guard minutes >= 0 else {return "00:00"}
    let hours = minutes / 60
    return String(format: "%02d", hours) + ":" + String(format: "%02d", minutes - hours * 60)
}

struct TimeStats_Previews: PreviewProvider {
    static var previews: some View {
        TimeStats(viewModel: TaskListViewModel(dataManager: MockDataManager()))
    }
}
