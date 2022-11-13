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

    init() {
        self.currentRoute = Route.newTask
        self.timeTracker = TimeTrackerViewModel(model: TimeTracker(tasks: []), repo: TimeTrackerRepository(context: PersistenceController.shared.container.viewContext))
    }
    var body: some View {
        VStack {
            HStack {
                Spacer()
                TimeStats(secondsPassed: timeTracker.getTotalTimeUnused())
            }.padding(20)
            switch currentRoute {
            case .home:
                VStack {
                    TaskListView(timeTracker: timeTracker)
                    MainTabBar(currentRoute: $currentRoute)
                        .padding(20)
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
