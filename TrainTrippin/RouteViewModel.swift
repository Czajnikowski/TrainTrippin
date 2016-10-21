//
//  RouteViewController.swift
//  TrainTrippin
//
//  Created by Maciek on 21.10.2016.
//  Copyright © 2016 Fortunity. All rights reserved.
//

import Foundation

class RouteViewModel: NSObject {
    let departureModel: DepartureModel
    
    init(withDepartureModel departureModel: DepartureModel) {
        self.departureModel = departureModel
    }
}
