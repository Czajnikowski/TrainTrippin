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
    
    struct TimeFormat {
        static let inputDateFormat = "HH:mm"
        static let outputTimeFormat = "H:mm:ss"
    }
    
    static let inputDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TimeFormat.inputDateFormat
        
        return dateFormatter
    }()
    static let outputDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TimeFormat.outputTimeFormat
        
        return dateFormatter
    }()
    
    
    let calculateDepartsIn: (DepartureModel) -> String = { departure in
        let expectedDeparture = DepartureCellModel.inputDateFormatter.date(from: departure.expectedDeparture)!
        let timeIntervalDifference = expectedDeparture.timeIntervalSinceNow
        let date = Date(timeIntervalSince1970: timeIntervalDifference)
        
        return DepartureCellModel.outputDateFormatter.string(from: date)
    }
    
    init(withDeparture departure: DepartureModel) {
        trainCode = departure.trainCode
        trainType = departure.trainType
        
        departsIn = calculateDepartsIn(departure)
    }
}
