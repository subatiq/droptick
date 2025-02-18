//
//  StatsButton.swift
//  Droptick
//
//  Created by Владимир Семенов on 9/25/22.
//

import Foundation
import SwiftUI

struct StatsButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.12))
                    .frame(width: 60, height: 60)
                    .cornerRadius(20)
                Image(systemName: "chart.xyaxis.line")
                    .font(.system(size: 22))
                    .foregroundColor(.primary)
            }
            
        }
    }
}
