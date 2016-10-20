//
//  DepartureCellModelTests.swift
//  TrainTrippin
//
//  Created by Maciek on 19.10.2016.
//  Copyright © 2016 Fortunity. All rights reserved.
//

@testable import TrainTrippin
import XCTest
import AFDateHelper

class DepartureCellModelTests: XCTestCase {
    func testDepartsIn15MinutesFromNow() {
        let date15MinutesAhead = Date().dateByAddingMinutes(15)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.timeZone = TimeZone(secondsFromGMT: 3600)
        let dateString = timeFormatter.string(from: date15MinutesAhead)
        let givenDepartureModel = DepartureModel(trainCode: "traincode", trainType: "traintype", expectedDeparture: dateString)
        
        let departureCellModelSUT = DepartureCellModel(withDeparture: givenDepartureModel)
        
        XCTAssert(departureCellModelSUT.departsIn.hasPrefix("0:14:") || departureCellModelSUT.departsIn.hasPrefix("0:15:"))
    }
}
