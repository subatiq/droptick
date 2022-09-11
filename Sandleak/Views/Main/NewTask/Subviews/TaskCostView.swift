//
//  TaskTitleView.swift
//  TodoApp
//
//  Created by Afees Lawal on 10/08/2020.
//

import SwiftUI


struct _MultiPickerSinglePicker: View {
    let data: [ (String, [Int16]) ]
    let column: Int
    
    var body: some View {
        ForEach(0..<self.data[column].1.count) { row in
            Text(verbatim: "\(self.data[column].1[row])")
            .tag(self.data[column].1[row])
        }
    }
}


struct MultiPicker: View  {
    let data: [ (String, [Int16]) ]
    @Binding var selection: [Int16]

    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(0..<self.data.count) { column in
                    VStack {
                        
                        Picker(self.data[column].0, selection: self.$selection[column]) {
                            _MultiPickerSinglePicker(data: data, column: column)
                        }
                        .pickerStyle(InlinePickerStyle())
                        .frame(width: geometry.size.width / CGFloat(self.data.count), height: geometry.size.height / 1.5)
                        .clipped()
                        Text(self.data[column].0)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
            }
        }
    }
}


struct TaskCostView: View {

    let taskTitle: String
    @Binding var userInput: Int16

    private var cost: Binding<Int16> {
        Binding<Int16>(
        get: {
            return selection[0] * 60 + selection[1]
        },
        set: {
            self.userInput = $0
        })
                     
    }
    
    @State var data: [(String, [Int16])] = [
            ("hours", Array(0...8)),
            ("minutes", Array([0, 10, 20, 30, 40, 50]))
        ]
    @State var selection: [Int16] = [0, 0]

    var body: some View {
        VStack(alignment: .center) {
            Text("How much time did you spend on it today?")
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(.bottom)

            VStack(alignment: .center) {
                
                Text(verbatim: "\(cost.wrappedValue)")
                    .fontWeight(.black)
                    .font(.system(size: 48))
                Text(verbatim: "minutes".uppercased())
                    .fontWeight(.black)
                    .font(.system(size: 20))
                    .foregroundColor(Color.gray)
                MultiPicker(data: data, selection: $selection).frame(height: 300)
                    .onChange(of: selection) {
                        _ in
                        userInput = selection[0] * 60 + selection[1]
                    }
            }
        }
    }
}

struct TaskCostView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCostView(taskTitle: "Build a house", userInput: .constant(0))
    }
}
