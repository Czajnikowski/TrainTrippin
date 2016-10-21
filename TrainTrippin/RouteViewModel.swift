//
//  RouteViewController.swift
//  TrainTrippin
//
//  Created by Maciek on 21.10.2016.
//  Copyright © 2016 Fortunity. All rights reserved.
//

import Foundation

class RouteViewModel: NSObject {
    let departsIn: String
    let trainInfo: String
    let trainDirection: String
    let departureTime: String
    let departureStation: String
    
    
    init(withDepartureModel departureModel: DepartureModel) {
        departsIn = TimeCalculationManager.calculateDepartsIn(forDepartureTime: departureModel.expectedDeparture)
        trainInfo = departureModel.trainType + " " + departureModel.trainCode
        trainDirection = "Train from " + departureModel.fromStation + " towards " + (departureModel.trainDirection == .northbound ? "Broombridge" : "Dalkey")
        departureTime = departureModel.expectedDeparture
        departureStation = departureModel.fromStation
    }
}
