//
//  MainView.swift
//  TodoApp
//
//  Created by Afees Lawal on 04/08/2020.
//

import SwiftUI
import HealthKit

func requestSleepAuthorization() {
    let healthStore = HKHealthStore()
    
    if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
        let setType = Set<HKSampleType>(arrayLiteral: sleepType)
        healthStore.requestAuthorization(toShare: .none, read: setType) { (success, error) in
            
            if !success || error != nil {
                // handle error
                return
            }
            
            // handle success
        }
    }
}

func readSleep(from startDate: Date?, to endDate: Date?) -> Int {
    let healthStore = HKHealthStore()
    
    // first, we define the object type we want
    guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
        return 0
    }
    
    // we create a predicate to filter our data
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

    // I had a sortDescriptor to get the recent data first
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

    var totalInterval: Int = 0
    
    // we create our query with a block completion to execute
    let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { (query, result, error) in
        if error != nil {
            // handle error
            return
        }
        if let result = result {

            // do something with those data
            result
                .compactMap({ $0 as? HKCategorySample })
                .forEach({ sample in
                    guard let sleepValue = HKCategoryValueSleepAnalysis(rawValue: sample.value),
                          sleepValue == .asleep
                    else {
                        return
                    }
                    totalInterval += Int(sample.endDate.timeIntervalSince(sample.startDate) / 60)
                })
            UserDefaults.standard.set(totalInterval, forKey: "SleepToday")
        }
    }

    // finally, we execute our query
    healthStore.execute(query)
    return totalInterval
}


extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

struct MainView: View {

    @State var currentRoute: MainViewRouter.Route = .home
    @State var showNewTaskView = false

    var viewModel: TaskListViewModel
    var newTaskModel: NewTaskViewModel
//    var dataManager = TodoDataManager()
    init() {
        let dataManager = TodoDataManager()
        self.viewModel = TaskListViewModel(dataManager: dataManager)
        self.newTaskModel = NewTaskViewModel(dataManager: dataManager)
    }
    

    var body: some View {
            GeometryReader { geometry in
                VStack {
                    TimeStats(viewModel: viewModel)
                    if (!showNewTaskView) {
                        HomeView(viewModel: viewModel)
                        MainTabBar(size: geometry.size, currentRoute: $currentRoute) {
                            self.showNewTaskView.toggle()
                        }
                    }
                    else {
                        NewTaskView(onComplete: {
                            showNewTaskView = false
                            hideKeyboard()
                        },
                        viewModel: newTaskModel)
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color.backgroundColor)
            .onAppear {
                requestSleepAuthorization()
                _ = readSleep(from: Calendar(identifier: .iso8601).startOfDay(for: Date.now), to: Date.now)
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
