//
//  RegularButton.swift
//  Droptick
//
//  Created by Владимир Семенов on 11/12/22.
//

import SwiftUI

struct RegularButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .fontWeight(.bold)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.gray)
            )
            .foregroundColor(.primary)
    }
}


struct AddTaskButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .fontWeight(.bold)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(LinearGradient(gradient: Gradient(colors: [.secondary, .accentColor, .secondary]), startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .foregroundColor(.white)
            
    }
}
