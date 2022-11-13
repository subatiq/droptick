//
//  TaskCell.swift
//  TodoApp
//
//  Created by Afees Lawal on 06/08/2020.
//


import SwiftUI


struct TimeStats: View {
    let secondsPassed: Int
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .trailing) {
                    Text("Time untracked".uppercased())
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                    HStack(alignment: .bottom) {
                        Text(String(format: "%02d:%02d", convertToHours(seconds:secondsPassed), convertToMinutes(seconds:secondsPassed)))
                            .font(.system(size: 60, weight: .black))
                    }
                    Text(String(format: ":%02d",convertToSeconds(seconds:secondsPassed)))
                        .font(.system(size: 40, weight: .black))
                        .foregroundColor(.accentColor)
                    
                }
                .multilineTextAlignment(.trailing)

            }
        }
        
        
        
    }
}
