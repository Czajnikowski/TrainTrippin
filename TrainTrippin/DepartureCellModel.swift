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
    
    init(withDeparture departure: DepartureModel) {
        trainCode = departure.trainCode
        trainType = departure.trainType
        departsIn = TimeCalculationManager.calculateDepartsIn(forDepartureTime: departure.expectedDeparture)
    }
}
