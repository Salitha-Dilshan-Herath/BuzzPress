//
//  utility.swift
//  BuzzPress
//
//  Created by Spemai on 2025-04-27.
//
import Foundation

extension UserDefaults {
    private enum Keys {
        static let hasLaunchedBefore = "hasLaunchedBefore"
    }

    static var isFirstLaunch: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: Keys.hasLaunchedBefore)
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: Keys.hasLaunchedBefore)
        }
    }
}
