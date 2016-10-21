//
//  DepartureModel.swift
//  TrainTrippin
//
//  Created by Maciek on 19.10.2016.
//  Copyright © 2016 Fortunity. All rights reserved.
//

import Foundation

enum TrainDirection {
    case northbound
    case southbound
}

struct DepartureModel {
    var trainCode: String
    var trainType: String
    var expectedDeparture: String //  HH:mm
    var trainDirection: TrainDirection
    var fromStation: String
}
