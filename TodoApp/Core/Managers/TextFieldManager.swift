//
//  TextFieldManager.swift
//  TodoApp
//
//  Created by Punit Kumar on 04/03/2026.
//

import AudioToolbox

class TextFieldManager: ObservableObject {
    private let characterLimit: Int

    init(characterLimit: Int) {
        self.characterLimit = characterLimit
    }

    @Published var userInput: String = "" {
        didSet {
            if userInput.count > characterLimit {
                userInput = String(userInput.prefix(characterLimit))
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { return }
            }
        }
    }
}
