//
//  DroptickApp.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/12/22.
//

import SwiftUI

@main
struct DroptickApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
