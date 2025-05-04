//
//  utility.swift
//  BuzzPress
//
//  Created by Spemai on 2025-04-27.
//
import Foundation


struct Utility {
    static func publishedAgo(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: isoDate) else {
            return ""
        }
        
        let now = Date()
        let diff = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: date, to: now)
        
        if let year = diff.year, year > 0 {
            return "\(year)y ago"
        } else if let month = diff.month, month > 0 {
            return "\(month)mo ago"
        } else if let day = diff.day, day > 0 {
            return "\(day)d ago"
        } else if let hour = diff.hour, hour > 0 {
            return "\(hour)h ago"
        } else if let minute = diff.minute, minute > 0 {
            return "\(minute)m ago"
        } else {
            return "Just now"
        }
    }
    
    
    
    static func extractDomain(urlString: String) -> String? {
        guard let url = URL(string: urlString),
              let host = url.host else {
            return nil
        }
        
        // Remove www. prefix if exists
        let domain = host.replacingOccurrences(of: "www.", with: "")
        return domain
    }
}
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
