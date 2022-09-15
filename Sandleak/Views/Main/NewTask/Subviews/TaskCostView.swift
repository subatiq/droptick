//
//  TaskTitleView.swift
//  TodoApp
//
//  Created by Afees Lawal on 10/08/2020.
//

import SwiftUI


extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric , height: 150)
    }
}


struct _MultiPickerSinglePicker: View {
    let data: [ (String, [Int16]) ]
    let column: Int
    
    var body: some View {
        ForEach(0..<self.data[column].1.count, id: \.self) { row in
            Text(verbatim: "\(self.data[column].1[row])")
            .tag(self.data[column].1[row])
        }
    }
}


struct MultiPicker: View  {
    let data: [ (String, [Int16]) ]
    @Binding var selection: [Int16]

    var body: some View {
        GeometryReader {geometry in
            HStack {
                ForEach(0..<self.data.count, id: \.self) { column in
                    VStack {
                        
                        Picker(self.data[column].0, selection: self.$selection[column]) {
                            _MultiPickerSinglePicker(data: data, column: column)
                        }
                        .pickerStyle(InlinePickerStyle())
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: geometry.size.height / 1.5)
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
    let viewModel: NewTaskViewModel
    @State var manualMode = true
    
    @State var data: [(String, [Int16])] = [
            ("hours", Array(0...4)),
            ("minutes", Array([0, 10, 20, 30, 40, 50]))
        ]
    @State var selection: [Int16] = [0, 0]

    var body: some View {
        VStack(alignment: .center) {
            Text("How much time did it take?")
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(.bottom)

            VStack(alignment: .center) {
                Text(verbatim: "\(userInput)")
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
                        .frame(height: manualMode ? .infinity : 0)
                        .opacity(manualMode ? 1 : 0)
                
            }
            HStack {
                if minutesSinceLastTask() != nil && minutesSinceLastTask()! > 0 {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .frame(height: 60)
                            .foregroundColor(Color.gray.opacity(0.1))
                        Text(manualMode ? "\(minutesSinceLastTask()!) min since \"\(viewModel.todos()[0].title)\"" : "Enter manually")
                            .foregroundColor(.gray.opacity(0.7))
                            .font(.system(size: 14, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .padding(.leading)
                            .padding(.trailing)
                    }
                    .onTapGesture(perform: useMinutesSinceLastTask)
                }
                if manualMode && minutesSinceLastMarker() != nil {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .frame(height: 60)
                            .foregroundColor(Color.gray.opacity(0.1))
                        HStack {
                            Image(systemName: "bookmark.fill")
                                .foregroundColor(.gray.opacity(0.7))
                                .font(.system(size: 10, weight: .black))
                            Text("\(minutesSinceLastMarker()!) min since marker")
                                .foregroundColor(.gray.opacity(0.7))
                                .font(.system(size: 14, weight: .semibold))
                                .multilineTextAlignment(.center)
                                
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        
                    }
                    
                    .onTapGesture(perform: useMinutesSinceMarker)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
        }
    }
    
    func useMinutesSinceLastTask() -> Void {
        manualMode.toggle()
        if !manualMode {
            let sinceLast = minutesSinceLastTask()
            if sinceLast != nil {
                userInput = sinceLast!
            }
            
            else {
                manualMode.toggle()
                userInput = 0
            }
        }
        else {
            userInput = 0
        }
    }
    
    func useMinutesSinceMarker() -> Void {
        manualMode.toggle()
        if !manualMode {
            let sinceLast = minutesSinceLastMarker()
            
            if sinceLast != nil {
                userInput = sinceLast!
            }
            else {
                manualMode.toggle()
                userInput = 0
            }
        }
        else {
            userInput = 0
        }
    }
    
    func minutesSinceLastMarker() -> Int16? {
        var lastMarkerDate: Date? = nil
        let newFormatter = ISO8601DateFormatter()
        let stringMark = UserDefaults.standard.string(forKey: "lastMark")
        if stringMark != nil {
            lastMarkerDate = newFormatter.date(from: stringMark!)
        }
        else {
            return nil
        }
        
        let since = Int16(Date.now.timeIntervalSince(lastMarkerDate!) / 60)
        if since < 1 {
            return nil
        }
        return since
    }
    
    func minutesSinceLastTask() -> Int16? {
        let todos = viewModel.todos()
        if todos.count == 0 {
            return nil
        }
        return Int16(Date.now.timeIntervalSince(todos[0].createdAt) / 60)
    }
}

struct TaskCostView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCostView(taskTitle: "Build a house", userInput: .constant(0), viewModel: NewTaskViewModel(dataManager: MockDataManager()))
    }
}
