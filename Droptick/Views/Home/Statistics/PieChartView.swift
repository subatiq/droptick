//
//  PieChart.swift
//  Droptick
//
//  Created by Владимир Семенов on 9/24/22.
//

import Foundation
import SwiftUI


struct PieSliceView: View {
    var pieSliceData: PieSliceData
    
    var midRadians: Double {
        return Double.pi / 2.0 - (pieSliceData.startAngle + pieSliceData.endAngle).radians / 2.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    
                    let center = CGPoint(x: width * 0.5, y: height * 0.5)
                    
                    path.move(to: center)
                    
                    path.addArc(
                        center: center,
                        radius: width * 0.5,
                        startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle,
                        endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle,
                        clockwise: false)
                    
                }
                .fill(pieSliceData.color)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PieSliceData {
    var startAngle: Angle
    var endAngle: Angle
    var text: String
    var color: Color
}

struct PieSliceView_Previews: PreviewProvider {
    static var previews: some View {
        PieSliceView(pieSliceData: PieSliceData(startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 220.0), text: "65%", color: Color.black))
    }
}


struct PieChartView: View {
    @Environment(\.colorScheme) var colorScheme
    public let values: [Double]
    let colors: [Color] = [.chart1, .chart2, .chart3, .chart4, .chart5, .gray.opacity(0.5)]

    
    var slices: [PieSliceData] {
        let topValues = values.sorted{ $0 > $1 }.prefix(upTo: min(5, values.count))
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in topValues.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(
                PieSliceData(
                    startAngle: Angle(degrees: endDeg),
                    endAngle: Angle(degrees: endDeg + degrees),
                    text: String(format: "%.0f%%", value * 100 / sum),
                    color: colors[i]
                )
            )
            endDeg += degrees
        }
        tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: 360), text: String(format: "%.0f%%", 10), color: .gray.opacity(0.1)))
        return tempSlices
    }
    
    var body: some View {
        let slices = self.slices
        return ZStack{
            ForEach(0..<slices.count, id: \.self){i in
                PieSliceView(pieSliceData: slices[i])
            }
            Circle()
                .frame(width: 200)
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
        }
        .padding()
    }
}
