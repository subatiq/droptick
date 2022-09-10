
import AudioToolbox

class PickerManager: ObservableObject {

    private let minValue: Int
    private let maxValue: Int

    init(minValue: Int, maxValue: Int) {
        self.minValue = minValue
        self.maxValue = maxValue
    }

    @Published var userInput: Int = 0 {
        didSet {
            if userInput > maxValue || userInput < minValue {
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { return }
            }
            
        }
    }
}

class DurationPickerManager: ObservableObject {
    @Published var userInput: Int16 = 0 {
        didSet {
            if userInput == 0 {
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { return }
            }
            
        }
    }
}

