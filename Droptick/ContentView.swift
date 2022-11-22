//
//  ContentView.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/12/22.
//

import SwiftUI
import CoreData


enum Route {
    case home, newTask
}


struct ContentView: View {
    @ObservedObject var timeTracker: TimeTrackerViewModel
    @State var currentRoute: Route = .newTask
    @State private var showFullList: Bool = false
    @State private var showingStats: Bool = false

    init() {
        self.currentRoute = Route.newTask
        self.timeTracker = TimeTrackerViewModel(model: TimeTracker(tasks: []), repo: TimeTrackerRepository(context: PersistenceController.shared.container.viewContext))
    }
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack {
                    StatsButton {showingStats.toggle()}
                        .sheet(isPresented: $showingStats) {
                            StatisticsView(timeTracker: timeTracker)
                        }
                }
                Spacer()
                TimeStats(secondsPassed: timeTracker.getTotalTimeUntracked())
                    .opacity(showFullList ? 0.5 : 1)
            }.padding(20)
            switch currentRoute {
            case .home:
                VStack {
//                    MenuPanel(timeTracker: timeTracker, fullListShown: $showFullList)
//                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    if !showFullList {
                        TaskListView(timeTracker: timeTracker)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        MainTabBar(currentRoute: $currentRoute)
                            .padding(20)
                    }
                    else {
                        FullTaskListView(timeTracker: timeTracker)
                    }

                }
            case .newTask:
                CreateTask(currentRoute: $currentRoute, timeTracker: timeTracker)
            }
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
    }
}
