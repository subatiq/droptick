//
//  DroptickApp.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/12/22.
//

import SwiftUI

@main
struct DroptickApp: App {
    @State private var firsTimeLogin: Bool = UserDefaults.standard.bool(forKey: "firstTimeLogin")
    
    var body: some Scene {
        WindowGroup {

            if self.firsTimeLogin {
                ContentView()
            }
            else {
                AnyView(OnboardingView(getStartedTapped: $firsTimeLogin))

            }
        }
    }
}
