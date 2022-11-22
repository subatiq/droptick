//
//  MenuPanel.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/18/22.
//

import SwiftUI


struct SwitchListMenuButton: View {
    @Binding var switched: Bool
    
    var body: some View {
        Button() {
            switched.toggle()
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(switched ? .accentColor : .gray.opacity(0.12))
                    .frame(width: 50, height: 50)
                    .cornerRadius(15)
                Image(systemName: "pencil.line")
                    .font(.system(size: 22))
            }
            
        }
    }
}



struct MenuPanel: View {
    var timeTracker: TimeTrackerViewModel
    @Binding var fullListShown: Bool
    @State var showingStats: Bool = false
    
    var body: some View {
        HStack {
            StatsButton {showingStats.toggle()}
                .sheet(isPresented: $showingStats) {
                    StatisticsView(timeTracker: timeTracker)
                }
            Spacer()
            SwitchListMenuButton(switched: $fullListShown)
            
        }
    }
}

