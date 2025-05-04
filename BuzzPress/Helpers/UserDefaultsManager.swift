//
//  UserDefaultsManager.swift
//  BuzzPress
//
//  Created by user269828 on 5/3/25.
//

import Foundation

class UserDefaultsManager {
    static func saveGuestSelection(_ selection: UserSelection) {
        if let encoded = try? JSONEncoder().encode(selection) {
            UserDefaults.standard.set(encoded, forKey: "guestSelection")
        }
    }

    static func getGuestSelection() -> UserSelection? {
        guard let data = UserDefaults.standard.data(forKey: "guestSelection"),
              let decoded = try? JSONDecoder().decode(UserSelection.self, from: data) else {
            return nil
        }
        return decoded
    }
}
