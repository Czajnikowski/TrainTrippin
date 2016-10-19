//
//  Networking.swift
//  TrainTrippin
//
//  Created by Maciek on 19.10.2016.
//  Copyright © 2016 Fortunity. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift


class Networking {
    func request() -> Observable<(HTTPURLResponse, Data)> {
        return RxAlamofire.requestData(.get, "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByNameXML_withNumMins?StationDesc=Dalkey&NumMins=90")
    }
}
