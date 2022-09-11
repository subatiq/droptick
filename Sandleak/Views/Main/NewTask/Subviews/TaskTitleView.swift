//
//  TaskTitleView.swift
//  TodoApp
//
//  Created by Afees Lawal on 10/08/2020.
//

import SwiftUI


class HoursAndMinutesFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        guard let string = obj as? String else { return "x" }
        
        return String(string)
    }
    
    override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
     
        let value: String
        if String(string).count > 4 {
            value = String(string[...String.Index(encodedOffset: 4)])
        } else {
            value = string
        }
        obj?.pointee = value as AnyObject
        return true
    }
    
    
}


struct TaskTitleView: View {

    @Binding var userInput: String
    @Binding var duration: Int
    @Binding var submitted: Bool
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    enum FocusField: Hashable {
        case title, duration
      }

    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        VStack(alignment: .center) {
            if !submitted {
            Text("What have you done?")
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.gray)
                .padding(.bottom)
            }
            TextField("", text: $userInput, onEditingChanged: { (editingChanged) in
                if editingChanged {
                    // focused
                    focusedField = .title
                    submitted = false
                } else {
                    // unfocused
                    if userInput.count > 0 {
                        submitted = true
                    }
                    focusedField = .duration
                }
            })
                .frame(height: 60)
                .background(Color.gray.opacity(submitted ? 0 : 0.1).cornerRadius(10))
                .font(.system(size: 26, weight: .black))
                .multilineTextAlignment(.center)
                .padding(.leading)
                .padding(.trailing)
                .focused($focusedField, equals: .title)
                .onSubmit {
                    submitted = true
                    focusedField = .duration
                }
//
//            Text("Minutes duration")
//                .multilineTextAlignment(.center)
//                .font(.system(size: 16, weight: .medium))
//                .foregroundColor(Color.gray)
//                .padding(.bottom)
//
//            TextField("xxxx", value: $duration, formatter: HoursAndMinutesFormatter())
//                .keyboardType(.numberPad)
//                .frame(height: 60)
//                .background(Color.gray.opacity(0.1).cornerRadius(10))
//                .font(.system(size: 26, weight: .black))
//                .foregroundColor(.black)
//                .multilineTextAlignment(.center)
//                .padding(.leading)
//                .padding(.trailing)
//                .focused($focusedField, equals: .duration)
                
        }
        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
                    self.focusedField = .title
                    self.submitted = false
//               }
        }
        .onDisappear {
            self.focusedField = .duration
        }
    }
}


struct TaskTitleView_Previews: PreviewProvider {
    static var previews: some View {
        TaskTitleView(userInput: .constant(""), duration: .constant(0), submitted: .constant(false))
    }
}
