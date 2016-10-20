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
import Alamofire


class Networking {
    typealias Response = (HTTPURLResponse, Data)
    
    struct APIurl {
        static let departuresFromDalkeyURL = URL(string: "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByNameXML_withNumMins?StationDesc=Dalkey&NumMins=90")!
        static let departuresFromBroombridgeURL = URL(string: "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByNameXML_withNumMins?StationDesc=Broombridge&NumMins=90")!
    }
    
    init() {
        let urlCache = URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        URLCache.shared = urlCache
    }
    
    func requestTrainsFromDalkey() -> Observable<Response> {
        return request(withURL: APIurl.departuresFromDalkeyURL)
    }
    
    func requestTrainsFromBroombridge() -> Observable<Response> {
        return request(withURL: APIurl.departuresFromBroombridgeURL)
    }
    
    //test it?
    private func request(withURL url: URL) -> Observable<Response> {
        let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url))
        if let cachedResponse = cachedResponse {
            let subject = BehaviorSubject(value: (cachedResponse.response as! HTTPURLResponse, cachedResponse.data))
            
            _ = requestData(.get, url)
                .subscribe(onNext: { (response) in
                    URLCache.shared.storeCachedResponse(CachedURLResponse(response: response.0, data: response.1), for: URLRequest(url: url))
                    subject.onNext(response)
                    }
                )
            
            return subject
        }
        else {
            return requestData(.get, url)
                .do(onNext: { (response) in
                    URLCache.shared.storeCachedResponse(CachedURLResponse(response: response.0, data: response.1), for: URLRequest(url: url))
                }
            )
        }
    }
}
