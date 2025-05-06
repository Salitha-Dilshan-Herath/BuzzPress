//
//  Comment.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-05.
//

import Foundation

struct NewsComment: Identifiable {
    let id = UUID()
    let  userImage: String // system name or asset
    let name: String
    let comment: String
    let timeAgo: String
}
