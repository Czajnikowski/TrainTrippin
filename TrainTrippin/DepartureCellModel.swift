//
//  DepartureCellModel.swift
//  TrainTrippin
//
//  Created by Maciek on 19.10.2016.
//  Copyright © 2016 Fortunity. All rights reserved.
//

import RxCocoa
import RxSwift
import SWXMLHash

protocol DepartureCellModelType {
    var trainCode: String { get }
    var trainType: String { get }
    var departsIn: String { get }
}

struct DepartureCellModel: DepartureCellModelType {
    let trainCode: String
    let trainType: String
    let departsIn: String
    
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
    
    
    let calculateDepartsIn: (DepartureModel) -> String = { departure in
        let expectedDeparture = DepartureCellModel.inputDateFormatter.date(from: departure.expectedDeparture)!
        let now = Date()
        let timeIntervalDifference = expectedDeparture.timeIntervalSinceNow
        let date = Date(timeIntervalSinceReferenceDate: timeIntervalDifference)
        
        return DepartureCellModel.outputDateFormatter.string(from: date)
    }
    
    init(withDeparture departure: DepartureModel) {
        trainCode = departure.trainCode
        trainType = departure.trainType
        
        departsIn = calculateDepartsIn(departure)
    }
}
