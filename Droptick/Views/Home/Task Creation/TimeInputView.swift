import SwiftUI


enum InputFocusable: Hashable {
  case focused
  case unfocused
}


public struct HourAndMinutesField: View {
    
    @Binding var minutes: Int
    @State private var enteredString: String
    @FocusState var focused: Bool
    @Binding var completed: Bool
    private var focusOnAppearance: Bool
    
    init(minutes: Binding<Int>, completed: Binding<Bool>, focusOnAppearance: Bool = true) {
        self._minutes = minutes
        self._completed = completed
        self.enteredString = ""
        self.focusOnAppearance = focusOnAppearance
        if self.minutes > 0 {
            let formatted = formatToHoursAndMinutes(totalSeconds: self.minutes * 60).replacingOccurrences(of: ":", with: "")
            self._enteredString = State(wrappedValue: formatted)
        }
    
   
    }
    
    public var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 0) {
                Text(String(self.getImageName(at: 0)))
                    .opacity(self.enteredString.count > 0 ? 1 : 0.2)
                Text(String(self.getImageName(at: 1)))
                    .opacity(self.enteredString.count > 1 ? 1 : 0.2)
                Text(":")
                    .font(.system(size: 50, weight: .black))
                    .opacity(self.enteredString.count > 1 ? 1 : 0.2)
                    .padding(.bottom, 5)
                Text(String(self.getImageName(at: 2)))
                    .opacity(self.enteredString.count > 2 ? 1 : 0.2)
                Text(String(self.getImageName(at: 3)))
                    .opacity(self.enteredString.count > 3 ? 1 : 0.2)
                
            }
            .font(.system(size: 60, weight: .black))
            backgroundField
        }
        
        .onAppear{
            focused = self.focusOnAppearance
        }
        
    }
    
    private var backgroundField: some View {
        let boundDigit = Binding<String>(get: { self.enteredString }, set: { newValue in
            self.enteredString = newValue
            if (newValue.count == 0 && enteredString.count == 4) {
                // do nothing
            }
            else {
                self.enteredString = newValue
            }
            updateTimeEntered()
            submitPin()
        })
        return TextField(self.enteredString, text: boundDigit)
           .accentColor(.clear)
           .foregroundColor(.clear)
           .font(.system(size: 60, weight: .black))
           .keyboardType(.numberPad)
           .focused($focused)
    }
    
    private func submitPin() {
        
        if self.enteredString.count > 3 {
            if self.minutes > 0 {
                focused = false
                completed = true
            }
            else {
                self.enteredString = ""
                completed = false
            }
        }
        else {
            completed = false
        }
        
    }
    
    private func updateTimeEntered() {
        guard self.enteredString.count > 0 else {
            return
        }
        if self.enteredString.count > 4 {
            self.enteredString = String(Array(self.enteredString)[4])
        }
        var defaultDigits = Array("0000")
        let enteredDigits = Array(self.enteredString)
        for (index, char) in enteredDigits.enumerated() {
            guard index < 4 else {
                continue
            }
            defaultDigits[index] = char
        }
        var hours = Int(String(defaultDigits[0...1])) ?? 0
        var minutes = Int(String(defaultDigits[2...3])) ?? 0
        
        if minutes > 59 {
            let hoursBump = minutes / 60
            hours += hoursBump
            minutes = minutes - hoursBump * 60
        }
        
        self.enteredString = String(enteredDigits)
        
        defaultDigits = Array(String(format: "%02d%02d", hours, minutes))
        self.enteredString = String(defaultDigits[0...self.enteredString.count - 1])
        self.minutes = hours * 60 + minutes
    }
    
    private func formatTime() -> String {
        var defaultString = Array("0000")

        
        for (index, char) in self.enteredString.enumerated() {
            guard index < 4 else {
                continue
            }
            defaultString[index] = char
        }
        var result = String(defaultString)
        result.insert(":", at: result.index(result.startIndex, offsetBy: 2))
        return result
    }
    
    private func getImageName(at index: Int) -> String {
        if index >= self.enteredString.count {
            return "0"
        }
        
        return self.enteredString.digits[index].numberString
    }
}

extension String {
    
    var digits: [Int] {
        var result = [Int]()
        
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        
        return result
    }
    
}

extension Int {
    
    var numberString: String {
        
        guard self < 10 else { return "0" }
        
        return String(self)
    }
}
