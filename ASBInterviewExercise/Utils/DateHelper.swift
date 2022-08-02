//
//  DateHelper.swift
//  ASBInterviewExercise
//
//  Created by Paresh Kacha on 2/08/22.
//

import Foundation
class DateHelper {
    
    static let parsingFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    private static let dateFormateStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm"
        return formatter
    }()
    
    private static let fullDateFormateStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        return formatter
    }()
    
    static func parse(_ date: String?) -> Date? {
        guard let date = date else {
            return nil
        }
        return parsingFormatter.date(from: date)
    }

    static func formatTransTime(_ date: Date) -> String {
        return dateFormateStyle.string(from: date)
    }
    
    static func shortDateFormate(_ date: String) -> String{
        guard let convertedDate = parse(date) else {
            return ""
        }
        return dateFormateStyle.string(from: convertedDate)
    }
    static func fullDateFormate(_ date: String) -> String{
        guard let convertedDate = parse(date) else {
            return ""
        }
        return fullDateFormateStyle.string(from: convertedDate)
    }
}
