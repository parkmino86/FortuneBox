//
//  Fortune.swift
//  FortuneBox
//
//  Created by minoh.park on 1/18/25.
//

import Foundation

struct Fortune: Identifiable, Codable, Equatable {
    let id: String
    let text: String
    let emojis: [String]
}
