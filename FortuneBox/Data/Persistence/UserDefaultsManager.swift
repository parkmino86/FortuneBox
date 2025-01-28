//
//  UserDefaultsManager.swift
//  FortuneBox
//
//  Created by minoh.park on 1/28/25.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userDefaults: UserDefaults

    private init() {
        self.userDefaults = UserDefaults(suiteName: Secrets.suiteName)!
    }
}

extension UserDefaultsManager {
    private enum Keys {
        static let fortune = "fortune"
    }

    var fortune: Fortune? {
        get {
            guard let data = userDefaults.dictionary(forKey: Keys.fortune) else {
                return nil
            }
            guard
                let id = data["id"] as? String,
                let text = data["text"] as? String,
                let emojis = data["emojis"] as? [String]
            else {
                return nil
            }
            return Fortune(id: id, text: text, emojis: emojis)
        }
        set {
            guard let newValue = newValue else {
                userDefaults.removeObject(forKey: Keys.fortune)
                return
            }
            let data: [String: Any] = [
                "id": newValue.id,
                "text": newValue.text,
                "emojis": newValue.emojis
            ]
            userDefaults.set(data, forKey: Keys.fortune)
        }
    }
}
