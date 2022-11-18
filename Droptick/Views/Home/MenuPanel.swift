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
                    .foregroundColor(switched ? .accentColor : .white.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .cornerRadius(20)
                Image(systemName: "pencil.line")
                    .foregroundColor(.white)
                    .font(.system(size: 35))
            }
            
        }
    }
}



struct MenuPanel: View {
    @Binding var fullListShown: Bool
    
    var body: some View {
        VStack {
            SwitchListMenuButton(switched: $fullListShown)
        }
    }
}

