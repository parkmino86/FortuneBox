//
//  Date+Extensions.swift
//  FortuneBox
//
//  Created by minoh.park on 1/27/25.
//

import Foundation

extension Date {
    var dayOfWeekString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
