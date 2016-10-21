//
//  TimeCalculationManager.swift
//  TrainTrippin
//
//  Created by Maciek on 21.10.2016.
//  Copyright © 2016 Fortunity. All rights reserved.
//

import Foundation

class TimeCalculationManager {
    static let inputDateFormatter: DateFormatter = {
        let timeFormat = "HH:mm"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+1")
        
        return dateFormatter
    }()
    static let outputDateFormatter: DateFormatter = {
        let timeFormat = "H:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter
    }()
    
    static func calculateDepartsIn(forDepartureTime departureTime: String) -> String {
        let expectedDeparture = TimeCalculationManager.inputDateFormatter.date(from: departureTime)!
        let timeIntervalDifference = expectedDeparture.timeIntervalSinceNow
        let date = Date(timeIntervalSinceReferenceDate: timeIntervalDifference)
        
        return TimeCalculationManager.outputDateFormatter.string(from: date)
    }
}
