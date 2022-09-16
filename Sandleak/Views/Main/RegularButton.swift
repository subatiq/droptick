//
//  TaskCell.swift
//  TodoApp
//
//  Created by Afees Lawal on 06/08/2020.
//

import SwiftUI

struct RegularButton: View {

//    let todo: Todo
    let text: String
    let action: (() -> Void)
    @State private var tapped = false

//    var onToggleCompletedTask: (() -> Void)?
//    var onToggleSetReminder: (() -> Void)?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(.yellow.opacity(0.2))
                .scaleEffect(tapped ? 1.5 : 1)
                .opacity(tapped ? 1 : 0)
                .frame(height: 60)
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(tapped ? .white : .accent.opacity(tapped ? 0.9 : 1))
                .frame(height: 60)
            Text(text.uppercased())
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black.opacity(0.9))
        }
        .scaleEffect(tapped ? 1.1 : 1)
        .animation(.spring(response: 0.4, dampingFraction: 0.9))
        .onTapGesture {
            action()
            tapped = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tapped = false
            }
            
        }
        
    }
}

struct RegularButton_Previews: PreviewProvider {
    static var previews: some View {
        RegularButton(text: "Test", action: {})
//            .preferredColorScheme(.dark)
    }
}
